# Human-Activity-Recognition-using-smart-phones

This repository contains the script (run_analysis.R) necessary for obtaining the file 'final_merged.txt' from the UCI HAR dataset.
The script needs to be in the same directory as the dataset for it to run without any errors.

It first creates a directory called 'merged' in the UCI HAR dataset. If a directory with that name already exists, it deletes that before creating it again.

It first merges all the corresponding files from the test and training datasets row-wise and places them in the merged dataset with the name 'merged' in them. For example, 'subject_train.txt' and 'subject_test.txt' are combined from the training and test sets respectively into 'subject_merged.txt' and places it in the 'merged' directory. The script also merges the 'Inertial_Signals' directories from both the test and training sets recursively and creates 'Inertial_Signals_merged' directory.

Next, subjects and activity_labels are taken from the test and training sets, added to the merged 
