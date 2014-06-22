# tidyData Programming assigment readme file 


see Codebook

#Original Dataset
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Data License:  
=======
Use of this dataset in publications must be acknowledged by referencing the following publication [1]  

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the 
authors or their institutions for its use or misuse. Any commercial use is prohibited.
Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


Using run_analysis.R:

Original dataset was divided into a TRAIN set and a TEST set.  These datasets were combined.  Variable observations reported as mean or standard deviation were retained.  The data was tranformed into two files:  

  tidyData.txt    observation for each subject by activity
  
  tidyMeans.txt   mean of observations for subject/activity
