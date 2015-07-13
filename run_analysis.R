

## 1. Merges the training and the test sets to create one data set

# for X
t1 <- read.table("UCI HAR Dataset//train//X_train.txt")
t2 <- read.table("UCI HAR Dataset//test//X_test.txt")
X <- rbind(t1, t2)

# for Y
t1 <- read.table("UCI HAR Dataset//train//Y_train.txt")
t2 <- read.table("UCI HAR Dataset//test//Y_test.txt")
Y <- rbind(t1, t2)

# for subject
t1 <- read.table("UCI HAR Dataset//train//subject_train.txt")
t2 <- read.table("UCI HAR Dataset//test//subject_test.txt")
subject <- rbind(t1, t2)

# clean up
rm("t1", "t2")

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("UCI HAR Dataset//features.txt")
want <- grep("(mean|std)\\(\\)", features[,2])
X <- X[, want]
feature_names <- features[want, 2]
feature_names <- tolower(feature_names)
feature_names <- gsub("[\\(\\)\\-]", "", feature_names)
names(X) <- feature_names


## 3. Uses descriptive activity names to name the activities in the data set.

activities <- read.table("UCI HAR Dataset//activity_labels.txt")
activities[, 2] <- gsub("_", "", activities[, 2])
activities[, 2] <- tolower(as.character(activities[, 2]))
Y[,1] <- activities[Y[,1], 2]
names(Y) <- c("activity")


## 4. Appropriately labels the data set with descriptive variable names.

names(subject) <- c("subject")
data <- cbind(subject, Y, X)
write.table(data, "data.txt")


## 5. From the data set in step 4, creates a second, independent tidy data
#     set with the average of each variable for each activity and each subject.

subjects <- unique(data$subject)
data_2 <- data
data_2 <- data_2[0,]

for (s in subjects) {
  for (a in activities[,2]) {
    filtered <- filter(data, subject==s & activity==a)
    all_values <- select(filtered, -(subject:activity))
    all_means <- summarise_each(all_values, funs(mean))
    new_row <- data.frame(subject=s, activity=a)
    new_row <- cbind(new_row, all_means)
    data_2 <- rbind(data_2, new_row)
  }
}

write.table(data_2, "data_2.txt", row.name=FALSE)

# clean up
rm("X", "Y", "activities", "all_means", "all_values", "features", "filtered", "new_row", "subject")
rm("a", "feature_names", "s", "subjects", "want")