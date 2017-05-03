# Class Statistics


###############################################
#           LOAD PACKAGES + DATA              #
###############################################

# Load required packages
library(readr)
library(gdata)

# Load data
gradebk = read_csv('Gradebook.csv')


###############################################
#           CLEANING + REFORMATTING           #
###############################################

# ========= Cleaning ==========================

# Eliminate irrelevant columns
gradebk = gradebk[ , -c(2, 25, 33:34)]

# Strip whitespace
for (i in c(which(sapply(gradebk, class) == 'character'))) {
  gradebk[, i] = trim(gradebk[, i])
}

# Treat 'P' and 'Excused' codes as 'NA'
for (i in c(which(sapply(gradebk, class) == 'character'))) {
  gradebk[, i] = replace(gradebk[, i], gradebk[, i] == 'P', NA)
  gradebk[, i] = replace(gradebk[, i], gradebk[, i] == 'Excused', NA)
}


# ========= Reformatting ======================

# Subset by class tracks (Math/STS 50; Math 112)
math_track = gradebk[which(gradebk$Track == 112), -21]
read_track = gradebk[which(gradebk$Track == 50), ]


###############################################
#           COMPUTE STATISTICS                #
###############################################

# TODO: FINISH THIS PART
pset.stats <- function( student ) {
  ######## DESCRIPTION ########
  # Compute statistics for 
  # problem sets.
  
  ######## ARGS ###############
  # df - (Dataframe) Gradebook.
  
  ######## OUTPUT #############
  # stats - (Vector) Vector of
  # problem sets' statistics.

  # Initialize output vector
  stats = rep(0, nrow(df))
  
  # Get columns containing problem set scores
  ps_df = df[, 3:11]
  
  # Get denominators for each assignment/student
  for (i in ncol(ps_df)) {
    
    # Split columns by '/'
    
    # Appropriately handle NA's & '0' scores
    
  }
  
  # Populate stats
  
}


rr.stats <- function( df ) {
  ######## DESCRIPTION ########
  # Compute statistics for
  # reading responses.
  
  ######## ARGS ###############
  # df - (Dataframe) Dataframe
  # corresponding to the given
  # class track (Math/Reading).
  
  ######## OUTPUT #############
  # stats - (Vector) Vector of
  # reading response statistics.
  
  # Initialize output vector
  stats = rep(0, nrow(df))
  
  # Get columns containing RR scores
  if (df == math_track) {
    
    # Appropriate columns for math track
    rr_df = df[, c(12:22)]
    
  } else { # Reading track (Math/STS 50)
    
    # Appropriate columns for reading track
    rr_df = df[, c(12:23)]
  }
  
  # Populate stats
  for (i in 1:nrow(df)) {
    
    # Get current student's RR scores
    temp = as.numeric(rr_df[i, ])
    
    # Compute average of student's RR scores (omit NA's)
    stats[i] = mean(temp, na.rm = TRUE)
  }
  
  return(stats)
}


# TODO: Quizzes

###############################################
#           SAVE + EXPORT DATA                #
###############################################

# TODO