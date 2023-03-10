import numpy as np
from astroquery.eso import Eso
import sys, os

print("\n[info] You should edit your ESO username in the code as eso.login('your-username')\n")
eso = Eso()
eso.ROW_LIMIT = -1
eso.login("alavail") # Replace with your own ESO user portal login

# If you need, you can print the help for CRIRES query
#eso.query_instrument('crires', help=True) 

print('\n\n')
# Query the ESO archive for CRIRES data
data = eso.query_instrument('crires',
        column_filters={
            'stime' : "2021-10-01", 'starttime' : '00', # taken after this date
            'etime': "2022-03-13", 'endtime' : '24', # before this date
            'dp_cat' : 'SCIENCE'}, # is a SCIENCE product
        columns=['prog_title'], # and fetch the Programme Title
        cache=False
    )

# Isolate proposal titles and print them
print("\nCRIRES+ proposals with data being public as per today")
print("------")
proposal_titles = np.unique(data['Proposal Title'])
for i in proposal_titles:
    print(i)

input()
print("\n\n")
# Query the ESO archive for CRIRES data
data = eso.query_instrument('crires',
        column_filters={
            'stime' : "2021-10-01", 'starttime' : '00', # taken after this date
            'etime': "2023-03-14", 'endtime' : '24', # before this date
            'dp_cat' : 'SCIENCE'}, # is a SCIENCE product
        columns=['prog_title'], # and fetch the Programme Title
        cache=False
    )

# Isolate proposal titles and print them
print(' ')
print("All accepted CRIRES+ proposals with data - either public or proprietary")
print("------")
proposal_titles = np.unique(data['Proposal Title'])
for i in proposal_titles:
    print(i)

