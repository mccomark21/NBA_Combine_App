# Libraries ----

library(shinydashboard)
library(shiny)
library(shinycssloaders)
library(shinyWidgets)
library(DT)
library(tidyverse)
library(nbastatR)

# Collect Data ----

# Generate today's date for "years" parameter
CD <- as.numeric(format(as.Date(Sys.Date(), format="%Y-%m-%d"),"%Y"))+1 # current date

# Execute function to collect draft combine data to date
Combine_df <- draft_combines(years = 2000:CD) # Select range of draft years desired 

# Clean Data ----

# Missing data as a percentage per column
missing_df <- data.frame(colMeans(is.na(Combine_df)))
colnames(missing_df) <- "percent_missing"

# Exclude any columns that are missing more than 20% of values
missing_df <- cbind(ColNames = rownames(missing_df), missing_df)
rownames(missing_df) <- 1:nrow(missing_df)

missing_df2 <- missing_df %>% 
  select(ColNames,percent_missing) %>% 
  filter(percent_missing < 0.2)

keeps <- as.character(unique(missing_df2$ColNames))

Combine_df <- Combine_df[keeps]
# Impute Data ----

Combine_df$na_count <- apply(Combine_df, 1, function(x) sum(is.na(x)))

Combine_df <- Combine_df %>%
  filter(na_count<2)

# Impute missing data using knn
Combine_df <- kNN(Combine_df, k = 5)

# Exclude impute label columns
Combine_df <- select(Combine_df, -contains("_imp"))
# Create New Column ----
Combine_df$Wingspan_Height_Diff <- Combine_df$wingspanInches - Combine_df$heightWOShoesInches

keeps <- c("yearCombine","idPlayer","nameFirst","nameLast","namePlayer","slugPosition",
           "Wingspan_Height_Diff","pctBodyFat","verticalLeapMaxInches","timeLaneAgility")

Combine_df <- Combine_df[keeps]