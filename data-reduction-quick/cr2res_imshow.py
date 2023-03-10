#!/usr/bin/env python3
# coding: utf-8

import numpy as np
import matplotlib.pyplot as plt
from astropy.io import fits
import sys

f = sys.argv[1]
plt.rcParams['figure.figsize'] = [16, 6]
o = fits.open(f)

chip = ['CHIP1.INT1', 'CHIP2.INT1', 'CHIP3.INT1']
d = [o[chip[0]].data,o[chip[1]].data,o[chip[2]].data]
vmax = np.max([np.percentile(1.3*np.nan_to_num(d[0]),98), np.percentile(1.3*np.nan_to_num(d[1]),98), np.percentile(1.3*np.nan_to_num(d[2]),98)])

fig,ax = plt.subplots(1,3)
for i in range(3):
	ax[i].imshow(np.nan_to_num(d[i]), origin="lower", vmin=0, vmax=vmax)
plt.suptitle(o[0].header['OBJECT'] + ' | ' + o[0].header['HIERARCH ESO INS WLEN ID'])
#plt.show()
plt.savefig(f+'.png')

