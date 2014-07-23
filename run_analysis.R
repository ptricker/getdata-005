#######################################################
# Course: Getting and Cleaning Data
# 21/07/2014
#######################################################

# This script run_analysis.R does the following:
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity
#    and each subject. 
########################################################

#setwd('C:/Users/Peter/Documents/Coursera/Getting & Cleaning Data/Assignment/')

# Check for reshape2 package
if (!require("reshape2")) {
        install.packages("reshape2")
}

require("reshape2")


# Read in the files from the unzipped UCI HAR Dataset file
# First, read in the features and activity files

ActivityData <- read.table("./UCI HAR Dataset/activity_labels.txt")
FeaturesData <- read.table("./UCI HAR Dataset/features.txt", header=FALSE, 
                           stringsAsFactors=FALSE) # read 2nd col only for colnames

# Read in Train files
TrainX <- read.table("./UCI HAR Dataset/train/X_train.txt")
TrainY <- read.table("./UCI HAR Dataset/train/Y_train.txt")
TrainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Read in Test files
TestX <- read.table("./UCI HAR Dataset/test/X_test.txt")
TestY <- read.table("./UCI HAR Dataset/test/Y_test.txt")
TestSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")


# Add column names to the data sets
colnames(ActivityData) = c("ActivityID", "Activity")
colnames(TrainX) = FeaturesData[, 2]
colnames(TestX) = FeaturesData[, 2]
colnames(TrainY) = "ActivityID"
colnames(TestY) = "ActivityID"
colnames(TrainSubject) = "Subject"
colnames(TestSubject) = "Subject"

# Create the variable to store mean and std colnames as a subset of Features
Features <- FeaturesData$V2[grep("mean\\(|std", FeaturesData$V2)] # don't want the meanFreq variables

# Subset the X & Y files based on the new Features colnames
TrainX <- TrainX[, Features]
TestX <- TestX[, Features]

# Merge the X files, then the Y files by column
TrainDS <- cbind(TrainSubject, TrainY, TrainX)
TestDS <- cbind(TestSubject, TestY, TestX)

# Merge the two final train and test datasets into one file
FinalDS <- rbind(TrainDS, TestDS)

#Add descriptive variables for Activity ID by merging FinalDS with ActivityData
FinalDS <- merge(FinalDS, ActivityData, by="ActivityID", all.x=TRUE)

write.csv(FinalDS, file="FinalDS.csv") #write output for testing and verification purposes

# Create the tidy data. Melt the Final data set by Activity, Subject and mean/std variables used in FinalDS
melt_final <- melt(FinalDS, id=c("Activity", "Subject"), measure.vars=Features)
# cast back into data.frame, gicing the mean of each measurement for activity and subject
TidyData <- dcast(melt_final, Activity + Subject ~ variable, mean) 

write.table(TidyData, file="TidyData.txt", row.names=FALSE, sep = ",")




