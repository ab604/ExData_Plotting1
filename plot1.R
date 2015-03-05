## Exploratory Data Analysis Course Project 1:Script for producing plot 1 
## A. Bailey 3rd March 2015

# Load required pacakages and estimate dataset memory requirements  ------------
library(downloader)
library(lubridate)

# Estimate memorry usage: memory required = no. of column * no. of rows 
# * 8 bytes/numeric
# numeric = 2^20 bytes/MB 
# The dataset has 2,075,259 rows and 9 columns
mem.req <- (9 * 2075259 * 8) / 2^20
# Print the memory usage to console
cat(round(mem.req, digits = 2), "MB memory required")


# Get and process the data -----------------------------------------------------

# Download URL for Eletctric power consumption data
fileUrl <- paste("https://d396qusza40orc.cloudfront.net/",
                "exdata%2Fdata%2Fhousehold_power_consumption.zip",
                 sep="")

# Download data if not already downloaded
if(!file.exists("UCI_dataset.zip")){
        download(fileUrl,destfile="UCI_dataset.zip")
        dateDownloaded <- date()
        # Unzip data
        unzip(zipfile = "UCI_dataset.zip", files = NULL,
              unzip = "internal") 
        # Create logfile
        log_con <- file("UCI_data_download.log")
        cat ("Source URL =",fileUrl,"\n","destfile= UCI_dataset.zip",
             "\n", "destdir =", getwd(),"\n",dateDownloaded, 
             file = log_con)
        close(log_con)
}

# Read in the textfile and convert "?" to NAs
power.raw <- read.table("household_power_consumption.txt", 
                        stringsAsFactors=FALSE, 
                        header=TRUE, sep=";", na.strings = "?")

# Clean up the dates
power.raw$Date <- dmy(power.raw$Date)

# Subset the dates 2007-02-01 and 2007-02-02, removing NAs
power.sub <- na.omit(power.raw[power.raw$Date >= "2007-02-01" 
                               & power.raw$Date <= "2007-02-02",])

# Create Plot 1 ----------------------------------------------------------------

# Open png device and create 480 px by 480 px png file
png(file = "plot1.png", width = 480, height = 480, units = "px",
    bg="transparent")

# Define a 1 row 1 col figure
par(mfrow=c(1,1))

# Plot histogram of Global Active power
plot.1 <- hist(power.sub$Global_active_power,col="red",
               xlab="Global Active power (kilowatts)", 
               main="Global Active power")

# Close connection
dev.off()  