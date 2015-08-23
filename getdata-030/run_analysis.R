# R script to course project 
#
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#set working directory
getwd()
setwd("~/Desktop/CouseraGitHub/datasciencecoursera/getdata-030")

#load librarys
library(dplyr)

#load test data tables
test <- tbl_df(read.table("./raw_data/UCI HAR Dataset/test/X_test.txt"))
labels_test <- tbl_df(read.table("./raw_data/UCI HAR Dataset/test/y_test.txt"))
subjects_test <- tbl_df(read.table("./raw_data/UCI HAR Dataset/test/subject_test.txt"))

#load features (measurements) and activity labels
features <- tbl_df(read.table("./raw_data/UCI HAR Dataset/features.txt"))
activity_labels <- tbl_df(read.table("./raw_data/UCI HAR Dataset/activity_labels.txt"))

#check features
str(features)
print("table features contains 561 observations (=measurements), but only 477 levels (=unique measurements)")
print("problem: there are observations (measurements or features) that have the same name!")
by_V2 <- group_by(features, V2)
check_features <- summarize(by_V2, n = n()) %>% arrange(desc(n))
check_features

#merge labels with activities and generate test data frame
#labels_test <- tbl_df(merge(labels_test, activity_labels, by.x = "V1", by.y = "V1"))
labels_test <- tbl_df(inner_join(labels_test, activity_labels, by = c("V1" = "V1")))
testDF <- tbl_df(data.frame(subject = subjects_test$V1, label = labels_test$V2, measurement = test))
names(testDF) <- c("subject", "activity", as.character(features$V2))

#load training data tables
training <- tbl_df(read.table("./raw_data/UCI HAR Dataset/train/X_train.txt"))
labels_training <- tbl_df(read.table("./raw_data/UCI HAR Dataset/train/y_train.txt"))
subjects_training <- tbl_df(read.table("./raw_data/UCI HAR Dataset/train/subject_train.txt"))

#merge labels with activities and generate training data frame
#labels_training <- tbl_df(merge(labels_training, activity_labels, by.x = "V1", by.y = "V1"))
labels_training <- tbl_df(inner_join(labels_training, activity_labels, by = c("V1" = "V1")))
trainingDF <- tbl_df(data.frame(subject = subjects_training$V1, label = labels_training$V2, measurement = training))
names(trainingDF) <- c("subject", "activity", as.character(features$V2))

#concatenate/merge test and training data set
completeDF <- rbind(testDF, trainingDF)

#select only variables that are mean and std aggregations
selectedDF <- completeDF[,c(1,2,grep("mean\\(\\)", names(completeDF)),grep("std\\(\\)", names(completeDF)))]

#clean up memory
rm(list=c("test", "training"))
rm(list=c("testDF", "trainingDF"))
rm(list=c("completeDF"))

#check variable names of data frame
length(grep("\\.", names(selectedDF), value = TRUE)) #no variable names with a dot
length(grep(" ", names(selectedDF), value = TRUE))   #no variable names with a white space
length(grep("_", names(selectedDF), value = TRUE))   #no variable names with an underscore
length(grep(",", names(selectedDF), value = TRUE))   #no variable names with a comma
print("variable name have upper and lower case")

#make descriptive variable names
newNames <- names(selectedDF)
newNames <- sub("Acc","-accelerometer-", newNames)
newNames <- sub("Gyro","-gyroscope-", newNames)
newNames <- sub("^t","timedomain-", newNames)
newNames <- sub("^f","frequencydomain-", newNames)
newNames <- sub("Mag","-magnitude-", newNames)
newNames <- gsub("--","-", newNames)
newNames <- tolower(newNames)
names(selectedDF) <- newNames

#aggregate per individuum and activity (mean)
by_act <- group_by(selectedDF, subject, activity)
meansDF <- by_act %>% summarise_each(funs(mean))

#write means table to text file
destinationFile <- "mean_of_subject_and_activity.txt"
write.table(meansDF, file = destinationFile, row.names = FALSE) 


