#homework
#data
library(data.table)
fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UCI HAR Dataset.zip')){
        download.file(fileurl,'./UCI HAR Dataset.zip', mode = 'wb')
        unzip("UCI HAR Dataset.zip", exdir = getwd())
}

#load data

setwd("C:/Users/USUARIO/Desktop/Specialization/3 reading data/UCI HAR Dataset")
features <- read.csv('features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])

setwd("C:/Users/USUARIO/Desktop/Specialization/3 reading data/UCI HAR Dataset/train")
data.train.x <- read.table('X_train.txt')
data.train.activity <- read.csv('y_train.txt', header = FALSE, sep = ' ')
data.train.subject <- read.csv('subject_train.txt',header = FALSE, sep = ' ')

data.train <-  data.frame(data.train.subject, data.train.activity, data.train.x)
names(data.train) <- c(c('subject', 'activity'), features)

setwd("C:/Users/USUARIO/Desktop/Specialization/3 reading data/UCI HAR Dataset/test")
data.test.x <- read.table('X_test.txt')
data.test.activity <- read.csv('y_test.txt', header = FALSE, sep = ' ')
data.test.subject <- read.csv('subject_test.txt', header = FALSE, sep = ' ')

data.test <-  data.frame(data.test.subject, data.test.activity, data.test.x)
names(data.test) <- c(c('subject', 'activity'), features)

#Combine data

Total.data <- rbind(data.train, data.test)

#mean and sd

mean_std.select <- grep('mean|std', features)
data.sub <- Total.data[,c(1,2,mean_std.select + 2)]

#activity names
setwd("C:/Users/USUARIO/Desktop/Specialization/3 reading data/UCI HAR Dataset")
activity.labels <- read.table('activity_labels.txt', header = FALSE)
activity.labels <- as.character(activity.labels[,2])
data.sub$activity <- activity.labels[data.sub$activity]

#labels

Nname <- names(data.sub)
Nname <- gsub("[(][)]", "", Nname)
Nname <- gsub("^t", "TimeDomain_", Nname )
Nname  <- gsub("^f", "FrequencyDomain_", Nname )
Nname  <- gsub("Acc", "Accelerometer", Nname )
Nname  <- gsub("Gyro", "Gyroscope", Nname )
Nname  <- gsub("Mag", "Magnitude", Nname )
Nname  <- gsub("-mean-", "_Mean_", Nname )
Nname  <- gsub("-std-", "_StandardDeviation_", Nname )
Nname  <- gsub("-", "_", Nname )
Nname(data.sub) <- Nname

#second tidy data set

data.tidy <- aggregate(data.sub[,3:81], by = list(activity = data.sub$activity, subject = data.sub$subject),FUN = mean)
write.table(x = data.tidy, file = "data_tidy.txt", row.names = FALSE)
