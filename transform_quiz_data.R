# Preparing/Transforming Quiz Scores


###############################################
#           LOAD PACKAGES + DATA              #
###############################################

# Load required packages
library(readr)

# Load data
# Beforehand, ensure saved as .csv formats
setwd(paste0(getwd(), '/Quizzes'))
quiz_files = list.files(pattern = '.csv')

for (i in 1:length(quiz_files)) {
  file = quiz_files[i]
  
  df = read_csv(file)
  assign(paste0('quiz', as.character(i)), df)
}

rm(df, i, file, quiz_files)


###############################################
#           CLEANING/REFORMATTING             #
###############################################

# Eliminate unnecessary information
for (i in 1:7) {
  df = get(paste0('quiz', as.character(i)))
  df = df[-c(1:5, nrow(df)), c(1, 3, 4)]
  
  assign(paste0('quiz', as.character(i)), df)
}

# Number of questions for each quiz
denoms = c(2, 4, 6, 1, 2, 2, 2)

# Linearly rescale scores
for (i in 1:7) {
  df = get(paste0('quiz', as.character(i)))
  
  # Remove unnecessary column & row
  df = df[-1, -2]
  
  df$X4 = as.numeric(df$X4)
  df$X4 = 1 + df$X4 * 3 / denoms[i]
  
  assign(paste0('quiz', as.character(i)), df)
}

rm(df, i)


###############################################
#           SAVE + EXPORT DATA                #
###############################################

# Save image
save.image('quiz_grades.RData')

# Save .csv files
for (i in 1:7) {
  df = get(paste0('quiz', as.character(i)))
  
  write.csv(df, paste0('quiz', as.character(i), '.csv'))
}