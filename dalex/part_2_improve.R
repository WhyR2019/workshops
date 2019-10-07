
# prepare environment -------------------------------------------------------------------------

# let's start from scratch (it works only wit RStudio, if you do not use it, just restart the session)
.rs.restartR()

# set seed from R 3.5 
if (as.numeric(R.Version()$minor) > 6) RNGkind(sample.kind = "Rounding")

packages <- setdiff(c("auditor", "randomForest", "e1071", "ggplot2"), rownames(installed.packages()))
if (length(packages) > 0) install.packages(packages)

source("https://install-github.me/ModelOriented/DALEX")


# data set, training and testing data ---------------------------------------------------------

library(DALEX)
set.seed(10)
data(dragons)
head(dragons)

X <- subset(dragons, select = -life_length)
y <- dragons$life_length

nd <- nrow(X)
obs <- sample(1:nd, 0.85 * nd)
X_train <- X[obs, ]
X_test  <- X[-obs, ]
y_train <- y[obs]
y_test  <- y[-obs]



# models --------------------------------------------------------------------------------------

# fit linear model to predict length of life of dragons
model_lm <- lm(y_train ~ ., data = X_train)

par(mfrow = c(2, 3))
plot(model_lm, ask = FALSE, which = 1:6)
par(mfrow = c(1, 1))


# fit random forest to predict length of life of dragons
library(randomForest)
set.seed(1)
model_rf <- randomForest(y_train ~ ., data = X_train, ntree = 300, mtry = 5, nodesize = 7)


# fit svm to predict length of life of dragons
library(e1071)
model_svm <- svm(y_train ~ ., data = X_train)



# DALEX explainers ----------------------------------------------------------------------------

# create explainers with explain() function from the DALEX package
exp_lm  <- explain(model_lm, data = X_test, y = y_test)
exp_rf  <- explain(model_rf, data = X_test, y = y_test)
exp_svm <- explain(model_svm, data = X_test, y = y_test)


# one can also explain many models with functional way 
# explain_models <- lapply(list(model_lm, model_rf, model_svm), function(x) {
#   explain(x, data = X_test, y = y_test)
# })


# auditing ------------------------------------------------------------------------------------

library(auditor)

# computing model performance measures and plot comapring measures of explainers
scores <- c("mae", "rmse", "rroc", "rec")
mp_lm  <- model_performance(exp_lm, score = scores)
mp_rf  <- model_performance(exp_rf, score = scores)
mp_svm <- model_performance(exp_svm, score = scores)
plot_radar(mp_lm, mp_rf, mp_svm)

# # functional way of creating specific model measures:
# models_scores <- lapply(explain_models, function(x) model_performance(x, score = scores))


# residuals of models to show on boxplot 
mr_lm  <- model_residual(exp_lm)
mr_rf  <- model_residual(exp_rf)
mr_svm <- model_residual(exp_svm)
plot_residual_boxplot(mr_lm, mr_rf, mr_svm)


# because of poor result of `svm` model lets focus on linear model and random forest only
# first, check how well linear regression and RF predicted
plot_prediction(mr_lm, mr_rf, abline = TRUE)
plotD3_prediction(mr_lm, mr_rf, abline = TRUE, scale_plot = TRUE)


# lets check what is a distribution of residuals for both models
plot_residual(mr_lm, mr_rf, smooth = TRUE)

# same for `scars` variable which is not the targe one
plot_residual(mr_lm, mr_rf, variable = "scars", smooth = TRUE)
plotD3_residual(mr_lm, mr_rf, variable = "scars", smooth = TRUE, scale_plot = TRUE)



# Task 1 --------------------------------------------------------------------------------------

# 1. Explore other variables of the data set for more potential problems. 
# 2. Try to use this knowledge to improve `lm` model (and call it `mp_lm_impr`).
# 3. Show your solution on a radar plot (together with previously created models).

plot_residual(mr_lm, mr_rf, variable = "year_of_birth", smooth = TRUE)

model_lm_impr <- lm(y_train ~ . + I(year_of_birth > 500 & year_of_birth < 1500), data = X_train)

exp_lm_impr <- explain(model_lm_impr, data = X_test, y = y_test, label = "lm_impr")
mp_lm_impr <- model_performance(exp_lm_impr, score = scores)
plot_radar(mp_lm, mp_rf, mp_svm, mp_lm_impr)




# Validation data -----------------------------------------------------------------------------

data(dragons_test)
X_test_valid <- subset(dragons_test, select = -life_length)
y_test_valid <- dragons_test$life_length

exp_lm_valid <- explain(model_lm_impr, data = X_test_valid, y = y_test_valid, label = "lm_validation")
exp_rf_valid <- explain(model_rf, data = X_test_valid, y = y_test_valid, label = "ranomForest_validation")

# performance of models on new data
mp_lm_valid <- model_performance(exp_lm_valid, score = scores)
mp_rf_valid <- model_performance(exp_rf_valid, score = scores)

plot_radar(mp_lm_valid, mp_rf_valid)


# Lets compare models (previous and validation ones):
models <- list(randomForest = exp_rf, 
               randomForest_validation = exp_rf_valid, 
               lm_improved = exp_lm_impr, 
               lm_validation = exp_lm_valid)

# Mean squared error for on test versus validationa data:
sapply(models, function(x) score_mse(x), USE.NAMES = TRUE)


# Again, lets have a look at residuals:
mr_rf_valid <- model_residual(exp_rf_valid)
mr_lm_valid <- model_residual(exp_lm_valid)

plotD3_prediction(mr_rf_valid, mr_lm_valid, scale_plot = TRUE)
# new group of observations, both models do not deal with it 


plot_residual_density(mr_rf_valid, mr_lm_valid)

# as objects are ggplot, we can work with them in gg way
library(ggplot2)
plot_residual_density(mr_rf_valid, mr_lm_valid) + 
  scale_y_sqrt() +
  theme_minimal() + 
  scale_fill_manual(name = "", 
                    values = c("red", "green"), 
                    labels = c("Random forest (validation)", "Linear regression (validation)")) +
  scale_colour_manual(name = "", values = c("red", "green"))



# Task 2 --------------------------------------------------------------------------------------

# 1. Explore residuals and look for strange patterns.

plot_residual(mr_rf_valid, mr_lm_valid, variable = "height")
plot_residual(mr_rf_valid, mr_lm_valid, variable = "weight")

# 2. What can we do to again improve linear model? 
# Before creating new models combine `dragons` and 
# `dragons_test` data sets and split it into trainig 
# and testing subsets.

dragons_all <- rbind(dragons, dragons_test)

X <- subset(dragons_all, select = -life_length)
y <- dragons_all$life_length

set.seed(14)
nd <- nrow(X)
obs <- sample(1:nd, 0.85 * nd)
X_train <- X[obs, ]
X_test <- X[-obs, ]
y_train <- y[obs]
y_test <- y[-obs]








# Solution:








# Solution:
# add squared height and indicator whether height is under 100
model_lm_all <- lm(y_train ~ . +
                     I(year_of_birth > 500 & year_of_birth < 1500) + 
                     I(height < 100), 
                   data = X_train)
exp_lm_all <- explain(model_lm_all, data = X_test, y = y_test)
mr_lm_all <- model_residual(exp_lm_all)

plot_prediction(mr_lm_all)
plot_prediction(mr_lm_valid)

# lets compare it with random forest
model_rf_all <- randomForest(y_train ~ ., data = X_train)
exp_rf_all <- explain(model_rf_all, data = X_test, y = y_test)
mr_rf_all <- model_residual(exp_rf_all)
plot_prediction(mr_lm_all, mr_rf_all)

mp_rf_all <- model_performance(exp_rf_all)
mp_lm_all <- model_performance(exp_lm_all)

plot_radar(mp_lm_all, mp_rf_all)

