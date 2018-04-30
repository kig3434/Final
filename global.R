###if it doenst run first run inst.R

library(shiny)
library(xgboost)
library(DT)
library(tidyverse)
library(ggthemes)
library(gghighlight)
library(ggalt)
library(ggpubr)



irisClass <- xgb.load("Iris model")
load("irisClassinfo.rda")


generatepreds <- function(Sepal.Width, Petal.Length, Petal.Width, Sepal.Length) {
 
  testDF <- as.matrix(Petal.Length, Petal.Width, Sepal.Length, Sepal.Width) 
  ## I can change what input changes the pred values table by changing the order of values in testDF. Right now 'Petal.Length' changes the input, but if 'Sepal.Width' was first then the pred table would change when the 'Sepal.Width' slider input changed. Don't know how to fix it. 
  
  preds <- predict(irisClass, testDF) 
  
 data.frame(Species = var.levels, preds) %>%
    arrange(desc(preds))
  
}

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