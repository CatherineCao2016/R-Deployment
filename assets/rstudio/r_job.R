library("pmml")

library(nnet)

ird <- data.frame(rbind(iris3[,,1], iris3[,,2], iris3[,,3]),
                  species = factor(c(rep("s",50), rep("c", 50), rep("v", 50))))

load_model <- readRDS("assets/rstudio/rmodel.rds")

final_predictions <- predict(load_model, ird[1:5,])

write.csv(final_predictions, file = "r_output.csv")
