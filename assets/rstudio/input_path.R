inputdir <- Sys.getenv('BATCH_INPUT_DIR')
outputdir <- Sys.getenv('BATCH_OUTPUT_DIR')

inputfile <- file.path(inputdir, inputfile_name)
outputfile <- file.path(outputdir, "output.csv")
userlogfile <- file.path(outputdir, "user.log")

print(inputfile)
