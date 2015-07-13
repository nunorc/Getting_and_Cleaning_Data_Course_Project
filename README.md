## Getting and Cleaning Data
### Course Project

#### Data

* original data is available from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip (Last accessed: 13-07-2015)
* locally data is available under `UCI HAR Dataset/` in this repository

#### Executing

0. the script required the `dplyr` R package, make sure it's available (eg. `packages.install("dplyr")`
1. clone this repository or copy the `UCI HAR Dataset/` data directory and the `run_analysis.R` script
2. start R
3. change directory to where you copied the files (eg, using the `setwd()` F function)
4. execute the `run_analysss.R` script: `source("run_analysis.R")`

#### Results

* after running the script you should have to data frames in your R environment (`data` and `data_2`)
* and two text files should have been created in your project directory (`data.txt` and `data_2.txt` that contain the data frames in your environment)

    
