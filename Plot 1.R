library(data.table)
library(dplyr)

# Load the dataset
epc <- fread("household_power_consumption.txt", header = TRUE, sep = ";", 
             na.strings = "?", colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'))
epc$Date = as.Date(epc$Date, format = "%d/%m/%Y")

# Filter date between February 1, 2007 to February 2, 2007
epc <- epc[epc$Date == as.Date("2007-02-01") | 
                   epc$Date == as.Date("2007-02-02")]

# Remove incomplete cases
epc <- epc[complete.cases(epc), ]

# Join DateTime columns
DateTime <- as.POSIXct(paste(epc$Date, epc$Time))
epc <- epc[, -c("Date", "Time")]
epc <- cbind(DateTime, epc)

# Plot 1
hist(epc$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.copy(png, "plot1.png", width = 480, height = 480)
dev.off()
