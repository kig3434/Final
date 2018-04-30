library(xgboost)
library(tidyverse)
iris<- iris




y1 <- iris$Species
var.levels <- levels(y1)
y = as.integer(y1) - 1

noOutcome <-iris[,-5] 
x = noOutcome[,c('Sepal.Length', 'Sepal.Width', 'Petal.Length', 'Petal.Width')]
var.names <- names(x)
x = as.matrix(x)

params <- list(
  "objective" = "multi:softprob"  #does a 1 vs all sort of thing
  , "eval_metric" = "mlogloss"
  , "num_class" = length(table(y))
  , "eta" = .25
  , "max_depth" = 3
)

cv.nround = 500

bst.cv <- xgb.cv(param = params, data = x, label = y
                 ,nfold = 5, nrounds = cv.nround
                 , missing = NA, prediction = TRUE)


nrounds = which.min(bst.cv$evaluation_log$test_mlogloss_mean)
bst.cv$evaluation_log[nrounds,]

irisClass <- xgboost(param = params, data = x, label = y
                   , nrounds = nrounds
                   , missing = NA)

xgb.importance(var.names, model = irisClass)

xgb.save(irisClass, "Iris model")


irisClassinfo <- list(
  var.names = var.names
  ,var.levels = var.levels
)

save(irisClassinfo, file = "irisClassinfo.rda")


generatepreds <- function(Sepal.Length = 5.80, Sepal.Width = 3.00, Petal.Length = 3.75, Petal.Width = 1.12) {
  
  testDF <- 
    as.matrix(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width)
  
  
  preds <- predict(irisClass, testDF)
  
  
  data.frame(Species = var.levels
             ,preds) %>%
    arrange(desc(preds))
  
}