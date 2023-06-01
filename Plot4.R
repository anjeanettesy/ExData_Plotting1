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

# Plot 4
par(mfcol = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(epc, {
  plot(Global_active_power ~ DateTime, type = "l", 
       ylab = "Global Active Power", xlab = "")

  plot(Sub_metering_1 ~ DateTime, type = "l", 
       ylab = "Energy sub metering", xlab = "")
  lines(Sub_metering_2 ~ DateTime, col = "red")
  lines(Sub_metering_3 ~ DateTime, col = "blue")
  legend("topright", col = c("black", "red", "blue"), lty = 1, lwd = 2, bty = "n",
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  
  plot(Voltage ~ DateTime, type = "l", 
       ylab = "Voltage", xlab = "")
  
  plot(Global_reactive_power ~ DateTime, type = "l", 
       ylab = "Global_reactive_power", xlab = "")
})


dev.copy(png, "plot4.png", width = 480, height = 480)
dev.off()