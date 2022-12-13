library(rstan)
library(tidyverse)
library(bayesplot)
library(loo)
setwd("../desktop/lipasto/StatisticalAndProbabilisticProgramming/demo5/")


## 1. Information criteria (1p) ******************************************** ####
# Explain in your own words:

# a) the purpose of information criteria
#        Criteria for selecting a model. Tells the quality of a model for a given a set of data.
#        Compares given models between each other to determine the best one among those.
#        Uses log-probability score for this determination.
# estimate prediction error for future data. relative quality
# -2(lppd - bias)
#       
# b) log pointwise predictive distribution (lppd)
#        Log-probability score for all points of data. Summing all the points' scores gives the total 
#        Log-probability score of the model. This is the bayesian version. Calculates distance from target
# over confident. Mesures predictive accuracy   
# -2(lppd - bias) <- this is why bias is added. 
#
# c) what is the fundamental difference between DIC/AIC and WAIC?
#        Aikake information criteria: best known, simple (AIC = D_train + 2p = -2lppd +2p)
#              more dimensions(parameters) lead to bigger tendency to over fit. (posterior mode)
#        Deviance information criteria (posterior mean)
#postirior point estimates
#
#        These two above are reliable only when priors are flat or rendered 
#        useless by likelihood. posterior distribution is a multivariate guassian
#        And sample size is much larges than parameter size.
#
#        Widely Applicable information criteria (whole posterior)
#        This criteria allows informative priors and makes no aasumptions on the posterior
#        Generalized version of AIC
#uses entire posterior
#        
#        
## Data ************************************************** ####

data1 <- read.csv("C:/Users/peppi/desktop/lipasto/StatisticalAndProbabilisticProgramming/demo5/data1.txt")
df1 <- data.frame(data1)
hist(df1$X)

data2 <- read.table("C:/Users/peppi/desktop/lipasto/StatisticalAndProbabilisticProgramming/demo5/data2.txt", sep="", header=TRUE)
df2 <- data.frame(data2)
print(df2)
ggplot(df2) +
  geom_point(aes(x, y))


## 2. Posterior predictive check (2p) ******************************************** ####
## Build a Stan model that estimates the mean and standard deviation of a normal distribution.
## Hint: you can generate the PPD in R/Python or in the generated quantities block in Stan

normal_model <- stan_model("normal.stan")

## Fit the model to the data in data1.txt and do a (visual) posterior predictive check. 

x = df1$X
# make data list for stan
data_list1 <- list(
  N = length(x),
  x = x
)
#fit data to stan model
fit1 <- sampling(normal_model, data_list1)
#get summary (without x_reps)
pos_mean <- summary(fit1)[["summary"]][c("mu", "sigma"), c("mean", "2.5%", "97.5%")] %>%
  data.frame
print(pos_mean)
# get the draws from fitted model
x_rep_stan <- as.matrix(fit1, pars = "x_rep")
# Comparison plots 
ppc_hist(x, x_rep_stan[1:20, ], binwidth = 0.01)
ppc_dens_overlay(x, x_rep_stan[1:50, ])

## What are your conclusions about the model suitability on this data based on the PPD?
#         Model is not suitable for this data set. It is under fitted. 

## What steps would you take next?
#         data to log scale
# data to log scale (this is a bit easier)
# or change likelyhood


## 3. WAIC-based model selection (2p) ******************************************** ####
## Use the provided Stan models and implement the WAIC in R/Python.
## Hint: See p.220 for definition of WAIC and Overthinking box on p.210

# make data list for stan
x = df2$x
y = df2$y
data_list2 <- list(
  N = length(x),
  x = x,
  y = y
)
## 0 (intercept only), 
intercept_model <- stan_model("intercept.stan")
intercept_fit <- sampling(intercept_model, data_list2)
print(intercept_fit)
intercept_llmatrix = extract_log_lik(intercept_fit, parameter_name = "log_lik", merge_chains = TRUE)
intercept_waic_mat <- waic(intercept_llmatrix)
print(intercept_waic_mat)
## 1 (linear regression), 
linear_model <- stan_model("linear.stan")
linear_fit <- sampling(linear_model, data_list2)
print(linear_fit)
linear_llmatrix = extract_log_lik(linear_fit, parameter_name = "log_lik", merge_chains = TRUE)
linear_waic_mat <- waic(linear_llmatrix)
print(linear_waic_mat)
## 2 (quadratic), 
quadratic_model <- stan_model("quadratic.stan")
quadratic_fit <- sampling(quadratic_model, data_list2)
print(quadratic_fit)
quadratic_llmatrix = extract_log_lik(quadratic_fit, parameter_name = "log_lik", merge_chains = TRUE)
quadratic_waic_mat <- waic(quadratic_llmatrix)
print(quadratic_waic_mat)
## 3 (cubic) degrees. 
cubic_model <- stan_model("cubic.stan")
cubic_fit <- sampling(cubic_model, data_list2)
print(cubic_fit)
cubic_llmatrix = extract_log_lik(cubic_fit, parameter_name = "log_lik", merge_chains = TRUE)
cubic_waic_mat <- waic(cubic_llmatrix)
print(cubic_waic_mat)

## Which of these four models best describes the data in data2.txt in terms of the WAIC?

# 0
#Estimate  SE
#elpd_waic    -48.9 1.9
#p_waic         0.8 0.2
#waic          97.9 3.8

#1
#Estimate  SE
#elpd_waic    -42.0 3.4
#p_waic         2.7 0.8
#waic          84.0 6.8

#2
#Estimate  SE
#elpd_waic    -41.0 2.6
#p_waic         3.1 0.7
#waic          82.0 5.2

#3
#Estimate  SE
#elpd_waic    -42.2 2.6
#p_waic         3.6 0.8
#waic          84.4 5.2

