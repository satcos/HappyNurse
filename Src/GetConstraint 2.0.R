# Input: void
# Output: Void
cat("\nLoading GetConstraint 2.0.R")
GetConstraint <- function(modelSchedule, noOfNurse, nurseNeededPerDay, type1Needed, kTYPE1)	{
	
	constraint <- list()
	noOfOptVar <- noOfNurse * 20
	# Working Day constraint
	# 2 Days for 3 weeks and 
	# 3 Days for 1 week
	
	# Formulating the constraint
	# Constraint for single nurse is formulated and it is used for all other
	# First two make sure nurse working for min 2 days and max 3 days in 1st week
	# Constraint 3 to 8 does it for week 2, 3 and 4
	# Constraint 9 makes sure total working day for the nurse/week is 9 days
	# singleNurse matrix with 9 rows and 20 columns with zero entry
	singleNurse <- mat.or.vec(9, 20)
	singleNurse[1, 1:5] <- 1
	singleNurse[2, 1:5] <- 1
	singleNurse[3, 6:10] <- 1
	singleNurse[4, 6:10] <- 1
	singleNurse[5, 11:15] <- 1
	singleNurse[6, 11:15] <- 1
	singleNurse[7, 16:20] <- 1
	singleNurse[8, 16:20] <- 1
	singleNurse[9, 1:20] <- 1
	# Constraint for multiple nurse
	# Replicate the template created for single nurse
	multiNurse <- mat.or.vec(9 * noOfNurse, noOfOptVar)
	for(i in 1:noOfNurse)	{
		multiNurse[(1 + (i-1) * 9):(9 + (i-1) * 9), (1 + (i-1) * 20):(20 + (i-1) * 20)] <- singleNurse
	}
	
	# No of Nurse per day constraint
	nursePerDay <- mat.or.vec(20, noOfOptVar)
	for(i in 1:20)	{
		nursePerDay[i, seq(i, noOfOptVar, 20)] <- 1
	}
	type1NursePerDay <- nursePerDay
	for(i in 1:noOfNurse)	{
		if(modelSchedule[i, 2] != kTYPE1)
			type1NursePerDay[, (1 + (i - 1) * 20):(20 + (i - 1) * 20)] <- 0
	}
	
	# Leave constraint
	leaveConstraint <- modelSchedule[, 3:22]
	leaveConstraint[leaveConstraint != -2] <- 0
	leaveConstraint[leaveConstraint == -2] <- 1
	leaveConstraint <- as.vector(t(leaveConstraint))
	
	# Bind all the constraints
	constraint$con <- rbind(multiNurse, nursePerDay, type1NursePerDay, leaveConstraint)
	
	# Set directions for each constraint
	constraint$dir <- c(	rep(c(">=", "<=", ">=", "<=", ">=", "<=", ">=", "<=", "=="), noOfNurse),
							rep(">=", 20),
							rep(">=", 20),
							"==" )
	# Rhs of constraint
	constraint$rhs <- c(	rep(c(2, 3, 2, 3, 2, 3, 2, 3, 9), noOfNurse),
							rep(nurseNeededPerDay, 20),
							rep(type1Needed, 20),
							0 )
	
	
	# Altering working days on the week when leave is availed
	# Removing first 2 columns of model schedule as it is no use for the next para of code
	modelSchedule <- modelSchedule[, 3:22]
	leave <- NULL
	for(i in 1:noOfNurse)	{
		val1 <- rep(0, 9)
		val1[1:2] <- sum(modelSchedule[i, 1:5] == -2)
		val1[3:4] <- sum(modelSchedule[i, 6:10] == -2)
		val1[5:6] <- sum(modelSchedule[i, 11:15] == -2)
		val1[7:8] <- sum(modelSchedule[i, 16:20] == -2)
		val1[9] <- sum(val1[c(1, 3, 5, 7)])
		leave <- c(leave, val1)
	}
	constraint$rhs[1:(9 * noOfNurse)] <- constraint$rhs[1:(9 * noOfNurse)] - leave
	return(constraint)
}