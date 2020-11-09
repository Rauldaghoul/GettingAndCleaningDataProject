# GettingAndCleaningDataProject

run_analysis.R:

This script does the following: it first reads the required data into R dataframes from the working directory, resulting in separate datasets - for each portion, test and training, it results in a main set with the data as well as dataframes to store activity numbers and subject numbers. Then, the script combines all the separate datasets for test into one, and all the separate datasets for training into one, forming two datasets. When these two datasets are formed, the script then merges them into one big combined dataset, followed by setting up meaningful column names representing the features (also loaded into R initially), and substituting activity numbers with activity names (an activity number/name mapping was also loaded into R).
Once the big dataset is prepared, the script creates a subset of it that only uses columns representing means and standard deviations for the data by matching a specific pattern in the column names that represents these quantities. Once these are obtained, the script sets up more meaningful names for these columns to take tidy data into account. Finally, the script takes the averages of all the means and standard deviations, grouping by activities and subjects - and places the results into the final dataframe. This dataframe is then saved to an output file for the project.

CodeBook.md:

This is the code book that describes all the mean and standard deviation columns that are part of the final tidy dataset in this analysis. The subject and activity columns are also included in the code book.
