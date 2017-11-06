## working directory should contain original data unziped folder UCI HAR Dataset, require dplyr pack
library(dplyr)
## collection of file paths according to provided data
fp_test_data <- c("UCI HAR Dataset/test/X_test.txt")
fp_test_activ <- c("UCI HAR Dataset/test/y_test.txt")
fp_test_id <- c("UCI HAR Dataset/test/subject_test.txt")
fp_train_data <- c("UCI HAR Dataset/train/X_train.txt")
fp_train_activ <- c("UCI HAR Dataset/train/y_train.txt")
fp_train_id <- c("UCI HAR Dataset/train/subject_train.txt")
fp_features <- c("UCI HAR Dataset/features.txt")
fp_labels <- c("UCI HAR Dataset/activity_labels.txt")

## function to prepare test and train dataset for binding
prep <- function(fp_data, fp_activ, fp_id, fp_feat = fp_features, fp_labe = fp_labels) {
        data1 <- read.table(fp_data)
        activ <- read.table(fp_activ)
        id <- read.table(fp_id)
        feat <- read.table(fp_feat)
        labels <- read.table(fp_labe)
        ##converting activities to names
        activ <- left_join(activ, labels, by = NULL)
        ##setting column names
        names(data1) <- feat[,2]
        ##finding columns with data needed
        ncol <- sort(c(grep("mean", names(data1)), grep("std", names(data1))))
        data1 <- data1[,ncol]
        ##adding activity and testers id
        data1 <- cbind(id, activ[,2], data1)
        names(data1)[1] <- "id"
        names(data1)[2] <- "activity"
        return(data1)
}
## join test and train dataset
data_test <- prep(fp_test_data, fp_test_activ, fp_test_id)
data_train <- prep(fp_train_data, fp_train_activ, fp_train_id)
data_join <- rbind(data_test, data_train)
data_join <- arrange(data_join, id, activity)
## writing results in txt file
write.table(data_join, "result.txt")
## now creating a table of mean values
data_mean <- group_by(data_join, id, activity)
data_mean <- summarise_all(data_mean, funs(mean))
## writing results in txt file
write.table(data_mean, "mean.txt")
return("Done!")