### Introduction


This is a Getting and Cleaning Data Course Project. The goal is to prepare tidy data from data collected by the accelerometers from the Samsung Galaxy S smartphone. This project directory contains result files with prepared data and its code book:
*result.txt 
*mean.txt
*CodeBook.md
Data preparation is made by run_analisis.R script from the original data.

### Original data sourse
Original data is obtained from project UCI web site:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#
Original data description citation:
*The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.*

### Data preparation goals
This is the task of course project. Data preparation script should do the folowing:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Initial data preparation requirements
Original data should be unziped in working directory in "UCI HAR Dataset" folder. "dyplr" package should be installed.

### run_analisis.R script
This script manipulate original data set. At first the code states valid file path according to original data structure:
```
fp_test_data <- c("UCI HAR Dataset/test/X_test.txt")
fp_test_activ <- c("UCI HAR Dataset/test/y_test.txt")
fp_test_id <- c("UCI HAR Dataset/test/subject_test.txt")
fp_train_data <- c("UCI HAR Dataset/train/X_train.txt")
fp_train_activ <- c("UCI HAR Dataset/train/y_train.txt")
fp_train_id <- c("UCI HAR Dataset/train/subject_train.txt")
fp_features <- c("UCI HAR Dataset/features.txt")
fp_labels <- c("UCI HAR Dataset/activity_labels.txt")
```

Next we create a function "prep" that will prepare data for test and train in the same manner. First we match activity numbers and activity names (note that names are stored in second column!):
```
activ <- left_join(activ, labels, by = NULL)
```

Next we put column names to dataset from features list file:
```
names(data1) <- feat[,2]
```

Next step is to clean data from columns that are not used for mean or std deviation:
```
ncol <- sort(c(grep("mean", names(data1)), grep("std", names(data1))))
data1 <- data1[,ncol]
```

At the final stage we bind data with volunteer id and activity + adding names to new columns:
```
data1 <- cbind(id, activ[,2], data1)
names(data1)[1] <- "id"
names(data1)[2] <- "activity"
```

Now it is time to apply "prep" function to test and train data:
```
data_test <- prep(fp_test_data, fp_test_activ, fp_test_id)
data_train <- prep(fp_train_data, fp_train_activ, fp_train_id)
```

First result file we get by binding and sorting test and train data sets:
```
data_join <- rbind(data_test, data_train)
data_join <- arrange(data_join, id, activity)
write.table(data_join, "result.txt")
```

For the second result file we use "dyplr" pack functions:
```
data_mean <- group_by(data_join, id, activity)
data_mean <- summarise_all(data_mean, funs(mean))
write.table(data_mean, "mean.txt")
```