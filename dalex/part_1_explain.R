
# set seed from R 3.5 
if (as.numeric(R.Version()$minor) > 6) RNGkind(sample.kind = "Rounding")

# prepare environment -------------------------------------------------------------------------
packages <- setdiff(c("DALEX", "auditor", "ingredients", "randomForest", "e1071", "iBreakDown"), rownames(installed.packages()))
if (length(packages) > 0) install.packages(packages)

source("https://install-github.me/ModelOriented/DALEX")



# data set, training and testing data ---------------------------------------------------------

wine <- read.csv("https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv", sep = ";")

head(wine)
table(wine$quality)
wine$quality <- ifelse(wine$quality < 7, 0, 1)
table(wine$quality)

X <- subset(wine, select = -quality)
y <- wine$quality

set.seed(1088)
nd <- nrow(wine)
obs <- sample(1:nd, 0.7 * nd)

X_train <- X[obs, ]
X_test <- X[-obs, ]
y_train <- y[obs]
y_test <- y[-obs]



# models --------------------------------------------------------------------------------------

# random forest
library(randomForest)
set.seed(123)
wine_rf <- randomForest(factor(y_train) ~ ., data = X_train, ntree = 100)

# logistic regression
wine_glm <- glm(y_train ~ ., data = X_train, family = "binomial")



# DALEX explainers ----------------------------------------------------------------------------
# use explain() function from the DALEX package to create "explainer"; the function creates a wrapper 
# around a predictive model; wrapped models may then be explored and compared with a collection of 
# local and global explainers

library(DALEX)
exp_rf <- explain(wine_rf, data = X_test, y = y_test)


# Task 1 --------------------------------------------------------------------------------------

# 1. Train third model of your choice (eg. svm, classification tree, etc.) 

library(rpart)
wine_rpart <- rpart(y_train~., X_train)


# 2. Create DALEX's explainers for glm (and call it `exp_glm`) model and the one that you have created
#    You can find instructions how to create explainers for other models (like mlr, caret etc.) in DALEX repository:
#    https://github.com/ModelOriented/DALEX#dalex-show-cases
exp_glm <- explain(wine_glm, data = X_test, y = y_test)

exp_rpart <- explain(wine_rpart, data=X_test, y = y_test)


# auditing ------------------------------------------------------------------------------------

# from now on, we use functions from auditor package
library(auditor)

# one of the advantages of using `auditor` is set of implemented scores which you can easily apply onto your model; e.g.: 
score_auc(exp_rf)
score_auc(exp_glm) # this one will work if you have created `exp_glm` by yourself
score_auc(exp_rpart)

# one can also compare several models across several scores:
scores <- c("one_minus_auc", "one_minus_precision", "one_minus_recall", "one_minus_f1", "one_minus_acc")
mp_rf  <- model_performance(exp_rf, score = scores)
mp_glm <- model_performance(exp_glm, score = scores)
mp_rpart <- model_performance(exp_rpart, score = scores)
plot_radar(mp_rf, mp_glm, mp_rpart)


# Now let's evaluate classifiers 
me_rf  <- model_evaluation(exp_rf)
me_glm <- model_evaluation(exp_glm)
me_rpart <- model_evaluation(exp_rpart)

# ROC
plot_roc(me_rf, me_glm, me_rpart)
plotD3_roc(me_rf, me_glm, me_rpart)


# LIFT
plot_lift(me_rf, me_glm, me_rpart)
plotD3_lift(me_glm, me_rf, me_rpart, scale_plot = TRUE)




# Global explanations -------------------------------------------------------------------------
library(ingredients)

# Feature importance
set.seed(1)
fi_rf <- feature_importance(exp_rf, loss_function = loss_one_minus_auc, B = 20)
plot(fi_rf, max_vars = 5)
plotD3(fi_rf)

set.seed(1)
fi_glm <- feature_importance(exp_glm, loss_function = loss_one_minus_auc, B = 20)
plot(fi_glm, max_vars = 5)
plotD3(fi_glm, max_vars = 5)

plot(fi_glm)

# partial dependency plots
var <- "pH" 
pd_rf <- partial_dependency(exp_rf, grid_points = 100, variables = var)
pd_glm <- partial_dependency(exp_glm, grid_points = 100, variables = var)
plot(pd_rf, pd_glm)



# Local explanations --------------------------------------------------------------------------

# take choosen observation:
observation <- wine[3,]

# ceteris paribus
cp_rf <- ceteris_paribus(exp_rf, new_observation = observation)
plot(cp_rf) +
  show_observations(cp_rf)



# Task 2 --------------------------------------------------------------------------------------

# Check how other models behave for the choosen observation (create local explanations plots)


# solution
cp_glm <- ceteris_paribus(exp_glm, new_observation = observation)
plot(cp_glm) +
  show_observations(cp_glm)




# Local stability of model with ceteris paribus -----------------------------------------------

observation <- wine[280,]

# different predictions of model
predict(wine_rf, newdata = observation)
predict(wine_glm, newdata = observation, type = "response")

# Check which model is more stable around the observation
wine_neighbors <- select_neighbours(data = wine, observation = observation, n = 10)
cp_rf_2 <- ceteris_paribus(exp_rf, new_observation = wine_neighbors)
plot(cp_rf_2)
cp_glm_2 <- ceteris_paribus(exp_glm, new_observation = wine_neighbors)
plot(cp_glm_2)


# break down ----------------------------------------------------------------------------------
# variable contributions to the prediction
library(iBreakDown)

la_rf <- local_attributions(exp_rf, new_observation = observation)
plot(la_rf)
plotD3(la_rf, time = 1000)




# Task 3 --------------------------------------------------------------------------------------

# Check how other model behave for the choosen and for few other observations

# solution
la_glm <- local_attributions(exp_glm, new_observation = observation)
plot(la_glm)
