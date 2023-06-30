# AnalyzeMicroelectrodeData
Code written and maintained by Connor Beck
    Updated June 2023
    
A MATLAB software package for analyzing microelectrode data from multichannel systems

This code is a linear approach to microelectrode analysis. 
  (1) - load_MEA()          : '.h5' files from Multichannel Systems software are input into MATLAB
  (2) - filterElectrodes()  : the electrodes are filtered (typically bandpass - 300-4000Hz)
  (3) - RemoveElectrodes()  : electrodes without cells or faulty/noisy electrodes are removed.
  (4) - SpikeDetection()    : Signals are processed with falling edge detection.

Work to be done:
Time dynamic standard deviation detection for spike detection.
