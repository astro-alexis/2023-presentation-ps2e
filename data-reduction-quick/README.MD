This directory contains a quick experiment to reduce a dataset of public CRIRES+ data. The science data consists of two spectra of AU Mic taken in A and B nodding positions in the Y1029 wavelength setting. These are dirty scripts with hardcoded filenames, just so you know. I encourage you to look at the scripts and see what happens.

## Prerequisites

To make eveything work, you will need to have installed and running:
- the CRIRES pipeline and esorex
- python3 (and some packages: astropy, matplotlib, numpy, astroquery)
- the command line utilities `dfits` and `fitsort` (can be installed easily on linux with the qfits-tools package)
- gunzip

I am running scripts with bash.

You also need an account with the ESO user portal and to know your username (login)

## Download and inspect data

There are two main ways to download data from the ESO archive:
- via the ESO archive query form at http://archive.eso.org/wdb/wdb/eso/crires/form
- using the astroquery.eso python package, see https://astroquery.readthedocs.io/en/latest/eso/eso.html

For this experiment, I have already copied a bash script that downloads the raw science data from the ESO archive as well as all corresponding raw calibrations. The script is `1-download-raw-data.sh`. You need to edit the file and replace "username=alavail" with your own ESO username
Download the data by running `bash 1-download-raw-data.sh`. Then, unzip the files by running `2-gunzip-all-files.sh`.

You can see which raw files are what by running the dfits and fitsort commands e.g `dfits CR*fits | fitsort OBJECT INS.WLEN.ID DET.NDIT DET.SEQ1.DIT AOS.RTC.LOOP.STATE` which should return

FILE                                    OBJECT          INS.WLEN.ID     DET.NDIT        DET.SEQ1.DIT    AOS.RTC.LOOP.STATE
CRIRE.2021-10-26T23:42:44.753.fits      AU Mic          Y1029           3               20.000000       CLOSED            
CRIRE.2021-10-26T23:44:04.737.fits      AU Mic          Y1029           3               20.000000       CLOSED            
CRIRE.2021-10-27T11:08:20.728.fits      FLAT            Y1029           3               3.000000        OPEN              
CRIRE.2021-10-27T11:08:35.134.fits      FLAT            Y1029           3               3.000000        OPEN              
CRIRE.2021-10-27T11:08:49.535.fits      FLAT            Y1029           3               3.000000        OPEN              
CRIRE.2021-10-27T11:10:23.848.fits      WAVE,UNE        Y1029           3               20.000000       OPEN              
CRIRE.2021-10-27T11:11:47.934.fits      WAVE,FPET       Y1029           1               120.000000      OPEN              
CRIRE.2021-10-27T11:15:42.624.fits      DARK            Y1029           3               20.000000       OPEN              
CRIRE.2021-10-27T11:16:51.102.fits      DARK            Y1029           3               20.000000       OPEN              
CRIRE.2021-10-27T11:17:59.564.fits      DARK            Y1029           3               20.000000       OPEN              
CRIRE.2021-10-27T11:19:21.250.fits      DARK            Y1029           1               120.000000      OPEN              
CRIRE.2021-10-27T11:21:26.877.fits      DARK            Y1029           1               120.000000      OPEN              
CRIRE.2021-10-27T11:23:32.499.fits      DARK            Y1029           1               120.000000      OPEN              
CRIRE.2021-10-27T11:25:38.159.fits      DARK            Y1029           3               3.000000        OPEN              
CRIRE.2021-10-27T11:25:55.633.fits      DARK            Y1029           3               3.000000        OPEN              
CRIRE.2021-10-27T11:26:13.101.fits      DARK            Y1029           3               3.000000        OPEN 

where 
- FILE is filename
- OBJECT is the kind of data
- INS.WLEN.ID  is the wavelength setting
- DET.NDIT the number of exposures used
- DET.SEQ1.DIT the integration time in second for each exposure
- AOS.RTC.LOOP.STATE the state of the AO loop (OPEN: no AO, CLOSED: AO)

## Reduce calibrations

`bash 3-prepare-sof-files.sh` starts preparing the SOF files (input files) for the calibration pipeline recipes. 

`bash 4-run-dark-recipe.sh` reduces the DARK frames.

`bash 5-edit-flat-sof-file.sh` finalizes the SOF file for the FLAT pipeline recipe

`bash 6-run-flat-recipe.sh`runs the FLAT recipe

`bash 7-prepare-science-sof-file.sh` creates the SOF file for the science reduction

`bash 8-reduce-science.sh` runs the obs_nodding recipe which reduces the science files
  



