#4exdata-week1-aidosqanapia

# Dataset variables:
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
#dest <- "C:/hpc"
dest <- getwd()
dataFileName <- "household_power_consumption"
destDownlFile <- paste0(dest, "/", dataFileName, ".zip")
plotFile <- paste0(dest, "/", "plot2.png")

condi <- "^1/2/2007|^2/2/2007"


if (!dir.exists(dest)) {
  dir.create(dest)
}

#download dataset if it is not exists in dest:
if (!file.exists(paste0(dest, "/", dataFileName, ".txt"))){
  download.file(url, destDownlFile, mode = "wb")
  unzip(destDownlFile, exdir = dest)
}


#--------------
#Extract two days:

cn <- file(paste0(dest, "/", dataFileName, ".txt"), "r")
header <- readLines(cn, n = 1)
twoDays <- character()
nn <- 0

repeat {
  
  lines <- readLines(cn, n = 1000)
  if (length(lines) == 0) break
  matches <- grep(condi, lines, value = TRUE)
  twoDays <- c(twoDays, matches)
  
  #for safety:
  nn <- nn + 1
  if (nn > 3000) break
}
close(cn)


# Combine header and matching lines
fullData <- c(header, twoDays)

# Create data frame (df) via text connection
cn <- textConnection(fullData)
df <- read.table(cn, sep = ";", header = TRUE, na.strings = "?", stringsAsFactors = FALSE)
close(cn)

# create DateTime column:
df$DateTime <- strptime(paste(df$Date, df$Time), "%d/%m/%Y %H:%M:%S")


#---Plot-2:

plot(df$DateTime, df$Global_active_power, type = "l",
     lwd = 2,
     ylab = "Global Active Power (kilowatts)",
     xlab = "")



# Create Png file:
dev.copy(png, plotFile, 
         width = 480, height = 480, 
         units = "px", bg = "white")
dev.off()


