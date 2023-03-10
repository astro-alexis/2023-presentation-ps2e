#!/usr/bin/env python3
# coding: utf-8

import numpy as np
import matplotlib.pyplot as plt
from astropy.io import fits
import sys

f, col = sys.argv[1], sys.argv[2]
plt.rcParams['font.size'] = 16
plt.rcParams['figure.figsize'] = [12, 6]
o = fits.open(f)

w,s= [],[]
chip = ['CHIP1.INT1', 'CHIP2.INT1', 'CHIP3.INT1']
d = [o[chip[0]].data,o[chip[1]].data,o[chip[2]].data]
for i in range(3):
	cpw = np.sort([i for i in d[i].dtype.names if "WL" in i])
	cpi = np.sort([i for i in d[i].dtype.names if "SPEC" in i])
	for j in range(len(cpw)):
		plt.plot(d[i][cpw[j]][8:-8], d[i][cpi[j]][8:-8], linewidth=1, color=col)
		w,s = np.append(w,d[i][cpw[j]]),np.append(s,d[i][cpi[j]])
plt.ylim(-50, np.percentile(1.4*np.nan_to_num(s),98))
plt.xlabel("Wavelength (nm)")
plt.ylabel('Extracted spectrum')
plt.savefig(f+'.png')
