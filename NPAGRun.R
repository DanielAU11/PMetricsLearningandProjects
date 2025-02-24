#NPAG run---------------

library(Pmetrics)

wd <- "C:/LAPK/PMetrics/Examples"
# change to the working directory to the Examples folder
setwd(wd)
setwd("src") #relative
list.files() #see files in directory
exData <- PM_data$new(data = "ex.csv") #saved data as an object

exData$data # contains your original datafile
exData$standard_data # contains the standardized and validated data,
exData$summary() # prints the summary of the data to the terminal

summary(exData) #another way to view data summary
names(exData) #view contents of exData object

# Things you can do with Objects
exData # view the original data in the viewer
exData$print(standard = TRUE) # view the standardized data in the viewer
exData$print(viewer = FALSE) # view original data in console
exData$plot() #plot the raw data

#Model Object-----------
#you can specify a model .txt file from your wd or create it within R
#The algebraic token in {} within the equation block tells Pmetrics that this can
#be solved algebraically without using the differential equations.

mod1 <- PM_model$new(list(
  pri = list(
    Ka = ab(0.1, 0.9),
    Ke = ab(0.001, 0.1),
    V = ab(30, 120),
    lag = ab(0, 4)
  ),
  cov = list(
    covariate("WT"),
    covariate("AFRICA"),
    covariate("AGE"),
    covariate("GENDER"),
    covariate("HEIGHT")
  ),
  eqn = c(
    "{algebraic: P[Ka,Ke,V], B[1], R[2], O[2]}",
    "XP(1) = -Ka*X(1)",
    "XP(2) = Ka*X(1) - Ke*X(2)"
  ),
  lag = list("Tlag(1) = lag"),
  out = list(
    Y1 = list(
      value = "X(2)/V",
      err = list(
        model = proportional(5),
        assay = errorPoly(c(0.02, 0.05, -0.0002, 0))
      )
    )
  )
))

# PM_model$new() also accepts the path to a model file
# create the same model using the .txt model file
mod1b <- PM_model$new("model.txt")
mod1b

# look at it
mod1

#plot it
mod1$plot()

# to copy a model use the $clone() method.
mod1b <- mod1$clone()

# PM_model provides a method to update the different elements of a model
#In this case the Ka range is being updated
mod1$update(list(
  pri = list(
    Ka = ab(0.001, 5)
  )
))

#Fit Model to Data----
exFit <- PM_fit$new(model = mod1, data = exData)
# Let's analyze this object
exFit

# there are some methods we can execute over this object, like:
exFit$check()

#Runs Folder----
#To organize our runs in the wd. We can create a "Runs" folder 
# After the run is complete you need get the extracted information back into R.
# They will be sequentially numbered as /1, /2, /3,... in your working directory.
setwd(wd)
dir.create("Runs")
setwd("Runs")

exFit$run(intern = TRUE) # execute the run internally in the console

# Run Result Object----
#Turning run results into objects. specify the run file with just the number.
exRes <- PM_load(1)

# Plot the raw data.
exRes$data$plot()
exRes$data$plot(overlay = FALSE, xlim = c(119, 145))

#To view a summary of the original data file; ?summary.PMmatrix for help
exRes$data$summary()

#Obs v. Pred-----
# Plot some observed vs. predicted data.
exRes$op$plot()
exRes$op$plot(pred.type = "pop")
exRes$op$plot(line = list(lm = list(ci = 0, color = "red"), loess = FALSE))

# The OP plot can be disaggregated into a Tidy compatible format using the $data attribute (see https://www.tidyverse.org/)
library(tidyverse)
exRes$op$data %>% plot()
exRes$op$data %>%
  filter(pred > 5) %>%
  filter(pred < 10) %>%
  plot()

# the original op object data can be accessed via
exRes$op$data

# see a header with the first 10 rows of the op object
head(exRes$op$data, 10)

# get a summary with bias and imprecision of the population predictions;
# ?summary.PMop for help
exRes$op$summary(pred.type = "pop")

# look at the summary for the posterior predictions (default pred.type) based
# on means of parameter values
exRes$op$summary(icen = "mean")


# Plot final population joint density information.  Type ?plot.PMfinal in the R console for help.
exRes$final$plot()

# add a kernel density curve
exRes$final$plot(density = TRUE)

# A bivariate plot. Plotting formulae in R are of the form 'y~x'
exRes$final$plot(Ke ~ V,
                 marker = list(color = "red", symbol = "diamond"),
                 line = list(color = "purple", dash = "dash", width = 2)
)

# The original final object can be accessed using
exRes$final$data
names(exRes$final$data)

# see the population points
exRes$final$popPoints

# or:
exRes$final$data$popPoints

# see the population mean parameter values
exRes$final$popMean

# see a summary with confidence intervals around the medians
# and the Median Absolute Weighted Difference (MAWD);
# ?summary.PMfinal for help
exRes$final$summary()

# Plot cycle information
# Type ?plot.PM_cycle in the R console for help.
exRes$cycle$plot()

# names of the cycle object; ?makeCycle for help
names(exRes$cycle$data)

# gamma/lamda value on last 6 cycles using tail
tail(exRes$cycle$data$gamlam)

# Plot covariate information.  Type ?plot.PMcov in the R console for help.
# Recall that plotting formulae in R are of the form 'y~x'
exRes$cov$plot(V ~ wt)
exRes$cov$data %>% plot(V ~ wt)
exRes$cov$data %>%
  filter(age > 25) %>%
  plot(V ~ wt)

# Plot
exRes$cov$plot(Ke ~ age, line = list(loess = FALSE, lm = TRUE),
               marker = list(symbol = 3))

# Another plot with mean Bayesian posterior parameter and covariate values...
# Remember the 'icen' argument?
exRes$cov$plot(V ~ wt, icen = "mean")

# When time is the x variable, the y variable is aggregated by subject.
# In R plot formulae, calculations on the fly can be included using the I() function
exRes$cov$plot(I(V * wt) ~ time)

# The previous cov object can be seen via:
exRes$cov

# but to access individual elements, use:
exRes$cov$data[, 1:3] # for example
names(exRes$cov)

# summarize with mean covariates; ?summary.PMcov for help
exRes$cov$summary(icen = "mean")


# Look at all possible covariate-parameter relationships by multiple linear regression with forward
# and backward elimination - type ?PMstep in the R console for help.
exRes$step()
# or on the cov object directly
exRes$cov$step()
# icen works here too....
exRes$step(icen = "median")
# forward elimination only
exRes$step(direction = "forward")

#NPAG Run with Covariates-----
# First clone mod1
mod2 <- mod1$clone()
 
# Then update it in R. In this case we are creating a secondary var for the relationship between
#volume of distribution (V) and the weight (wt). We know V is dependent on weight
mod2$update(list(
  pri = list(
    V0 = ab(30, 120),
    V = NULL
  ),
  sec = "V = V0*(WT/55)"
))
#Alternatively, you can also load a .txt model file and making it an object


exFit2 <- PM_fit$new(data = exData, model = mod2)
# You can build the PM_fit object with file sources directly, but this means
# that you have to copy files to the working directory, or specify paths relative
# to the working directory

#check fited model to data and run it
exFit2$check()
exFit2$run(intern = TRUE)

#find the run and turn it into an object
list.files() 
exRes2 <- PM_load(2)