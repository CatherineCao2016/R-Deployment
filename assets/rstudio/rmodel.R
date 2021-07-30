# https://www.ibm.com/support/pages/how-do-you-deploy-r-pmml-model-watson-machine-learning-service-watson-studio
# install.packages("pmml")

library("pmml")

library(nnet)

ird <- data.frame(rbind(iris3[,,1], iris3[,,2], iris3[,,3]),
                  species = factor(c(rep("s",50), rep("c", 50), rep("v", 50))))

samp <- c(sample(1:50,25), sample(51:100,25), sample(101:150,25))

ir.nn2 <- nnet(species ~ ., data = ird, subset = samp, size = 2, rang = 0.1,
               decay = 5e-4, maxit = 200)

saveRDS(ir.nn2, "assets/rstudio/rmodel.rds")

load_model <- readRDS("assets/rstudio/rmodel.rds")

final_predictions <- predict(load_model, ird[1:5,])

pmmlmodel <- pmml(ir.nn2)

saveXML(pmmlmodel,file = "assets/rstudio/IrisNet.xml")

# use the following for online test

# {"input_data":[{"fields":["Sepal.L.","Sepal.W.","Petal.L.","Petal.W."],"values":[[5.1,3.5,1.4,0.2]]}]}
