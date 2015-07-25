# Getting and Cleaning Data Course Project Readme

This document describes the actions undertaken by run_analysis.R to produce a tidy data set of the information recorded by the accelerometers in Samsung Galaxy S smartphones as used by a sample of 30 people. 

The specifics tasks to be completed were:

1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## run_analysis.R
#### Getting the Data
The R script first checks to see if the data has been downloaded from

[http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

If not, then the data is downloaded and stored in a zip file named "UCI HAR Data.zip"

If the data has already been downloaded into this zip file it may or may not have been extracted. The script checks to see if a folder called "UCI HAR Data" exists and if it does not it will create the folder and then proceed to unzip the data downloaded and save the extracted files into this folder.

#### Step 1: Tidying the Data
8 data frames are set up for the 8 sets of data that are needed for the tidying process:

* X_test
* X_train
* y_test
* y_train
* subject_test
* subject_train
* features
* activity_labels

The features data frame is transposed and the names can then be applied to the top of the X_test and X_train data sets. 

y_test and y_train are given variable headings of "Activity" since these files contain information about which line of data corresponds to which activity. Both data frames are then converted to factors and each factor level is replaced with an activity name from the activity_labels file. 

Subject_test and subject_train have variable headings of "Subject" since each element of these files corresponds to the results from a particular test subject. 

The data are then combined together into test and train data sets, and then these are converted into one large data frame called 'data'. 

All data sets created up to this point with the exception of 'data' are then removed from system memory as they are no longer required. This completes step 1. 

#### Step 2: Extract the Mean and Standard Deviation
Examining the variable headings for the data and reading the features_info file, the mean and standard deviation columns contain the words mean() and std() in their descriptions. Running grepl() on the names of data allows these headings to be picked out. Unfortunately meanFreq() is also included in this process but since this refers to a weighted average rather than a standard mean, it should be excluded. 

The vector keep_cols contains a list of TRUE and FALSE entries for the columns that should be kept (with an adjustment to ensure that the first two columns, Subject and Activity, are also kept). The data can then be subset based on the keep_cols vector, after which keep_cols is removed from system memory. 

#### Step 3: Descriptive Activiy Names
This step was covered as part of Step 1 when the data was joined together. The descriptive names have been carried through at each stage so no further work is required.

#### Step 4: Descriptive Variable Names
As for step 3 above, this was undertaken as part of Step 1 when the data was joined together so no further work is required at this point. 

#### Step 5: Tidy Data Set of Averages
A data frame named 'newdata' is created which aggregates the results in 'Data' by Subject and Activity. The result is a data frame of 180 rows which corresponds to 6 activities undertaken by 30 participants (6 x 30 = 180). 

As part of this process, two new columns are created called 'Group.1' and 'Group.2' which inherit the properties of 'Subject' and 'Activity'. The original 'Subject' and 'Activity' columns are dropped from the data frame and the two new columns renamed to 'Subject' and 'Activity' respectively. 

Finally, the new data set is output as a tab-delimited text file, 'tidy-data.txt'. The data set meets the requirements of tidy data, namely:

* Each variable being measured has its own column
* Each observation of each variable for each subject and activity is in its own row
* All of the data corresponds to sensor signals and nothing else

These also meet the tidy data principles of Hadley Wickham's paper on Tidy Data:

[http://vita.had.co.nz/papers/tidy-data.pdf](http://vita.had.co.nz/papers/tidy-data.pdf)

## Running the File
The R script requires no external packages to be loaded other than the basic R toolsets. Save the script into the working directory and load it with:


```r
source("run_analysis.R")
```

The script can then be run by typing


```r
run_analysis()
```

The output will be a file called 'tidi-data.txt' saved into the working directory. 

## Codebook.md
The codebook file contains a description of each of the variables present in the data set along with a brief summary of their relevance and how they have been computed. 
