# merging X_train & X_test
X_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
X_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
features <- read.table('./UCI HAR Dataset/features.txt')[,2]
names(X_train) = features
names(X_test) = features
X_data <- rbind(X_train, X_test)

# merging y_train & y_test
y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')
y_data = rbind(y_train, y_test)

# changing IDs to descriptive names of activities
activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt')
y_data[,2] = activity_labels[y_data[, 1], 2]
names(y_data) = c('Activity_id', 'Activity')
y_data

# merging subject_test & subject_train
subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
subject_data <- rbind(subject_train, subject_test)
names(subject_data) = 'Subject'

# merging the whole data
data <- cbind(X_data, subject_data, y_data)

# extracting mean & std features only
needed_features <- grepl('mean|std', features)
data <- data[, needed_features]

# calculating mean values for each subject & activity
library(reshape2)
id_labels <- c('Subject', 'Activity_id', 'Activity')
data_labels <- setdiff(names(data), id_labels)
melt_data <- melt(data, id = id_labels, measure.vars = data_labels)
data_mean <- dcast(melt_data, Subject + Activity ~ variable, mean)

# writing down the data
write.table(data_mean, file = 'data.txt',row.name=FALSE)
