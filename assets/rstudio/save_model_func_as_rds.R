# R deployment with .rds

library(projectLib)
Sys.setenv(PROJECT_ID=Sys.getenv('DSX_PROJECT_ID'))
Sys.setenv(PROJECT_ACCESS_TOKEN=Sys.getenv('DSX_TOKEN'))
Sys.setenv(RUNTIME_ENV_APSX_URL='https://internal-nginx-svc:12443')
httr::set_config(httr::config(cainfo = "/etc/certificate/certificate.pem"))
project <- access_project()

library(RApiSerialize)

# Model

# https://www.ibm.com/support/pages/how-do-you-deploy-r-pmml-model-watson-machine-learning-service-watson-studio
# install.packages("pmml")

library("pmml")

library(nnet)

ird <- data.frame(rbind(iris3[,,1], iris3[,,2], iris3[,,3]),
                  species = factor(c(rep("s",50), rep("c", 50), rep("v", 50))))

samp <- c(sample(1:50,25), sample(51:100,25), sample(101:150,25))

ir.nn2 <- nnet(species ~ ., data = ird, subset = samp, size = 2, rang = 0.1,
               decay = 5e-4, maxit = 200)

model_raw <- serializeToRaw(ir.nn2) 

is.raw(model_raw)

# save it to project
project$save_data("model.rds", model_raw, overwrite=TRUE)


# Preprocessing data function to rds

preprocess_data <- function(dataframe,SPECIES_col ){
  require(plyr)
  dataframe[SPECIES_col] <- mapvalues(dataframe[SPECIES_col][[1]], 
                                      from=c("setosa","versicolor","virginica"), 
                                      to=c("s","c","v"))
  return(dataframe)
}

func_raw <- serializeToRaw(preprocess_data)

project$save_data("preprocess_data_func.rds", func_raw, overwrite=TRUE)


saveRDS(preprocess_data, "preprocess_data_func.rds")

