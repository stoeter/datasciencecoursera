## This Code Book describes how the raw data was processed and what the file 'mean_of_subject_and_activity" contains

### Raw Data
* folder 'raw_data'
* raw data can be downloaded form here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
* \UCI HAR Dataset\features_info.txt contains the information about the features/measurements

### Data Processing

* activity labels were joined to measurements by ID (6 activities)
** ./raw_data/UCI HAR Dataset/activity_labels.txt
** ./raw_data/UCI HAR Dataset/test/y_test.txt
** ./raw_data/UCI HAR Dataset/train/y_train.txt

* subjects were merged with measurements by row ID (30 subjects)
** ./raw_data/UCI HAR Dataset/train/subject_train.txt

* column names were loaded and used on data frame
** ./raw_data/UCI HAR Dataset/features.txt
** table features contains 561 observations (=measurements), but only 477 levels (=unique measurements), this was ignored
** selection of the columns contained "mean()" and "std()"

* first goal was merging test and training data
** ./raw_data/UCI HAR Dataset/test/X_test.txt
** ./raw_data/UCI HAR Dataset/train/X_train.txt

* renameing of column names
newNames <- sub("Acc","-accelerometer-", newNames)
newNames <- sub("Gyro","-gyroscope-", newNames)
newNames <- sub("^t","timedomain-", newNames)
newNames <- sub("^f","frequencydomain-", newNames)
newNames <- sub("Mag","-magnitude-", newNames)
newNames <- gsub("--","-", newNames)
newNames <- tolower(newNames)

* aggregation of all measurements (mean) for each subject and activity
