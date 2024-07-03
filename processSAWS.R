### Data format: 
# All datasets under each other; none next to each other
# 4 skippable cells between datasets (always?)
# Dataset name starts with "Daily..."
# Empty cell
# Column names starts with "Day  Jan  ..."
# Empty cell
# Data starts with "1" in Day column
# Data ends with "31" in Day column
#####

setwd("") ## CHOOSE YOUR WORKING DIRECTORY
data = read.csv("SAWS_data.csv",header = FALSE) ## CHOOSE YOUR SAWS DATA FILE
# View(data)

####
# store datasets from "Daily..." to "31"
#####

df_name_inds = grep("^Daily",data[,1])
df_cols_inds = grep("^Day",data[,1])
df_start_inds = grep("^1$",data[,1]) #grep("\\b1\\b",data[,1])
df_end_inds = grep("^31",data[,1])
  # gives the indices of the start and end of each dataframe
  # includes the cell giving the description/name of each df

# Example of what we would want to iterate:
df1 = data[df_start_inds[1]:df_end_inds[1],]
colnames(df1)  = c(data[df_cols_inds[1],])

## NOTE: df_name_inds picks up one more dataframe name than there really is. row 2631 in the excel file has a line
## that starts with "daily".
## I will put in a check to make sure that the distance between "Daily" and "Day" (the name of the dataframe and the
## name of the columns) is only 2 cells

#####
## CHECKS
#####
df_name_inds+2==df_cols_inds 
    # shows us where the first instance of df_name_inds is more than 2 cellx away from the start of the data
not_a_colname = which(df_name_inds+2!=df_cols_inds)[1]
df_name_inds = df_name_inds[-not_a_colname]
df_name_inds+2==df_cols_inds 
    # check again that all df names are followed by data
    ## NOTE: this will have to change if the format of the data ever changes in the future

#####
## ITERATE THROUGH ALL DATAFRAMES AND STORE THEM:
#####
### FROM CHAT
# List to store the resulting data frames
data_frames_list <- list()

# Loop over the indices
for (i in 1:length(df_start_inds)) {
  # Subset the data
  temp_df <- data[df_start_inds[i]:df_end_inds[i],]
  
  # Set the column names
  colnames(temp_df) <- as.character(unlist(data[df_cols_inds[i],]))
  
  # Store the data frame in the list
  data_frames_list[[paste0("df", i)]] <- temp_df
}
### END CHAT

names(data_frames_list) = data[df_name_inds,1]

### FROM CHAT:
# Function to replace special characters with underscores
sanitize_filename <- function(filename) {
  gsub("[^A-Za-z0-9]", "_", filename)
}


# Loop over the list and write each data frame to a CSV file
for (name in names(data_frames_list)) {
  # Sanitize the filename
  sanitized_name <- sanitize_filename(name)
  
  # Create the file path
  file_path <- paste0(sanitized_name, ".csv")
  
  # Write the data frame to a CSV file
  write.csv(data_frames_list[[name]], file_path, row.names = FALSE)
  
  # Print a message indicating the file has been written
  cat("Written", file_path, "\n")
}
### END CHAT


##### CHAT GPT PROMPTS USED:
# 1:
# Write a loop to perform the following code for as many dataframes as there are elements in df_start_inds:
#   df1 = data[df_start_inds[1]:df_end_inds[1],]
# colnames(df1)  = c(data[df_cols_inds[1],])
#
# 2:
# provide r code to write each element of the list to its own csv file 
# with the name of the list item as filename, with all special characters replaced with _


