##1. Merges the training and the test sets to create one data set.
testx = read.table("X_test.txt")
testy = read.table("y_test.txt")
testsubject = read.table("subject_test.txt")
trainx = read.table("X_train.txt")
trainy = read.table("y_train.txt")
trainsubject = read.table("subject_train.txt")

names(testy) = "activity"
names(trainy) = "activity"
names(testsubject) = "subject"
names(trainsubject) = "subject"
features = read.table("features.txt")
names(testx) = features[,2]
names(trainx) = features[,2]

library("dplyr")
test = bind_cols(testx, testy)
test = bind_cols(testsubject, test)
train = bind_cols(trainx, trainy)
train = bind_cols(trainsubject, train)
data = bind_rows(test, train)
 

##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
new_cols = ((grepl("mean", names(data)) | grepl("std", names(data))) & !grepl("meanFreq", names(data))) | grepl("subject", names(data)) | grepl("activity", names(data))
data = data[,new_cols]


##3.Uses descriptive activity names to name the activities in the data set
data$activity <- factor(data$activity, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))


##4. Appropriately labels the data set with descriptive variable names. 
names(data) = gsub("\\()", "", names(data))


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data_avgs <- data %>% group_by(activity, subject) %>% summarise_each(funs(mean))
  