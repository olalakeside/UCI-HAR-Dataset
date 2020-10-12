# Load required packages

library(dplyr)

# Download the zip file containing the datasets

datafile <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
if (!file.exists(datafile)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, datafile, method="curl")
}  

# Checking if folder exists and Unzip achive
if (!file.exists("UCI HAR Dataset")) { 
  unzip(datafile) 
}


# Read all the tables in the zip file and assigning all data frames needed

myfeatures <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
myactivities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = myfeatures$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = myfeatures$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


# Task 1: Merge the Training and Test sets to create one dataset

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)

Subject <- rbind(subject_train, subject_test)

Merged_Data <- cbind(Subject, Y, X)


# Task 2: Extract the mean and Standard deviations for each measurements

TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))


# Task 3: Use Descriptive Activity names to name the activities using Descriptive activity names

TidyData$code <- myactivities[TidyData$code, 2]


# Task 4: Appropriately labels the data set with descriptive variable names

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))


# Task 5: creates a second, independent tidy data set with the average of each variable for each activity and each subject

myFinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(myFinalData, "myFinalData.txt", row.name=FALSE)




str(myFinalData)

                                   
                                   

