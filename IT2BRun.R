#IT2B run ---------
# IT2B is the parametric population parameter estimator. Population parameter value
# distributions are estimated as means and covariances.

#based on the run in object exFit. We simply change the engine to IT2B
exFit$run(engine = "IT2B", intern = TRUE)

list.files()
# Check your working directory to see the highest folder number,
# and replace the 6 below with that number if necessary. Incase you did more runs
run6 <- PM_load(6)


run6$final$plot()
# in the following plot, we standardize the x-scales to enable
# comparisons of the widths of the normal distributions of the
# parameter values
run4$final$plot(standardize = "all")
run4$final$plot(standardize = c("Ke", "Ka", "Tlag"))

#a bivariate plot of IT2B population parameter value distributions
#Helps visualize what set of Ke and V we would most likely see. 
run4$final$plot(Ke ~ V)