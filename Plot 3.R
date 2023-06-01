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

# Plot 3
with(epc, {
        plot(DateTime, Sub_metering_1, type="l",
             ylab="Energy sub metering", xlab="")
        lines(DateTime, Sub_metering_2,col='Red')
        lines(DateTime, Sub_metering_3,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lwd=c(1,1,1), 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.copy(png, "plot3.png", width = 480, height = 480)
dev.off()

