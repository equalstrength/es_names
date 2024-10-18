###############################################################################
# EqualStrength Name Survey - Setup
###############################################################################

# This code runs on R version 4.4.1 (2024-06-14). 
# Run the line below to check which version is installed on your machine

R.version

# The codes use are few extra packages that are not installed with R base version
# Run the lines below to check if you have them installed and, if not, install them

# List of required packages
list_packages <- c("tidyverse", "haven", "gt", "sjPlot")

# Get list of packages that need to be installed
new_packages <- list_packages[!(list_packages %in% installed.packages()[,"Package"])]

# If list is not empty, install new packages
if(length(new_packages)) install.packages(new_packages)
