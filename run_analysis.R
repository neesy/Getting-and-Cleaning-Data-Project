## Read in test data from UCI HAR dataset and tidy the data for 
## analysis of just the mean and standard deviation

## set the proper working directory
setwd("C:/Users/Denise/Documents/UCI HAR Dataset")

## call the appropriate libraries
library(plyr)
library(dplyr)
library(tidyr)

## read in the features dataset and activity labels for use with both test and train datasets
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

## read test data and create a labeled dataset
## create test subject dataset
subject_no <- read.table("test/subject_test.txt")
names(subject_no) <- "subject_no"
subject_type <- "test"

## create the test activities table (to merge with x_test)
activity <- read.table("test/y_test.txt") 
activities <- merge(activity, activity_labels, by="V1", all.x=TRUE) ##create the activity vector
names(activities) <- c("activity_no","activity")
activities <- as.data.frame(activities$activity)
names(activities) <- "activity"

##name the x_test columns (variables) with feature names
x_test <- read.table("test/X_test.txt")
names(x_test) <- features[,2] 

## create the final test dataset
test_data <- cbind(subject_type, subject_no, activities, x_test)

## read training data and create a labeled dataset
## create subject table
subject_no <- read.table("train/subject_train.txt")
names(subject_no) <- "subject_no"
subject_type <- "train"

##activities table (to merge with x_test)
activity <- read.table("train/y_train.txt") 
##create the activity vector
activities <- merge(activity, activity_labels, by="V1", all.x=TRUE) 
## give them meaningful names
names(activities) <- c("activity_no","activity")
activities <- as.data.frame(activities$activity)
names(activities) <- "activity"

##name the x_train columns (variables) with feature names
x_train <- read.table("train/X_train.txt")
names(x_train) <- features[,2] 

## create the final training dataset
train_data <- cbind(subject_type, subject_no, activities, x_train)

## combine the test and train data
combo_data <- rbind(test_data, train_data)

## strip out the unneeded columns with duplicate names causing errors (bandsEnergy columns)
combo_data <- combo_data[,-(464:505)]
combo_data <- combo_data[,-(385:426)]
combo_data <- combo_data[,-(306:347)]

## create an id file to remove duplicate table data from the headers
## can be merged back with the mean or standard deviation files to identify the subject at the end
id_file <- combo_data[,(1:3)]
id_file <- unique(id_file)
id <- 1:nrow(id_file)
id_file <- cbind(id,id_file)

## remove unneeded duplicate data (subject_no, activity, type(test or train))
combo_data <- merge(id_file, combo_data)
combo_data <- combo_data[,-(1:3)]

## fix labels to be more meaningful
names(combo_data) <- sub("BodyBody","Body",names(combo_data))
names(combo_data) <- sub("tBody","body ", names(combo_data))
names(combo_data) <- sub("tGravity","gravity ", names(combo_data)) 
names(combo_data) <- sub("Acc","acceleration ", names(combo_data)) 
names(combo_data) <- sub("Gyro","gyroscope ", names(combo_data)) 
names(combo_data) <- sub("Jerk","with jerk signal ", names(combo_data)) 
names(combo_data) <- sub("fBody","fft body ", names(combo_data))
names(combo_data) <- sub("Mag","magnitude ", names(combo_data))
names(combo_data) <- sub("\\-"," ", names(combo_data)) 
names(combo_data) <- sub("  "," ", names(combo_data)) 

## file of means
combo_means <- select(combo_data, id, contains("mean()"))
names(combo_means) <- sub("\\()","", names(combo_means))
View(combo_means)

## file of standard deviations
combo_std <- select(combo_data, id, contains("std()"))
names(combo_std) <- sub("\\()","", names(combo_std))
View(combo_std)

## remove unneeded files
rm(combo_data, activities, activity, activity_labels, features, subject_no, test_data,
   train_data, x_test, x_train, id, subject_type)

## create dataset of means of the means by subject and activity  
## merge with id file
mean_means <- merge(id_file, combo_means)
## select the columns of variables to take the means, group by subject_no and activity
mean_means <- aggregate(mean_means[,5:37], list(mean_means$subject_no, mean_means$activity), mean)
## rename the resulting grouped variables to meaningful names
names(mean_means) <- sub("Group.1","subject_no", names(mean_means))
names(mean_means) <- sub("Group.2","activity", names(mean_means))
View(mean_means)

