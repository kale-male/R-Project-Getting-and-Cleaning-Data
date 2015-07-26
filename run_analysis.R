# Geting names of features for making it column names of table
ftrs <- read.table("./UCI HAR Dataset/features.txt")
ftrs <- ftrs$V2
# Geting data from X-files and unit it into one  table
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt",  col.names = ftrs)
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = ftrs)
Xtab <- rbind(Xtest,Xtrain)

# Creating a logical vector for those columns, where we meet functions mean() or std()
sub <- "(mean\\(\\)|std\\(\\))"
ftrs_lgc <- grepl(sub, as.character(ftrs))
Rez <- Xtab[,ftrs_lgc]
# Geting data from Y-files and unit it into single column table
Ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c("Y"))
Ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c("Y"))
Y <- rbind(Ytest, Ytrain)
# Geting activityes names and using it as levels of factor 
Actvts <- read.table("./UCI HAR Dataset/activity_labels.txt", colClasses = "character")
Y$Y <- as.factor(Y$Y)
levels(Y$Y) <- Actvts$V2
names(Y)[1]<-"Activity"
# then combine single column table with activityes  and previous result table
Rez <- cbind(Y, Xtab[,ftrs_lgc])

# Geting data from subject files and unit it into single column table, then bind it with previous result
Sbjtest <- read.table("./UCI HAR Dataset/test/subject_test.txt", colClasses = "integer")
Sbjtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", colClasses = "integer")
Sbj <- rbind(Sbjtest,Sbjtrain)
names(Sbj)[1]<-"Subject"
Rez <- cbind(Sbj, Rez)
# Melting dataset according columns "Subject" and "Activity"
library(reshape2)
Melted <- melt(Rez, id.vars=c("Subject", "Activity"))
# Using the average in column "mean", get the result
library(dplyr)
Grouped <- group_by(Melted, Subject, Activity, variable)
Result <- summarise(Grouped, mean=mean(value))
