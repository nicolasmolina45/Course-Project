# Getting and Cleaning Data: Course Project

## Data Description - Source File URLs
## Merge training and test sets to create one data set
## Extract only measurements on mean and standard deviation
## Use descriptive activities names for activity measurements
## Appropriately Label the Dataset with Descriptive Variable Names
## Create tidy data set with average of each variable, by activity, by subject
## Session info

# Data Description - Source File URLs


# Obtención y limpieza de datos: Proyecto de curso

## Descripción de los datos - URL del archivo de origen
## Combinar conjuntos de prueba y entrenamiento para crear un conjunto de datos
## Extraer solo medidas sobre media y desviación estándar
## Use nombres de actividades descriptivos para las mediciones de actividad
## Etiquete adecuadamente el conjunto de datos con nombres de variables descriptivos
## Cree un conjunto de datos ordenado con el promedio de cada variable, por actividad, por tema
## Información de la sesión

# Descripción de los datos: URL del archivo de origen

dataDescription <- "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Download and Extract Zip Archive

## Descargar y extraer archivo zip

download.file(dataUrl, destfile = "data.zip")
unzip("data.zip")

# Merge training and test sets to create one data set

## Read Activity and Feature Labels

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt") #V2 contains label
features <- read.table("./UCI HAR Dataset/features.txt")  

## Read Test data

subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")

## Read Train data

subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")


## Combine subjects, activity labels, and features into test and train sets

test  <- cbind(subjecttest, ytest, Xtest)
train <- cbind(subjecttrain, ytrain, Xtrain)

## Combine test and train sets into total data set

totalDataSet <- rbind(test, train)

# Extract only measurements on mean and standard deviation

## Subset, keeeping mean, std columns; also keep subject, activity columns

featuresNames <- c("subject", "activity", as.character(features$V2))
meanStdColumns <- grep("subject|activity|[Mm]ean|std", featuresNames, value = FALSE)
reducedDataSet <- totalDataSet[ ,meanStdColumns]


#Use descriptive activities names for activity measurements

## Use indexing to apply activity names to corresponding activity number

names(activity_labels) <- c("activityNumber", "activityName")
reducedSet$V1.1 <- activity_labels$activityName[reducedSet$V1.1]

# Appropriately Label the Dataset with Descriptive Variable Names

## Use series of substitutions to rename varaiables

reducedNames <- featuresNames[meanStdColumns]    # Names after subsetting
reducedNames <- gsub("mean", "Mean", reducedNames)
reducedNames <- gsub("std", "Std", reducedNames)
reducedNames <- gsub("gravity", "Gravity", reducedNames)
reducedNames <- gsub("[[:punct:]]", "", reducedNames)
reducedNames <- gsub("^t", "time", reducedNames)
reducedNames <- gsub("^f", "frequency", reducedNames)
reducedNames <- gsub("^anglet", "angleTime", reducedNames)
names(reducedSet) <- reducedNames   # Apply new names to dataframe

# Create tidy data set with average of each variable, by activity, by subject

## Create tidy data set

tidyDataset <- reducedDataSet %>% group_by(activity, subject) %>% 
        summarise_all(funs(mean))

## Write tidy data to ouput file

write.table(tidyDataset, file = "tidyDataset.txt", row.names = FALSE)

# Call to read in tidy data set produced and validate steps
# validate <- read.table("tidyDataset.txt")
# View(validate)

# Session info

sessionInfo()




