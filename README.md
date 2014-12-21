Getting and Cleaning Data - Course Project
==========================================

Introduction
------------
This repository contains the course project for Chuck Thompson for the
"Getting and Cleaning Data" Coursera course (part of the Data Science
specialization track).

This assignment is documented on the [course project webpage](https://class.coursera.org/getdata-016/human_grading/view/courses/973758/assessments/3/submissions).


Repository Files
----------------
* **run_analysis.R**:  R script used to transform the raw data set into two
    + Details about how this script works can be found in the Codebook.md file.  It is also extensively commented.
tidy data sets, the second of which will be saved. 
* **Codebook.md**:  Documentation on the raw and tidy data sets and how the
raw data was transformed into the tidy data set.
* **tidy-dataset.txt**:  Output of the run_analysis.R script.
    + This is the answer to step 5 of the project assignment.  It is a tidy dataset that contains the average value for a number of variables in the original data set for each subject and each activity they performed.
    + Details about this data file can be found in the Codebook.md file.



Creating and Viewing the Tidy Data Set
--------------------------------------

1. Clone this repository:  'git clone https://github.com/chuckthompson/gettingandcleaningdata'
2. Change your working directory to the root directory of the cloned repository.
3. Download the [raw data file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
4. Unzip this file making sure that the 'UCI HAR Dataset' directory is now in the root of the repository.
5. Start R or Rstudio and set the working directory to the repository root using the `setwd()` command.
6. If you do not already have the reshape2 package installed, install it now using the command `install.packages("reshape2")`
7. Run the script using the command:  `source ('run_analysis.R')`
8. Verify that the file `tidy-dataset.txt` now exists in the root of the repository.
9. You may view this data set using the following commands:
    + `tidyData <- read.table("tidy-dataset.txt", header = TRUE)`
    + `View(tidyData)`