# Input: void
# Output: Void
cat("\nLoading GetSatisfaction 1.0.R")
GetSatisfaction <- function(modelSchedule, Solution, noOfOptVar)	{
	modelSchedule <- modelSchedule[, 3:22]
	Solution <- Solution[, 3:22]
	
	
	Solution[modelSchedule == 0] <- 0
	modelSchedule[modelSchedule < 0 ] <- 0
	modelSchedule[modelSchedule > 0 ] <- 1
	satisfactionRate <- round(sum(modelSchedule == Solution) * 100 / noOfOptVar, 2)
	return(satisfactionRate)
}