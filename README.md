## Getting and Cleaning Data
### Course Project

#### Data

* original data is available from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip (Last accessed: 13-07-2015)
* locally data is available under `UCI HAR Dataset/` in this repository

#### Executing

0. the script required the `dplyr` R package, make sure it's available (eg. `packages.install("dplyr")`
1. clone this repository or copy the `UCI HAR Dataset/` data directory and the `run_analysis.R` script
2. start R
3. change directory to where you copied the files (eg, using the `setwd()` F function)
4. execute the `run_analysss.R` script: `source("run_analysis.R")`

#### Results

* after running the script you should have to data frames in your R environment (`data` and `data_2`)
* and two text files should have been created in your project directory (`data.txt` and `data_2.txt` that contain the data frames in your environment)

#### How The Script Works

##### 1. Merges the training and the test sets to create one data set

1.1. read contents from train and test tables

```Rscript
t1 <- read.table("UCI HAR Dataset//train//X_train.txt")
t2 <- read.table("UCI HAR Dataset//test//X_test.txt")
```

1.2. create a single data frame with all the rows

```Rscript
X <- rbind(t1, t2)
```

1.3. do the same for the Y values and subjects

##### 2. Extracts only the measurements on the mean and standard deviation for each measurement

2.1. read features from the features table

```Rscript
features <- read.table("UCI HAR Dataset//features.txt")
```

2.2. extract only features that match mean() and std() using grep

```Rscript
want <- grep("(mean|std)\\(\\)", features[,2])
X <- X[, want]
```

2.3. get feature names for only these features

```Rscript
feature_names <- features[want, 2]
```

2.4. clean up feature names, convert to lower case, and remove non letter chars

```Rscript
feature_names <- tolower(feature_names)
feature_names <- gsub("[\\(\\)\\-]", "", feature_names)
names(X) <- feature_names
```

##### 3. Uses descriptive activity names to name the activities in the data set

3.1. read the activities table

```Rscript
activities <- read.table("UCI HAR Dataset//activity_labels.txt")
```

3.2. clean up activities names, remove underscores and convert to lower case

```Rscript
activities[, 2] <- gsub("_", "", activities[, 2])
activities[, 2] <- tolower(as.character(activities[, 2]))
```

3.3 replace activity id with full name

```Rscript
Y[,1] <- activities[Y[,1], 2]
names(Y) <- c("activity")
```

##### 4. Appropriately labels the data set with descriptive variable names

4.1. add the missing column name subject

```Rscript
names(subject) <- c("subject")
```

4.2. join all tables together

```Rscript
data <- cbind(subject, Y, X)
```

4.3 save table to file

```Rscript
write.table(data, "data.txt")
```

##### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

5.1. get the unique list of subjects

```Rscript
subjects <- unique(data$subject)
```

5.2. Initialize a data frame for the new table with the same columns, stored in data_2

```Rscript
data_2 <- data
data_2 <- data_2[0,]
```

5.3 for each subject, and each activity do

```Rscript
for (s in subjects) {
  for (a in activities[,2]) {
    ...
  }
}
```

5.3.1. filter the data frame to only have rows corresponding to the current subject and activity

```Rscript
filtered <- filter(data, subject==s & activity==a)
```

5.3.2. get all columns with values for this subject and activity except the subject and activity columns

```Rscript
all_values <- select(filtered, -(subject:activity))
```

5.3.3. compute the mean for each column

```Rscript
all_means <- summarise_each(all_values, funs(mean))
```

5.3.4. create a new row for the current subject and activity

```Rscript
new_row <- data.frame(subject=s, activity=a)
```

5.3.5. bind the new row with all the means

```Rscript
new_row <- cbind(new_row, all_means)
```

5.3.6. add the new row to the data frame

```Rscript
data_2 <- rbind(data_2, new_row)
```

5.4. write the data frame to file

```Rscript
write.table(data_2, "data_2.txt", row.name=FALSE)
```
