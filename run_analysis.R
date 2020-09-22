# Files already downloaded into directory

# Dataset files
features<-read.table("UCI HAR Dataset/features.txt", col.names = c("n","stats"))
activities<-read.table("UCI HAR Dataset/ActivityLabels.txt", col.names = c("ActivityLabel", "activity"))

# Test files
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Participant")
x_test<-read.table("UCI HAR Dataset/test/x_test.txt", col.names = features$stats)
y_test<-read.table("UCI HAR Dataset/test/y_test.txt", col.names = "ActivityLabel")

# Train files
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Participant")
x_train<-read.table("UCI HAR Dataset/train/x_train.txt", col.names = features$stats)
y_train<-read.table("UCI HAR Dataset/train/y_train.txt", col.names = "ActivityLabel")


# 1. create one dataset(by merging)
# rbind files that have the same column label to merge by rows
# rbind x
X <- rbind(x_test, x_train)

# rbind y
Y <- rbind(y_test, y_train)

# rbind subject
Participants <- rbind(subject_test, subject_train)

# merge all data by cbinding above files, to get data from each Participant
merged <- cbind(Participants, Y, X)

# 2. select mean and standard deviation for each Participant and activity(label)
selected_names<- grep("mean|std", names(merged), value= TRUE)
selected <- merged[c("Participant","ActivityLabel",selected_names)]

# 3. name data set activities
selected$ActivityLabel <- activities[selected$ActivityLabel,  2]

# 4. label data set variables
names(selected)<-gsub("BodyBody", "Body",names(selected))
names(selected)<-gsub(".std()", "Std",names(selected))
names(selected)<-gsub(".mean()", "Mean",names(selected))
names(selected)<-gsub("\\.+", "",names(selected))
names(selected)<-gsub("^t", "Time",names(selected))
names(selected)<-gsub("^f", "Frequency",names(selected))

# 5. use data in step 4 to create a tidy data set with avg of each variable for each activity and subject
# aggregate applies a function to each column of a df grouped by a list (by =)
avg_data <- aggregate(selected[3:ncol(selected)], 
                      by = list(Participant = selected$Participant, ActivityLabel =selected$ActivityLabel), FUN= mean)
write.table(avg_data, "AvgData.txt", row.name= FALSE)
