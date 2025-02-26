library(Pmetrics)

PMtree("PosaconazolePK")

#Null Hypothesis: the PK parameters of posaconazole delayed-release tablets (Cl, V, Ke) in patients
#with invasive fungal infections are not aberrant and fall w/in the expected ranges derived from
#the package insert/literature 
#(https://sandoz-ca.cms.sandoz.com/sites/default/files/Media%20Documents/pdf%2034567.pdf)

#Alt. Hypothesis: The pharmacokinetic parameters of Posaconazole in patients with 
#invasive fungal infections are aberrant and fall outside the expected ranges.

#Calculated Ke (expected) from package insert defined apparent Cl and V 
#Using Cl (7.5-11 L/hr) and Vd (~287 L). Cl as range so will use midpoint (9.25 L/hr)
expKe = 9.25/287

#Using half-life elimination (26-31hrs) using midpoint (28.5 hrs)
expKe2 = 0.693/28.5

#Data and Model----
setwd("C:/LAPK/PMetrics/PosaconazolePK/src")

PosaDat <- PM_data$new("Posaconazole.csv") #data object

#Model Creation
PosaMod <- PM_model$new("posamod.txt")

PosaMod #view model

PosaMod$plot() #plot/view model

#Fit Model and Data-----
PosaFit <- PM_fit$new(model = PosaMod, data = PosaDat)
PosaFit
PosaFit$check()

setwd("C:/LAPK/PMetrics/PosaconazolePK/Runs")
exFit$run(intern = TRUE)
