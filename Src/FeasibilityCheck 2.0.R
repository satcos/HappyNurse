# Input: void
# Output: Void
cat("\nLoading FeasibilityCheck 2.0.R")
FeasibilityCheck <- function(modelSchedule, noOfNurse, type1Nurse, type1Needed, nurseNeededPerDay, kTYPE1)	{
	# Initialize major error to zero
	majorError <- 0
	# Compute total needed and total available
	manDayLeave <- sum(modelSchedule == -2)
	manDayNeeded <- nurseNeededPerDay * 20
	manDayAvailable <- 9 * noOfNurse - manDayLeave
	# Increment the error value
	if(manDayAvailable < manDayNeeded)	{
		majorError <- majorError + 1
	}

	# Check for Type 1 nurse availability
	type1ManDayLeave <- sum(modelSchedule[modelSchedule[, 2] == kTYPE1, ] == -2)
	type1ManDayNeeded <- type1Needed * 20
	type1ManDayAvailable <- 9 * type1Nurse - type1ManDayLeave
	if(type1ManDayAvailable < type1ManDayNeeded)	{
		majorError <- majorError + 2
	}
	
	# Major error == 1, First type error
	# Major error == 2, Second type error
	# Major error == 3, Both type error
	
	return(majorError)
}