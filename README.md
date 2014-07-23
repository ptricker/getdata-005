#Summary of the course project for Getting and Cleaning Data

Here is a description of the program run_analysis.R, required for the course Project for Getting and Cleaning Data.

##Prerequisites
It is assumed that the data has been downloaded and extracted into the working directory.

The program run_analysis.R must be run from the directory where the folder UCI HAR Dataset resides.

## Program Description
Firstly, the program checks whether the R package 'reshape2' is installed or not. If not, it is installed then attached.

The program then loads the data as follows:

* Activity data which contains the type of activity measured
* Features data which is essentially the column names for the train and test datasets

* TrainX data containing the train phase measurements
* TrainY data containing the activity being recorded for the train phases measurements
* Train subject data containing the participant the data was measured and recorded against

* TestX data containing the test phase measurements
* TestY data containing the activity being recorded for the test phases measurements
* Test subject data containing the participant the data was measured and recorded against

The column names are then added to each of the data sets. For activity, 'Y' and subject datasets the column names are explicitly added. For the 'X' datasets the second column of the Features dataset is used.

Since the assignment requires only mean and standard deviation data, a grep command is used to select only those variables with 'mean(' or 'std' in the variable name. The resulting output is used to filter the TrainX and TestX datasets.

Next the main datasets are merged to include the subject and type of activity recorded using a cbind function because columns are being combined together. The resulting two datasets for 'Train' and 'Test' are then merged together using a row bind function (rbind) to create the final dataset. As per the requirements the activity types are embellished with their respective descriptions by joining the final dataset with the activity dataset on 'ActivityID'.

For the last requirement the final dataset is melted to break it down into individual measurements for each activity and subject in the dataset. The TidyData dataset is cast using the melted version by aggregating activity and subject and calculating a mean for each variable.

The TidyData dataset is written to the file TidyData.txt