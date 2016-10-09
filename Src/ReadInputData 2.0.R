# ReadInputData V2
# Argument:File name
# Return Type:Data Frame
cat("\nLoading Utility File ReadInputData 2.0.R")
ReadInputData <- function(filename)	{
	# This function will read data from input file and return it
	# File is located in "basePath"/Data folder.
	# To read data from different folder, variable "finename" should be edited
	filename <- paste(basePath, "Data/", filename, sep = "")
	myData <- read.csv(file=filename, head=TRUE)
	return(myData)
}