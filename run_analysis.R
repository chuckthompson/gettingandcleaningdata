## Getting and Cleaning Data by Roger D. Peng, Jeff Leek, Brian Caffo
## Course Project
## Course ID:  getdata-016
## Submitted by Chuck Thompson

# Load libraries with needed functions.
library(reshape2)   # for melt and dcast


# Define the subdirectory all of the data is in.
dataDir <- "UCI HAR Dataset"


# Read in the labeling information that is common to both groupings of data.
featureLabels <- read.table(paste0(dataDir, "/features.txt"))
activityLabels <- read.table(paste0(dataDir, "/activity_labels.txt"))


# Initialize a empty data frame that will be built up to become our tidy data.
tidyDataset <- data.frame()


# There are two sets of data located in different subdirectories.  The names of
# the files in each directory match except for the name of the particular group
# to which they belong.  The following for loop runs the same operations to
# read in the data from each subdirectory.
for (group in c("test", "train")) {
    # Define the path to the subdirectory we are going to read data from.
    dataGroupDir <- paste0(dataDir, "/", group)

    # Read in data file that defines subject each observation was about.
    dataSubjects <- read.table(paste0(dataGroupDir, "/subject_",
                                      group, ".txt"), col.names=c("Subject"))

    # Read in data that defines activity being performed for each observation.
    datayTest <- read.table(paste0(dataGroupDir, "/y_", group, ".txt"))

    # Read in data file with the measurements for each observation.
    dataXTest <- read.table(paste0(dataGroupDir, "/X_", group, ".txt"))

    # Create temp data frame with subject identifier as first column.
    tidyFrame <- dataSubjects

    # Add column to indicate which data group the observation was read from.
    tidyFrame <- cbind(Group = group, tidyFrame)

    # Add column with activity performed for each observation with the numeric
    # indicator from the data file converted to the appropriate label name.
    tidyFrame <- cbind(tidyFrame,
                       Activity = factor(datayTest$V1,labels=activityLabels$V2))

    # The tidy data set is to only include the mean and standard deviation for
    # each measurement.  We select only those observations where the
    # correponding label includes -mean() or -std().  This excludes some
    # variables that have meanFreq or Mean in their names.  These are not
    # straight mean values being either weighted means or involving other
    # additional calculations.
    dataXTest <- dataXTest[,grep("-mean\\(\\)|-std\\(\\)", featureLabels$V2)]

    # Select set of labels to be applied to selected data values using the same
    # selection method used for the data itself.
    groupLabels <- featureLabels[grep("-mean\\(\\)|-std\\(\\)",
                                      featureLabels$V2),"V2"]

    # Clean up the data labels so that they are tidy and consistent:
    #   Remove "()" (illegal in variable names)
    #   Replace '-' with '_' ('-' is illegal in variable names)
    #   Expand prefix "t" to "TimeDomain_" and prefix "f" to "FrequencyDomain_"
    #   Expand "Acc" to "Accelerometer" and "Gyro" to "Gyroscope"
    #   Expand "Mag" to "Magnitude"
    #   Correct "BodyBody" to just "Body"
    groupLabels <- gsub("\\(\\)", "", groupLabels)
    groupLabels <- gsub("\\-", "_", groupLabels)
    groupLabels <- sub("^t","TimeDomain_", groupLabels)
    groupLabels <- sub("^f","FrequencyDomain_", groupLabels)
    groupLabels <- sub("Acc","Accelerometer", groupLabels)
    groupLabels <- sub("Gyro", "Gyroscope", groupLabels)
    groupLabels <- sub("Mag", "Magnitude", groupLabels)
    groupLabels <- gsub("BodyBody", "Body", groupLabels)

    # Apply the cleaned up data labels to the measurements data.
    colnames(dataXTest) <- groupLabels

    # Add the measurements data to our temporary data frame.
    tidyFrame <- cbind(tidyFrame, dataXTest)

    # Add the temporary data frame to our overall tidy dataset.
    tidyDataset <- rbind(tidyDataset, tidyFrame)
}


# At this point "tidyDataset" is a completed tidy data version of the portion
# of the overall dataset that we were asked to provide for the assignment.
# This completes steps 1-4.  For step 5 we now need to create a second,
# independent tidy data set with the average of each variable for each activity
# and each subject.

# We first melt our original tidy dataset to convert it from a wide to a narrow
# dataset.
tidyDatasetMelt <- melt(tidyDataset,id=c("Group","Subject","Activity"))

# We then recast the melted dataset aggregated first by Subject and then
# Activity with the mean of all remaining variables added as associated values
# for each aggregated combination of Subject and Activity.
tidyDatasetCast <- dcast(tidyDatasetMelt, Subject + Activity ~ variable, mean)

# Output this second dataset to a file.
write.table(tidyDatasetCast, "tidy-dataset.txt", row.name=FALSE)