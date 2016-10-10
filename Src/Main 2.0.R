# Satcos Happy Nurse
# Job scheduling algorithm with constant load
# There are two type of resource available CC and MS
# Schedule is generated for 28 days, 4 week. Week start with Sunday
# Work load on Saturday and Sunday are fixed hence not handled
# Nurse has to work minimum 2 days in a week and maximum 3 day in a week
# Total number of working day per 4 week is 9 (Excluding the Saturday and Sunday)
# There should be minimum given number of Type 1 and Total number of nurse working in a day

# Input: void
# Output: Void
cat("\nLoading Main 2.0.R")
Main <- function()	{
	# Loading the required library
	library('lpSolve')
	
	# Noting Down the stat time
	startTime <- Sys.time()
	
	# Welcome message with version of the main file
	print("*****Satcos Happy Nurse*****")
	print("***Scheduling***")
	print("Version 2.0")
	
	# Setting option for String value in CSV files
	options(stringsAsFactors = FALSE)
	
	# Constant
	kTYPE1 <- "CC"
	kTYPE2 <- "MS"
	
	# Model Schedule contain the input requirement.
	# This file contain scheduling for Saturday and Sunday also
	# As our model is independent of Sat/Sun removing columns corresponding to Sat/Sun
	modelScheduleActual <- ReadInputData("modelSchedule.csv")
	modelSchedule <- modelScheduleActual[, c(1, 2,					# Name and Type of Nurse
										4, 5, 6, 7, 8,				# Mon to Fri week 1
										11, 12, 13, 14, 15,			# Mon to Fri week 2
										18, 19, 20, 21, 22,			# Mon to Fri week 3
										25, 26, 27, 28, 29)]		# Mon to Fri week 4
	
	# Cell code
	# -2 Leave
	# -1 Requested not to work
	# 0 Ready to work/not work
	# 1 Requested to work
	# -1 and 1 can be over ridden
	# Filling Blank Cells with Zero
	modelSchedule[is.na(modelSchedule)] <- 0
	modelScheduleActual[is.na(modelScheduleActual)] <- 0
	
	# Variables
	constraint <- list()
	noOfNurse <- nrow(modelSchedule)
	type1Nurse <- length(modelSchedule[modelSchedule[, 2] == kTYPE1, 2])
	type2Nurse <- length(modelSchedule[modelSchedule[, 2] == kTYPE2, 2])
	type1Needed <- 0
	nurseNeededPerDay <- 0
	
	# Read user input
	nurseNeededPerDay <- as.integer(readline("Total no of nurse needed per day: "))
	if(is.na(nurseNeededPerDay))	{
		print("Total No of Nurse needed should be integer.")
		stop()
	}
	type1Needed <- as.integer(readline(paste(kTYPE1, " nurse needed per day: ")))
	if(is.na(type1Needed))	{
		print(paste(kTYPE1, " Nurse needed should be integer."))
		stop()
	}
	
	# Confirm the input and print status message
	cat("\n Total No of Nurse working: ", noOfNurse,
		"\n Total No of Nurse needed per day: ", nurseNeededPerDay,
		"\n ", kTYPE1, " Nurse needed per day: ", type1Needed,
		"\n Creating schedule.",
		"\n This process may take few minutes. Please wait....", sep="")
	
	# Check for feasibility of solution
	majorError <- FeasibilityCheck(modelSchedule, noOfNurse, type1Nurse, type1Needed, nurseNeededPerDay, kTYPE1)
	if(majorError == 1)	
		cat("\n Not enough resource or many are taking leave")
	else if(majorError == 2)
		cat("\n Not enough ", kTYPE1, "resource or many are taking leave")
	else if(majorError == 3)
		cat("\n Not enough resource or many are taking leave",
			"\n And not enough ", kTYPE1, "resource or many are taking leave")
	if(majorError > 0)	{
		cat("\n ")
		stop()
	}
	
	# Since feasible, construct constraints
	constraint <- GetConstraint(modelSchedule, noOfNurse, nurseNeededPerDay, type1Needed, kTYPE1)
	noOfOptVar <- noOfNurse * 20
	# Objective and direction of constraint
	f.obj <- as.vector(t(modelSchedule[, 3:22]))
	f.con <- constraint$con
	f.dir <- constraint$dir
	f.rhs <- constraint$rhs
	
	# Solve the problem
	res <- lp ("max", f.obj, f.con, f.dir, f.rhs, all.bin=TRUE)
	
	# Print the solution status
	if(res$status == 0)
		cat("\n Succesfully scheduled.",
			"\n Calculating Nurse satisfaction rate...", sep="")
	else	{
		cat("\n Sorry. Can not be scheduled with this resource",
			"\n Try reducing leave\n ", sep="")
		stop()
	}
	
	# Generate solution
	Solution <- modelSchedule
	Solution[, 3:22] <- matrix(res$solution, noOfNurse, byrow=TRUE)
	satisfactionRate <- GetSatisfaction(modelSchedule, Solution, noOfOptVar)
	
	# Porting solution to input format
	modelScheduleActual[, c(4, 5, 6, 7, 8,			# Mon to Fri week 1
							11, 12, 13, 14, 15,		# Mon to Fri week 2
							18, 19, 20, 21, 22,		# Mon to Fri week 3
							25, 26, 27, 28, 29)] <- Solution[, 3:22]
	Solution <- modelScheduleActual
	Solution <- rbind(Solution, c("No of Nurse Available", "", colSums(Solution[, 3:30])))
	cat("\n Writing output file...", sep="")
	WriteOutputData(Solution)
	cat("\n *****************",
		"\n Nurse Satisfaction Rate: ", satisfactionRate, "%",
		"\n Please check solution file in Data folder for schedule.",
		"\n *****************", sep="")
	
	# Taking the end time
	endTime <- Sys.time()
	timeDiff <- difftime(endTime,startTime,units = c("secs"))
	cat("\n Time Taken: ",timeDiff, " Sec\n", sep="")
}