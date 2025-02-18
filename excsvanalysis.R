library(Pmetrics) #loaded Pmetrics package 
PMbuild() #executed to complete Pmetrics installation
getwd() #checked what the wd was set to
setwd("C:/LAPK/PMetrics") #changed it to this location

PMtree("exdata_analysis") #set a new directory under the current wd for this project
# the "exdata_analysis" directory has the following subdirectories that were 
#created by default from the PMtree():
#Rscript- contains a skeleton R script to begin Pmetrics runs in the new project.
#Runs- should contain all files required for a run (described next) and it will also contain the resulting numerically ordered run directories created after each Pmetrics NPAG or IT2B run.
#Sim- can contain any files related to simulations
#src- is a repository for original and manipulated source data files

setwd("C:/LAPK/PMetrics/exdata_analysis/src") #set wd to where data and models are

#Step 2: Inputing Data and Model 
#Downloaded data source file from github Pmetrics/tests/testthat/ex.csv
#This example dataset has PK data with 
#covariates (weight, gender, age, height) for 20 patients (n=20)

exdat <- PM_data$new("ex.csv") #created data object from ex.csv in the wd
mod1 <- PM_model$new("model.txt")
mod1$plot() #view the model. It is a 2-compartment model
fit1 <- PM_fit$new(exdat, mod1)

fit1$check() #checks consistency b/n model and dataset. No errors found in model file
fit1$save("fit1.rds") #saved fitted model and data in wd



#Step 3: Running Model to Fit the Data

fit1$run()#ran at 2352 2/9/25

#change the cycle number from default 100
fit1$run(cycles=100)

#change the engine from default NPAG
fit1$run(engine = "IT2B")

my_run <- PM_load(1) #loads a run under the object my_run

#the object for run 1 can be used to access different parts of the results 
exRes <- PM_load(1)
exRes$final$plot() #see ?plot.PM_final
exRes$op$plot(type="pop") #see ?plot.PM_op,
exRes$data$plot(overlay = F, 
                line = list(pred = list(exRes$post, color = "green"), join = F),
                marker = list(symbol = "diamond-open", color = "blue"), 
                log = T) # see ?plot.PM_data

