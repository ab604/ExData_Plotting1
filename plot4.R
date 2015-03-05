## Exploratory Data Analysis Course Project 1:Script for producing plot 4 
## A. Bailey 3rd March 2015

# Load required pacakages and estimate dataset memory requirements  ------------
library(dplyr)
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

# Combine Time and Date and add DateTime column to dataset 
power.mut <- mutate(power.sub, 
                    DateTime = as.POSIXct(paste(power.sub$Date, power.sub$Time), 
                                          format="%Y-%m-%d %H:%M:%S"))

# Create Plot 4 ----------------------------------------------------------------

# Open png device and create 480 px by 480 px png file
png(file = "plot4.png", width = 480, height = 480, units = "px",
    bg="transparent")

# Create 2 row by 2 col figure
par(mfrow = c(2,2))

# Subplot 1 - xy line plot of DateTime vs. Global Active power, no x-axislabel
plot(power.mut$DateTime,power.sub$Global_active_power,type="l",
     xlab="",ylab="Global Active power")

# Subplot 2 - xy plot of DateTime vs. Voltage, x-axis label = "datetime"
plot(power.mut$DateTime,power.sub$Voltage,type="l",
     xlab="datetime",ylab="Voltage")

# Subplot 3 - xy line plots of Sub_metering 1, 2 and 3 onto the figure, 
# no x-axis label
with(power.mut,{
        plot(DateTime,Sub_metering_1,type="l",
             xlab="",ylab="Energy sub metering")
        lines(DateTime,Sub_metering_2,type="l",
              xlab="",ylab="Energy sub metering")
        lines(DateTime,Sub_metering_2,type="l", col="red")
        lines(DateTime,Sub_metering_3,type="l",col="blue")
        
        legend("topright",legend = c("Sub_metering_1", "Sub_metering_2", 
                                     "Sub_metering_3"), lty = 1, 
               col = c("black", "red", "blue"), bty="n")
})

# Subplot 4 - xy line plot of DateTime vs.Global reactive power,
# x-axis label = "datetime", y-axis label = "Global_reactive_power"
plot(power.mut$DateTime,power.sub$Global_reactive_power,type="l",
     xlab="datetime", ylab="Global_reactive_power")


dev.off()  
