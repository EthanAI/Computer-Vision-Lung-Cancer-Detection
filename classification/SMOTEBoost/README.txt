******************************************************************************
			Author: Barnan Das
			Email: barnandas@wsu.edu
			Homepage: www.eecs.wsu.edu/~bdas1
			Last Updated: June 25, 2012
******************************************************************************

Description of Algorithm:
This code implements SMOTEBoost. SMOTEBoost is an algorithm to handle class 
imbalance problem in data with discrete class labels. It uses a combination of 
SMOTE and the standard boosting procedure AdaBoost to better model the minority 
class by providing the learner not only with the minority class examples that 
were misclassified in the previous boosting iteration but also with broader 
representation of those instances (achieved by SMOTE). Since boosting 
algorithms give equal weight to all misclassified examples and sample from a 
pool of data that predominantly consists of majority class, subsequent sampling 
of the training set is still skewed towards the majority class. Thus, to reduce 
the bias inherent in the learning procedure due to class imbalance and to 
increase the sampling weights of minority class, SMOTE is introduced at each 
round of boosting. Introduction of SMOTE increases the number of minority class 
samples for the learner and focus on these cases in the distribution at each 
boosting round. In addition to maximizing the margin for the skewed class 
dataset, this procedure also increases the diversity among the classifiers in 
the ensemble because at each iteration a different set of synthetic samples are 
produced. 

For more detail on the theoretical description of the algorithm please refer to 
the following paper:
N.V. Chawla, A.Lazarevic, L.O. Hall, K. Bowyer, "SMOTEBoost: Improving 
Prediction of Minority Class in Boosting, Journal of Knowledge Discovery
in Databases: PKDD, 2003.

Description of Implementation:
The current implementation of SMOTEBoost has been independently done by the author
for the purpose of research. In order to enable the users use a lot of different
weak learners for boosting, an interface is created with Weka API. Currently,
four Weka algortihms could be used as weak learner: J48, SMO, IBk, Logistic.

Files:
weka.jar -> Weka jar file that is called by several Matlab scripts in this 
	    directory.

train.arff, test.arff, resampled.arff -> ARFF (Weka compatible) files generated
					 by some of the Matlab scripts.

ARFFheader.txt -> Defines the ARFF header for the data file "data.csv". Please
		  refer to the following link to learn more about ARFF format.
		  http://www.cs.waikato.ac.nz/ml/weka/arff.html 

SMOTEBoost.m -> Matlab script that implements the SMOTEBoost algorithm. Please
		"help SMOTEBoost" in Matlab Console to the arguments for this 
		function.

Test.m -> Matlab script that shows a sample code to use SMOTEBoost function in
	  Matlab.

ClassifierTrain.m, ClassifierPredict.m, CSVtoARFF.m -> Matlab functions used by 
						       SMOTEBoost.m


**************************************xxx**************************************