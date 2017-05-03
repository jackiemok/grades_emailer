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

pset.stats <- function( df ) {
  ######## DESCRIPTION ########
  # Compute students' average %
  # scores for all problem sets.
  
  ######## ARGS ###############
  # df - (Dataframe) Gradebook.
  
  ######## OUTPUT #############
  # stats - (Vector) Vector of
  # problem set score averages,
  # with each row corresponding
  # to a particular student.

  # Initialize output vector
  stats = rep(0.0, nrow(df))
  
  # Get denominators for each student's assignment [Split columns by '/']
  # Cannot do this in fewer lines because of '$' syntax
  out1 = strsplit(df$HW1, '/')
  out2 = strsplit(df$HW2, '/')
  out3 = strsplit(df$HW3, '/')
  out4 = strsplit(df$HW4, '/')
  out5 = strsplit(df$HW5, '/')
  out6 = strsplit(df$HW6, '/')
  out7 = strsplit(df$HW7, '/')
  out9 = strsplit(df$HW9, '/')
  out11 = strsplit(df$HW11, '/')
  
  # Bind all split columns together
  for (i in c(1, 2, 3, 4, 5, 6, 7, 9, 11)) {
    temp = do.call(rbind, get(paste0('out', as.character(i))))
    assign(paste0('temp', as.character(i)), temp)
  }
  
  ps_df = cbind(temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp9, temp11)
  rm(temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp9, temp11,
     out1, out2, out3, out4, out5, out6, out7, out9, out11, temp, df)
  
  # Populate stats
  for (i in 1:nrow(ps_df)) {
    
    # Get student's problem set % scores average
    # Appropriately handle NA's & '0' scores
    numerator = sum(as.numeric(as.character(ps_df[i, c(1, 3, 5, 7, 9, 11, 13, 15, 17)])), 
                    na.rm = TRUE)
    denominator = sum(as.numeric(as.character(ps_df[i, c(2, 4, 6, 8, 10, 12, 14, 16, 18)])), 
                      na.rm = TRUE)
    
    # Store value in output vector
    stats[i] = ifelse(numerator != 0, numerator / denominator * 100, 0)
  }
  
  return(stats)
}


rr.stats <- function( df ) {
  ######## DESCRIPTION ########
  # Compute raw score averages
  # for reading responses.
  
  ######## ARGS ###############
  # df - (Dataframe) Dataframe
  # corresponding to the given
  # class track (Math/Reading).
  
  ######## OUTPUT #############
  # stats - (Vector) Vector of
  # reading response raw scores
  # averages by student.
  
  # Initialize output vector
  stats = rep(0.0, nrow(df))
  
  # Get columns containing RR scores
  if ('RR10' %in% colnames(df)) {
    
    # Appropriate columns for reading track (Math/STS 50)
    rr_df = df[, c(12:23)]
    
  } else {
    
    # Appropriate columns for math track (Math 112)
    rr_df = df[, c(12:22)]
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


quiz.stats <- function(df) {
  ######## DESCRIPTION ########
  # Compute each student's raw 
  # quiz score averages.
  
  ######## ARGS ###############
  # df - (Dataframe) Gradebook.
  
  ######## OUTPUT #############
  # stats - (Vector) Vector of
  # raw quiz score averages,
  # with each row corresponding
  # to a particular student.
  
  # Initialize output vector
  stats = rep(0.0, nrow(df))
  
  # Get columns containing quiz scores
  df = df[, 24:30]
  
  # Populate stats
  for (i in 1:nrow(df)) {
    
    # Get current student's quiz scores
    temp = as.numeric(df[i, ])
    
    # Compute average of student's raw quiz scores (omit NA's)
    stats[i] = mean(temp, na.rm = TRUE)
  }
  
  return(stats)
}


# Create final output dataframe
# Include student name & given track
stats_df = gradebk[, c(1,2)]

# Populate quiz raw score averages column
stats_df$`Quiz Raw Averages` = quiz.stats(gradebk)

# Populate RR raw score averages column
stats_df$`RR Raw Averages` = NA
stats_df$`RR Raw Averages`[which(stats_df$Track == 50)] = rr.stats(read_track)
stats_df$`RR Raw Averages`[which(stats_df$Track == 112)] = rr.stats(math_track)

# Populate problem set % score averages column
stats_df$`PS % Averages` = pset.stats(gradebk)


###############################################
#           SAVE + EXPORT DATA                #
###############################################

# Save image and .csv file
save.image('class_stats.RData')
write.csv(stats_df, 'class_stats.csv')