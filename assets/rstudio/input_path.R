inputdir <- Sys.getenv('BATCH_INPUT_DIR')
outputdir <- Sys.getenv('BATCH_OUTPUT_DIR')

inputfile <- file.path(inputdir, "testR.csv")
outputfile <- file.path(outputdir, "output.csv")
userlogfile <- file.path(outputdir, "user.log")

data <- read.csv(inputfile)
print(data)
retval <- subset(data, salary > 600 & dept == "IT")

# Write filtered data into a new file.
write.csv(retval,outputfile, row.names = FALSE)
newdata <- read.csv(outputfile)

writeLines(c("Finished Execution!"), userlogfile)
print(newdata)