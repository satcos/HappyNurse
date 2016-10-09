# This Function is used to load other function to work space.
# Input: void
# Output: Void
# It tells where the other files and data are present
LoadHappyNurse <- function()	{

	# Parameter
	# Base path on which other source files present
	# Current working directory is the base path,
	# If source files are available in other directory,
	# this can be changed accordingly
	# Linux style path / (Forward slash) is supported in windows also
	basePath <<- ""
	
	# General Function to read input data
	source(paste(basePath, "Src/ReadInputData 2.0.R", sep=""))
	# General Function to write output data
	source(paste(basePath, "Src/WriteOutputData 2.1.R", sep=""))
	
	# Function needed for scheduling
	source(paste(basePath, "Src/Main 2.0.R", sep=""))
	source(paste(basePath, "Src/GetConstraint 2.0.R", sep=""))
	source(paste(basePath, "Src/FeasibilityCheck 2.0.R", sep=""))
	source(paste(basePath, "Src/GetSatisfaction 1.0.R", sep=""))	
	
	cat("\nAll Required files are loaded successfully\n")
	
}
