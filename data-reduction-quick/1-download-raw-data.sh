#!/bin/sh

usage () {
    cat <<__EOF__
usage: $(basename $0) [-hlp] [-u user] [-X args] [-d args]
  -h        print this help text
  -l        print list of files to download
  -p        prompt for password
  -u user   download as a different user
  -X args   extra arguments to pass to xargs
  -d args   extra arguments to pass to the download program

__EOF__
}

hostname=dataportal.eso.org
username=alavail
anonymous=
xargsopts=
prompt=
list=
while getopts hlpu:xX:d: option
do
    case $option in
	h) usage; exit ;;
	l) list=yes ;;
	p) prompt=yes ;;
	u) prompt=yes; username="$OPTARG" ;;
	X) xargsopts="$OPTARG" ;;
	d) download_opts="$OPTARG";;
	?) usage; exit 2 ;;
    esac
done

if [ "$username" = "anonymous" ]; then
    anonymous=yes
fi

if [ -z "$xargsopts" ]; then
    #no xargs option specified, we ensure that only one url
    #after the other will be used
    xargsopts='-L 1'
fi

netrc=$HOME/.netrc
if [ -z "$anonymous" -a -z "$prompt" ]; then
    # take password (and user) from netrc if no -p option
    if [ -f "$netrc" -a -r "$netrc" ]; then
	grep -ir "$hostname" "$netrc" > /dev/null
	if [ $? -ne 0 ]; then
            #no entry for $hostname, user is prompted for password
            echo "A .netrc is available but there is no entry for $hostname, add an entry as follows if you want to use it:"
            echo "machine $hostname login alavail password _yourpassword_"
            prompt="yes"
	fi
    else
	prompt="yes"
    fi
fi

if [ -n "$prompt" -a -z "$list" ]; then
    trap 'stty echo 2>/dev/null; echo "Cancelled."; exit 1' INT HUP TERM
    stty -echo 2>/dev/null
    printf 'Password: '
    read password
    echo ''
    stty echo 2>/dev/null
    escaped_password=${password//\%/\%25}
    auth_check=$(wget -O - --post-data "username=$username&password=$escaped_password" --server-response --no-check-certificate "https://www.eso.org/sso/oidc/accessToken?grant_type=password&client_id=clientid" 2>&1 | awk '/^  HTTP/{print $2}')
    if [ ! $auth_check -eq 200 ]
    then
        echo 'Invalid password!'
        exit 1
    fi
fi

# use a tempfile to which only user has access 
tempfile=`mktemp /tmp/dl.XXXXXXXX 2>/dev/null`
test "$tempfile" -a -f $tempfile || {
    tempfile=/tmp/dl.$$
    ( umask 077 && : >$tempfile )
}
trap 'rm -f $tempfile' EXIT INT HUP TERM

echo "auth_no_challenge=on" > $tempfile
# older OSs do not seem to include the required CA certificates for ESO
echo "check_certificate=off" >> $tempfile
echo "content_disposition=on" >> $tempfile
echo "continue=on" >> $tempfile
if [ -z "$anonymous" -a -n "$prompt" ]; then
    echo "http_user=$username" >> $tempfile
    echo "http_password=$password" >> $tempfile
fi
WGETRC=$tempfile; export WGETRC

unset password

if [ -n "$list" ]; then
    cat
else
    xargs $xargsopts wget $download_opts 
fi <<'__EOF__'
https://archive.eso.org/downloadportalapi/readme/6af55f3d-7033-4b73-997a-2997adbd4127
https://archive.eso.org/downloadportalapi/calibrationxml/6af55f3d-7033-4b73-997a-2997adbd4127/CRIRE.2021-10-26T23:42:44.753_raw2raw.xml
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-27T11:08:20.728
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-27T11:08:35.134
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-27T11:19:21.250
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-27T11:26:13.101
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-27T11:11:47.934
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-26T23:42:44.753
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-27T11:25:38.159
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-27T11:17:59.564
https://dataportal.eso.org/dataportal_new/file/M.CRIRES.2021-10-12T09:09:45.716
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-27T11:08:49.535
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-27T11:25:55.633
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-26T23:44:04.737
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-27T11:15:42.624
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-27T11:16:51.102
https://dataportal.eso.org/dataportal_new/file/M.CRIRES.2021-10-14T10:33:25.230
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-27T11:21:26.877
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-27T11:10:23.848
https://dataportal.eso.org/dataportal_new/file/CRIRE.2021-10-27T11:23:32.499
__EOF__
