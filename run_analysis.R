# Load the string and dplyr packages and set the working directory to the one 
# that contains the training and test datasets

library("stringr")
library("dplyr")
setwd("UCI HAR Dataset/")

# This function merges two text files into another text file
merge_txt_files <- function(f1,f2){
  t1 <- read.table(f1)
  t2 <- read.table(f2)
  t <- rbind(t1,t2) # returns a merged dataframe
  write.table(t,paste(str_extract(f1,"([a-zA-Z]+_)+"),"merged.txt",sep=""),row.names = FALSE,col.names = FALSE)
}

# The following function merges all the corresponding files in two directories into a new directory
merge_dirs <- function(dir_1,dir_2){
  filelist1 <- setdiff(list.files(dir_1,full.names = TRUE), list.dirs(dir_1,recursive = FALSE, full.names = TRUE))
  filelist2 <- setdiff(list.files(dir_2,full.names = TRUE), list.dirs(dir_2,recursive = FALSE, full.names = TRUE)) # To only get the file names and not directory names
  mapply(merge_txt_files,filelist1,filelist2) # returns a list of merged files
}

# Merge the test and training data sets into a dataset called merged recursively
if (dir.exists("merged")){
      unlink("merged",recursive = TRUE)
    }
    dir.create("merged")
    setwd("merged/")
    merge_dirs("../test/","../train/")
    
    if (dir.exists("Inertial Signals merged" )){
      unlink("Inertial Signals merged",recursive = TRUE)
    }
    dir.create("Inertial Signals merged")
    setwd("Inertial Signals merged/")
    merge_dirs("../../test/Inertial Signals","../../train/Inertial Signals")

setwd("../../")

# Read the features and merged sets into dataframes
features <- read.table("features.txt")
merged <- read.table("merged/X_merged.txt")

# Obtain the locations of means and standard deviations in the features data frame
mean_locations <- grep("mean()",features[,2])
std_locations <- grep("std()",features[,2])

# Extract only the means and stds from merged dataset
extract_merged <- merged[,c(mean_locations,std_locations)]
names(extract_merged) <- features[c(mean_locations,std_locations),2]

# Create a column of activity labels for merged set  and make replacements
act_labels_merged <- read.table("merged/y_merged.txt")
for(i in 1:nrow(act_labels_merged)){
  if(act_labels_merged[i,1] == 1){
    act_labels_merged[i,1] = "WALKING"
  }
  if(act_labels_merged[i,1] == 2){
    act_labels_merged[i,1] = "WALKING_UPSTAIRS"
  }
  if(act_labels_merged[i,1] == 3){
    act_labels_merged[i,1] = "WALKING_DOWNSTAIRS"
  }
  if(act_labels_merged[i,1] == 4){
    act_labels_merged[i,1] = "SITTING"
  }
  if(act_labels_merged[i,1] == 5){
    act_labels_merged[i,1] = "STANDING"
  }
  if(act_labels_merged[i,1] == 6){
    act_labels_merged[i,1] = "LAYING"
  }
}

# Now add these to extract_merged
extract_merged <- cbind(act_labels_merged,extract_merged)
colnames(extract_merged)[1] <- "Activity Label"
colnames(extract_merged)[2:80] <- as.character(features[c(mean_locations,std_locations),2])
setwd("merged/")

# Finally, create a new independent dataset with the average of each variable for each activity and each subject
subjects <- 1:30
activity_labels <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
subject_merged <- read.table("subject_merged.txt",col.names = "Subject")
df <- cbind(subject_merged,extract_merged)

final <- data.frame(matrix(nrow = 0,ncol = 81))
colnames(final) <- colnames(df)

# The following creates a dataframe final that has the required data
for(i in activity_labels){
  for(j in subjects){
    temp <- subset(df,df$Subject == j & df$`Activity Label`== i)
    temp <- data.frame(matrix(c(j,i,colMeans(temp[3:81])),nrow = 1))
    colnames(temp) <- colnames(df)
    final <- rbind(final, temp)
  }
}

# The dataframe final is exported to a text file in the merged directory
write.table(final,"final_merged.txt",row.names = FALSE,quote = FALSE)



