Computer-Vision-Lung-Cancer-Detection
=====================================

This code is part of the 2013 REU with Depaul University and University of Chicago.
The image processing code was lead by Patrick Stein. 
The machine learning code was lead by Ethan Smith.
The results of this research were published at the 2013 International Conference on Machine Learning Applications.
Paper can be found at http://ieeexplore.ieee.org/xpl/login.jsp?tp=&arnumber=6786163&url=http%3A%2F%2Fieeexplore.ieee.org%2Fxpls%2Fabs_all.jsp%3Farnumber%3D6786163

This code makes an alteration in the process of diagnosing lung cancer nodules. The typical process is as follows:
-The human expert (radiologist) reviews the CT scan and identifies the presence/absense of nodules.
-The human draws a border around each nodule
-The computer uses image processing to turn the contents of that border into data
-The computer uses that data to make predictions about the nature of the nodule (malignant, etc.)
-The human performs his own evaluation of the nodule
-The human uses the computer's predictions as a second opinion, and re examines the CT scan.
-The human makes his final decision and writes a report
-The report is sent to an oncologist who uses it to make the final diagnosis

The step where the radiologist draws the pixel by pixel border around the nodule is expensive due to the time required by a specialist doctor.
The process used in this research speeds up this process, by replacing this 'hard' border with a simple dot identifying the center of the nodule, and then uses several imaging processing methods to form several 'weak segmentations'.
Then the machine learning process learns which combination of these weak segmentations tends to be the best at identifying nodules.
This weak segmentation is used, processed into data, and then used by machine learning classifiers to make predictions.

In our experiments this method performed quite well and actually performed better than using the hard borders. 
This can greatly aid research in automated cancer detection by reducing the cost needed to obtain data to train on.
This can also reduce the final cost of healthcare.
