run_analysis <- function() {
    options(warn = -1)
    
    # Check if the zip file has already been downloaded; if not download it
    if (!file.exists("UCI HAR Data.zip")) {
        # Set the download URL
        fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        
        download.file(fileURL, dest="UCI HAR Data.zip")
        downloadDate <- date()
    }
    
    # Check if the folder exists where the data will be unzipped to
    # If not, unzip it
    if (!file.exists("UCI HAR Data")) {
        unzip("UCI HAR Data.zip", exdir="UCI HAR Data")
    }

    # Read the data into R in clear data frames    
    subject_test <- read.table("UCI HAR Data/UCI HAR Dataset/test/subject_test.txt")
    X_test <- read.table("UCI HAR Data/UCI HAR Dataset/test/X_test.txt")
    y_test <- read.table("UCI HAR Data/UCI HAR Dataset/test/y_test.txt")
    subject_train <- read.table("UCI HAR Data/UCI HAR Dataset/train/subject_train.txt")
    X_train <- read.table("UCI HAR Data/UCI HAR Dataset/train/X_train.txt")
    y_train <- read.table("UCI HAR Data/UCI HAR Dataset/train/y_train.txt")
    features <- read.table("UCI HAR Data/UCI HAR Dataset/features.txt")
    activity_labels <- read.table("UCI HAR Data/UCI HAR Dataset/activity_labels.txt")

    # Re-cast the features table as characters
    features[] <- lapply(features, as.character)
    
    # Tranpose features so it has the headings in row 2
    features <- t(features)
    
    # Add the headings to the X_test and X_train data frames
    names(X_test) <- features[2, ]
    names(X_train) <- features[2, ]
    
    # Rename the columns in y_test and y_train to 'Activity'
    names(y_test) <- "Activity"
    names(y_train) <- "Activity"

    # Convert the elements of y_test and y_train to factors
    y_test$Activity <- as.factor(y_test$Activity)
    y_train$Activity <- as.factor(y_train$Activity)
    
    # Replace the factor numbers with the descriptions from activity_labels
    levels(y_test$Activity) <- activity_labels$V2
    levels(y_train$Activity) <- activity_labels$V2
    
    # Rename the columns in subject_test and subject_train to 'Subject'
    names(subject_test) <- "Subject"
    names(subject_train) <- "Subject"
    
    # Column bind subject, y and X data sets into one test and one training data set
    test_data <- cbind(subject_test, y_test, X_test)
    train_data <- cbind(subject_train, y_train, X_train)
    
    # Create a single data source for training and test data
    data <- rbind(test_data, train_data)
    
    # Remove data sets no longer required from memory
    rm(test_data, train_data, X_test, X_train, y_test, y_train, subject_test, subject_train, features, activity_labels)

    # Look for column headings that contain either mean or std
    # N.B. Ignoring weighted average variables that use Mean of meanFreq
    mean_cols <- grepl("mean()", names(data))
    std_cols <- grepl("std()", names(data))
    meanfreq_cols <- grepl("meanFreq()", names(data))
    keep_cols <- mean_cols + std_cols - meanfreq_cols
    keep_cols[1:2] = 1 # To ensure the first two columns are included
    rm(mean_cols, std_cols, meanfreq_cols)
    
    # Create a smaller dataset by removing unnecessary columns using keep_cols
    # Then remove the keep_cols vector as no longer required
    keep_cols <- as.logical(keep_cols)
    data <- subset(data, select=keep_cols)
    rm(keep_cols)
    
    # Regroup the data by Subject and Activity,
    # applying the mean function to grouped records
    # and storing in a new data frame, newdata
    newdata <- aggregate(data, by=list(data$Subject, data$Activity), FUN=mean, na.rm=TRUE)

    # Remove the old Subject and Activity columns
    drop <- c("Subject", "Activity")
    newdata <- newdata[, !(names(newdata) %in% drop)]
    rm(drop)
    
    # Rename the first 2 columns to Subject and Activity
    names(newdata)[1] <- "Subject"
    names(newdata)[2] <- "Activity"
    
    write.table(newdata, "tidy-data.txt", sep="\t", row.name=FALSE)
    options(warn = 0)
}