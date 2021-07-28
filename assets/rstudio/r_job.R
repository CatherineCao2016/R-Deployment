library("pmml")

library(nnet)

ird <- data.frame(rbind(iris3[,,1], iris3[,,2], iris3[,,3]),
                  species = factor(c(rep("s",50), rep("c", 50), rep("v", 50))))


#load_model <- readRDS("/project_data/data_asset/rmodel.rds")
load_model <- readRDS(gzcon(rawConnection(project$get_file("rmodel.rds"))))

final_predictions <- predict(load_model, ird[1:5,])

library("projectLib")
project <- access_project()

csv_lines <- capture.output(write.csv(final_predictions, row.names=FALSE), type="output")
csv_raw <- charToRaw(paste0(csv_lines, collapse='\n'))

project$save_data("r_job_save_output.csv", csv_raw, overwrite=TRUE)
