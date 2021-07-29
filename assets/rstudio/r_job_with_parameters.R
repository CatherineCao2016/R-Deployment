library("pmml")

library(nnet)

library(projectLib)
Sys.setenv(PROJECT_ID=Sys.getenv('DSX_PROJECT_ID'))
Sys.setenv(PROJECT_ACCESS_TOKEN=Sys.getenv('DSX_TOKEN'))
#Sys.setenv(RUNTIME_ENV_APSX_URL='https://internal-nginx-svc:12443')
#url <- "https://internal-nginx-svc:12443"
Sys.setenv(RUNTIME_ENV_APSX_URL=url)
#cert <- "/etc/certificate/certificate.pem"
#httr::set_config(httr::config(cainfo = "/etc/certificate/certificate.pem"))
httr::set_config(httr::config(cainfo = cert))


project <- access_project()


ird <- data.frame(rbind(iris3[,,1], iris3[,,2], iris3[,,3]),
                  species = factor(c(rep("s",50), rep("c", 50), rep("v", 50))))


#load_model <- readRDS("/project_data/data_asset/rmodel.rds")
load_model <- readRDS(gzcon(rawConnection(project$get_file("rmodel.rds"))))



final_predictions <- predict(load_model, ird[1:5,])


csv_lines <- capture.output(write.csv(final_predictions, row.names=FALSE), type="output")
csv_raw <- charToRaw(paste0(csv_lines, collapse='\n'))

project$save_data("r_job_save_output_july29.csv", csv_raw, overwrite=TRUE)
