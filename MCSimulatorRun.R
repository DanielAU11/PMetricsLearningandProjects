#Monte Carlo simulator-----
setwd(wd)
setwd("Sim") #Simulation outputs go here

# The following will simulate 100 sets of parameters/concentrations using the
# first subject in the data file as a template.
# Limits are put on the simulated parameter ranges to be the same as in the model.
# The population parameter values from the NPAG run are used for this Monte Carlo Simulation.
simdata <- exRes2$sim(include = 1, limits = NA, nsim = 100)

simdata$plot() #plot them to view

# Simulate using multiple subjects as templates
simdata <- exRes2$sim(include = 1:4, limits = NA, nsim = 100)
# Plot the third simulation
simdata$plot(at = 3)

# Parse and combine multiple files and plot them.  
#Note that combining simulations from templates
#with different simulated observation times can lead to unpredictable plots
simdata2 <- exRes2$sim(include = 1:4, limits = NA, nsim = 100, combine = TRUE)
simdata2$plot()

#Simulating with Covariates-----
# in this case I use the covariate-parameter correlations from run 2, which
# are found in the cov.2 object; I re-define the mean weight to be 50 with
# SD of 20, and limits of 10 to 70 kg.  We fix africa, gender and height covariates,
# but allow age (the last covariate) to be simulated, using the mean, sd, and
# limits in the original population, since we didn't specify them.
# See ?SIMrun for more help on this and the Pmetrics manual.

covariate <- list(
  cov = exRes2$cov,
  mean = list(wt = 50),
  sd = list(wt = 20),
  limits = list(wt = c(10, 70)),
  fix = c("africa", "gender", "height")
)

# now simulate with this covariate list object
simdata3 <- exRes2$sim(include = 1:4, limits = NA, nsim = 100, covariate = covariate)

#Plot with covariates simulated
simdata3$plot()

#Note: the working directory and find the "c_simdata.csv" and "c_simmodel.txt" files
# which were made when I simulated with covariates.  Compare to original
# "simdata.csv" and "simmoddel.txt" files to note that simulated covariates become
# Primary block variables, and are removed from the template data file.