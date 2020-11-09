#Read the test data into R.
xTestData <- read.table("X_test.txt", header = FALSE, fill = TRUE)

yTestData <- read.table("Y_test.txt", header = FALSE, fill = TRUE)

subjectTestData <- read.table("subject_test.txt", header = FALSE, fill = TRUE)

#We add the y-test activity data and subject test data as new columns to the x-test data frame.
xTestData <- data.frame(activity = yTestData[, "V1"], xTestData)
xTestData <- data.frame(subject = subjectTestData[, "V1"], xTestData)

#print(nrow(xTestData))
#print(ncol(xTestData))
#print(xTestData[1, ])

#Read the training data into R.
xTrainData <- read.table("X_train.txt", header = FALSE, fill = TRUE)

yTrainData <- read.table("Y_train.txt", header = FALSE, fill = TRUE)

subjectTrainData <- read.table("subject_train.txt", header = FALSE, fill = TRUE)

#We add the y-train activity data and subject training data as new columns to the x-train data frame.
xTrainData <- data.frame(activity = yTrainData[, "V1"], xTrainData)
xTrainData <- data.frame(subject = subjectTrainData[, "V1"], xTrainData)

#print(nrow(xTrainData))
#print(ncol(xTrainData))
#print(xTrainData[1, ])

#Now we combine the two datasets into one. We want to keep all rows, so we do something like a "union all", using rbind:
combinedTestTrainData <- rbind(xTestData, xTrainData)

#print(nrow(combinedTestTrainData))
#print(ncol(combinedTestTrainData))

#Read the features (aka column names) into R.
features <- read.table("features.txt", header = FALSE, fill = TRUE)

#Read the activity labels into R.
activities <- read.table("activity_labels.txt", header = FALSE, fill = TRUE)

#Since it's a bad idea to assume things, we apply the "order" function on our features dataset so that they are guaranteed to be sorted by the ID numbers.
featureOrderIndex <- order(features$V1, features$V2, decreasing = FALSE, na.last = TRUE)
featuresOrdered <- features[featureOrderIndex, ]

#print(featuresOrdered)

#Extract the names of the features, now in the proper order.
featureNames <- featuresOrdered[, "V2"]

#Since we have added two new columns (activity data and subject data), we'll need to add those as names to the beginning of our featureNames vector.
featureNames <- c(c("subject", "activity"), featureNames)

#print(featureNames)

#Set the column names for our main dataset.
colnames(combinedTestTrainData) <- featureNames

#Now, we need to replace activity ID's with activity names. To do that, we loop through the activities data frame we set up from the activity labels file and apply a replacement.
#In the main dataset's "activity" column, we replace each instance of an ID with the corresponding activity name/label.
for (actRowNum in 1:nrow(activities)) {
      activityID <- activities[actRowNum, "V1"]
      activityName <- activities[actRowNum, "V2"]
      combinedTestTrainData$activity[combinedTestTrainData$activity == activityID] <- activityName
}

#print(colnames(combinedTestTrainData))
#print(combinedTestTrainData[, "activity"])
#print(head(combinedTestTrainData, n = 10))

#Now that we have the combined dataset with both column labels and activity labels, it's time to extract a subset of it that only represents means and standard deviations.
#To do that, we will use grep when subsetting and use a regular expression representing column labels that contain "mean()" and "std()".
testTrainMeanStdDevData <- combinedTestTrainData[, grep("(subject|activity|(.*(mean\\(\\)|std\\(\\)).*))", colnames(combinedTestTrainData))]

#print(nrow(testTrainMeanStdDevData))
#print(ncol(testTrainMeanStdDevData))
#print(colnames(testTrainMeanStdDevData))

#Next step - we make the column names that we obtained for the means and standard deviations more user friendly for our tidy data.
#For starters, we replace the first part of the name, e.g. "tBody" with "TimeBody", or "fBody" with "FrequencyBody". We can just use "sub" here.
colnames(testTrainMeanStdDevData) <- sub("tBody", "TimeBody", colnames(testTrainMeanStdDevData))
colnames(testTrainMeanStdDevData) <- sub("tGravity", "TimeGravity", colnames(testTrainMeanStdDevData))
colnames(testTrainMeanStdDevData) <- sub("fBody", "FrequencyBody", colnames(testTrainMeanStdDevData))
colnames(testTrainMeanStdDevData) <- sub("fGravity", "FrequencyGravity", colnames(testTrainMeanStdDevData))

#We can replace further strings like "BodyGyro" with "BodyGyroscope", "GravityAcc" with "GravityAccelerometer", etc., using sub.
colnames(testTrainMeanStdDevData) <- sub("BodyGyro", "BodyGyroscope", colnames(testTrainMeanStdDevData))
colnames(testTrainMeanStdDevData) <- sub("BodyAcc", "BodyAccelerometer", colnames(testTrainMeanStdDevData))
colnames(testTrainMeanStdDevData) <- sub("GravityGyro", "GravityGyroscope", colnames(testTrainMeanStdDevData))
colnames(testTrainMeanStdDevData) <- sub("GravityAcc", "GravityAccelerometer", colnames(testTrainMeanStdDevData))
colnames(testTrainMeanStdDevData) <- sub("GyroscopeMag", "GyroscopeMagnitude", colnames(testTrainMeanStdDevData))
colnames(testTrainMeanStdDevData) <- sub("AccelerometerMag", "AccelerometerMagnitude", colnames(testTrainMeanStdDevData))
colnames(testTrainMeanStdDevData) <- sub("JerkMag", "JerkMagnitude", colnames(testTrainMeanStdDevData))

#To get rid of all the dashes, we use gsub.
colnames(testTrainMeanStdDevData) <- gsub("-", "", colnames(testTrainMeanStdDevData))

#Finally, we can change all instances of "mean()" to "Mean" and "std()" to "Std". That would both get rid of the parentheses and make the words "mean" and "std" capitalized at the first letter
#in order to keep the casing format consistent.
colnames(testTrainMeanStdDevData) <- gsub("mean\\(\\)", "Mean", colnames(testTrainMeanStdDevData))
colnames(testTrainMeanStdDevData) <- gsub("std\\(\\)", "Std", colnames(testTrainMeanStdDevData))

#print(colnames(testTrainMeanStdDevData))

#Now here comes the final tidy dataset step, where we average each column over the activities and subjects.
tidyTestTrainDataWithAvgs <- aggregate(x = testTrainMeanStdDevData[3:ncol(testTrainMeanStdDevData)], by = list(activity = testTrainMeanStdDevData$activity, subject = testTrainMeanStdDevData$subject), FUN = "mean")

#print(nrow(tidyTestTrainDataWithAvgs))
#print(ncol(tidyTestTrainDataWithAvgs))
#print(tidyTestTrainDataWithAvgs)

#We now write our dataset to a txt file.
write.table(x = tidyTestTrainDataWithAvgs, file = "TestAndTrainTidyData.txt", row.names = FALSE)
tidyTestTrainDataWithAvgs



