# Code Book for Getting and Cleaning Data Project

Steps for data collection and cleaning are below. Documentation is also contained the R Script "run_analysis.R" for each step.

1. The data collected was from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Files were manually unzipped and saved to a directory called UCI HAR Dataset in my root directory
3. Files were manually examined to determine the layout
4. Files used in the analysis were:
    features.txt - contains the features of the test and training datasets (e.g. the variable names) 
    activity_labels.txt - contains the activity names and labels
    test/subject_test.txt - contains the subject number for each observation in the test dataset
    test/y_test.txt - contains the activity labels for each observation in the test dataset
    test/x_test.txt - contains the observations for the test dataset
    train/subject_train.txt - contains the subject number for each observation in the training dataset
    train/y_train.txt - contains the activity labels for each observation in the training dataset
    train/x_train.txt - contains the observations for the training dataset
5. The observations were separated randomly into groups of "test" and "train". The variable subject_type was created with values of "test" and "train" for each dataset.
6. The activity numbers were translated to the activity names and added to the datasets through column binding
7. Subject type was added with subject name and activity to each dataset - test and train
8. Datasets for both test and train had the features added as column names in place of the V1, V2, etc column names
9. Datasets were row bound together into one large dataset combo_data
10. Columns 306 to 347, 385 to 426 and 464 to 505 of the new dataset were deleted as these columns (with labels of bandsEnergy) were causing errors and not needed for the final output.
11. An id file was created to strip out the subject_no, subject_type and activity combinations since they were duplicate. 40 unique subject/activity combinations were saved in a new table (id_file)
12. The combo_dataset features were relabeled to remove repetition, make all characters lowercase, eliminate special characters and add spaces
    BodyBody was consolidated to Body
    tBody translated to "body "
    tGravity to "gravity "
    Acc to "acceleration "
    Gyro to "gyroscope "
    Jerk to "with jerk signal "
    fBody to "fft body " where fft stands for Fast Fourier Transform
    Mag to "magnitude "
13. Variables with mean() in the title were selected for dataset combo_means and the "()" removed from the labels. The id variable was retained.
14. Variables with std() in the title were selected for dataset combo_std and the "()" removed from the labels. The id variable was retained.
15. Tables not needed at the end were removed to clean up the output.
16. The mean of the values in combo_means was created by 
    adding back the id_file values for subject_no and activity
    taking the mean of all values other than subject_no and activity using the aggregate function
    relabeling to make the final output meaningful
