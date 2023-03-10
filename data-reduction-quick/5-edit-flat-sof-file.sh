# Add needed calibration files to the flat recipe SOF file
# The Bad Pixel Mask from the dark recipe
echo "01_darks/cr2res_cal_dark_Y1029_3x3_bpm.fits CAL_DARK_BPM" >> 02_flats.sof

# The master Dark frame
echo "01_darks/cr2res_cal_dark_Y1029_3x3_master.fits CAL_DARK_BPM" >> 02_flats.sof

# And the Trace Wave file from static calibration (provided with pipeline)
# The TW contains the location of the spectral orders on the detectors,
# the wavelength solution, and the tilt of the slit
echo "static/Y1029_tw.fits" >> 02_flats.sof

