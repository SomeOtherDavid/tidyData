# run_analysis.R
# Data License:   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#         ========
#         Use of this dataset in publications must be acknowledged by referencing the following 
# publication [1]  
# [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
# 
# This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the 
# authors or their institutions for its use or misuse. Any commercial use is prohibited.
# Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

version<-data.table(R.Version())
print(version)
library(data.table)
#####################  Download script  (not used as you should "assume data is in working directory")
# fileurl1<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# filename1 <- paste("projectdata", ".zip", sep="")
# download.file(fileurl1, destfile=filename1, method="curl")
#########
####################  Unzip data archive  (not used as you should "assume data is in working directory")
# filename1 <- paste("projectdata", ".zip", sep="")
# unzip(filename1, overwrite=TRUE)
# unzip(filename1, list=T)
########

dataSetName<-"UCI HAR Dataset"          #relative path to data
#######   
#       features.txt  (variableid, variablename)
dtVariableList <- fread(paste(dataSetName,"features.txt",sep="/"))      #read list of variables into data.table
setnames(dtVariableList, 1:2,c("variableid","variablename"))            #change column names


#       activity_labels.txt  (activityid, activityname)     
dtActivityList <- fread(paste(dataSetName,"activity_labels.txt",sep="/")) #read activity labels into data.table
setnames(dtActivityList, 1:2,c("activityid","activityname"))            #change column names

#       test    #directory - test data files
testDataSet<- paste(dataSetName, "test", sep="/")       #set pathname
        
        #       subject_test.txt  (test subject id for each observation)
        dtTestSubjectList<-fread(paste(testDataSet,"subject_test.txt",sep="/")) #read subject ID into data.table
        dtTestSubjectList<-data.table(1:nrow(dtTestSubjectList),dtTestSubjectList) #add new column with index (1...n)
        setnames(dtTestSubjectList, 1:2,c("sortindex","subjectid"))  #change column names
        
        #       X_test.txt             observations  561 columns (variables)
        dtXTest<-read.table(paste(testDataSet,"X_test.txt",sep="/"))    #read observations into data.table
        dtXTest<-data.table(1:nrow(dtXTest),dtXTest)                    #add new column with index (1...n)                                                                        #for joining tables
        setnames(dtXTest,1:ncol(dtXTest),c("sortindex",make.names(dtVariableList[,dtVariableList$variablename],unique=TRUE,allow_=FALSE))) 
                        #^^^ change column names to saferized (make.names) variable names listed in features_txt
        
        #       y_test.txt
        dtYTest<-fread(paste(testDataSet,"y_test.txt",sep="/")) #read activity label ids into data.table
        dtYTest<-data.table(1:nrow(dtYTest),dtYTest)            #add new column with index (1...n)
        setnames(dtYTest,1:2,c("sortindex","activityid"))    #change column names

        
#       train   #directory - training data files
trainDataSet<- paste(dataSetName, "train", sep="/")     #set pathname
        
        #       subject_train.txt
        dtTrainSubjectList<-fread(paste(trainDataSet,"subject_train.txt",sep="/"))      #read subject ID into data.table
        dtTrainSubjectList<-data.table(1:nrow(dtTrainSubjectList),dtTrainSubjectList)   #add new column with index (1...n)
        setnames(dtTrainSubjectList, 1:2, c("sortindex","subjectid"))      #change column names

        #       X_train.txt             observations  561 columns               
        dtXTrain<-read.table(paste(trainDataSet,"X_train.txt",sep="/"))         #read observations into data.table
        dtXTrain<-data.table(1:nrow(dtXTrain),dtXTrain)                         #add new column with index (1...n)
        setnames(dtXTrain,1:ncol(dtXTrain),c("sortindex",make.names(dtVariableList[,dtVariableList$variablename],unique=TRUE,allow_=FALSE)))
                #^^^ change column names to saferized (make.names) variable names listed in features_txt
        
        #       y_train.txt
        dtYTrain<-fread(paste(trainDataSet,"y_train.txt",sep="/"))      #read activity label ids into data.table
        dtYTrain<-data.table(1:nrow(dtYTrain),dtYTrain)                 #add new column with index (1...n)
        setnames(dtYTrain,1:2,c("sortindex","activityid"))              #change column names

#####  Create vector of partial strings to match for column selection  we want: .mean.  .std. and identifiers#####
#(this excludes meanFreq as a match)   "\\" escape for "." as this vector will be used with grep
# toMatch<-c("\\.mean\\.","\\.std\\.","activityid", "activityname", "subjectid","set")  #create list of column names to subset on 
toMatch<-c("\\.mean\\.","\\.std\\.","activityid", "subjectid")  #create list of column names to subset on
#for simplicity - exlude the "set" (TRAIN,TEST) and "activityname" columns
#####
#  Join test tables
YTest<-data.frame(dtYTest)              #can't seem to join using data.tables, so convert to data frames
XTest<-data.frame(dtXTest)              #can't seem to join using data.tables, so convert to data frames                 
TestSubject<-data.frame(dtTestSubjectList)   #can't seem to join using data.tables, so convert to data frames
testF<-merge(YTest,XTest)               #join (why do they call it merge?)
testF<-merge(TestSubject,testF)         #join (why do they call it merge?)
testF<-data.frame("TEST",testF)
colnames(testF)[1]<-"set"
#  Join train tables
YTrain<-data.frame(dtYTrain)            #can't seem to join using data.tables, so convert to data frames
XTrain<-data.frame(dtXTrain)            #can't seem to join using data.tables, so convert to data frames
TrainSubject<-data.frame(dtTrainSubjectList)   #can't seem to join using data.tables, so convert to data frames
trainF<-merge(YTrain,XTrain)            #join (why do they call it merge?)
trainF<-merge(TrainSubject,trainF)      #join (why do they call it merge?)
trainF<-data.frame("TRAIN",trainF)
colnames(trainF)[1]<-"set"
almostTidy<-rbind(testF,trainF)   #append the TEST and TRAIN data into a single table
ActivityList<-data.frame(dtActivityList)  #make data frame of activities
almostTidy<-merge(ActivityList,almostTidy)      #merge activity names into dataset
matches <- unique (grep(paste(toMatch,collapse="|"), 
                        names(almostTidy), value=TRUE)) #create vector of desired columns
tidyData<-almostTidy[,matches]                          #subset data to include only columns of interest
tidyNames<-gsub("\\.","",names(tidyData))               #make list of 'nice' variable names
colnames(tidyData)<-tidyNames                           #clean up variable names
write.table(tidyData,"tidyData.txt",sep=",",row.names=FALSE,col.names=TRUE, na="NA")

# ###########   data.table alternative   ########
# setkey(dtXTrain,sortindex)
# setkey(dtYTrain,sortindex)
# setkey(dtTrainSubjectList,sortindex)
# train<-merge(dtYTrain,dtXTrain)
# train<-merge(dtTrainSubjectList,train)
# train<-data.table("TRAIN",train)
# setnames(train,1,"set")
# setkey(dtXTest,sortindex)
# setkey(dtYTest,sortindex)
# setkey(dtTestSubjectList,sortindex)
# test<-merge(dtYTest,dtXTest)
# test<-merge(dtTestSubjectList,test)
# test<-data.table("TEST",test)
# setnames(test,1,"set")
# almostTidy2<-rbindlist(list(test,train))
# setkey(dtActivityList,activityid)
# almostTidy2<-merge(dtActivityList,almostTidy2)
# tidyData2<-almostTidy2[,matches,with=FALSE]
# tidyNames<-gsub("\\.","",names(tidyData2))
# setnames(tidyData2,names(tidyData2),tidyNames)
# write.table(tidyData2,"tidyData2.csv",sep=",",row.names=FALSE,col.names=TRUE, na="NA")
# #########################   ^^^^  alternative ending ^^^^  ################

####  Create tidySummaryData table  --  average of each variable for each activity/subject
library(reshape2)
#####  Narrow the data  #####
tempData<-tidyData
tempData$set<-NULL
idcolumns<-c("activityid",  "subjectid")   #list of columns to exclude from melt measure.vars
# following line melts (narrows) the data set with 
tidyMelt<-melt(tempData,id=idcolumns,measure.vars=tidyNames[! tidyNames %in% idcolumns])
######################
#####  Cast the melted data frame with summary data (mean)
tidyMeans<-(dcast(tidyMelt, activityid + subjectid ~ variable, mean))  #cast means on activity/subject
#tidyCast<-(dcast(tidyMelt, activityid ~ subjectid + variable,fun.aggregate=mean)) 
tidyMeanNames<-paste("mean",names(tidyCast),sep="")  #prepend "mean" to column names
tidyMeanNames[1:2]<-idcolumns[1:2]              #correct id column names in names vector
colnames(tidyMeans)<-tidyMeanNames       #rename columns to reflect mean values
####  Write file 'tidyCast'  ##############
write.table(tidyMeans,"tidyMeans.txt",sep=",",row.names=FALSE,col.names=TRUE, na="NA")
