# Results of Probability of Target Attainment

### What is Probability of Target Attainment (PTA)?
This feature allows us to quantify how likely a given dosing regimen is to achieve a predefined pharmacokinetic/pharmacodynamic target. For example, an AUC/MIC ratio used to determine the antibiotic AUC to the time above the minimum inhibitory concentration (MIC) needed to inhibit microorganisms. %T > MIC and Cₘᵢₙ/MIC are other measures. 

The pharmacodynamic index (PDI) is generated from the simulation profiles (concentration vs. time). Tells us the proportion that are above the target or at a target. 

Allows us to answer this question: “If I give this dose to patients whose PK parameters vary as they do in the population, what fraction of them will hit my efficacy target?”

### Why it is Used?
- Inter‐patient variability: Patients differ in clearance (Cl), volume (V), absorption (Ka), etc.
- PK/PD targets: For antibiotics, antivirals, or other drugs, you often have an exposure target (e.g., AUC/MIC ≥ 400 for vancomycin) that correlates with clinical success.
- Dose selection: PTA lets you compare regimens (e.g., 1 g q12h vs. 2 g q8h) and choose the one most likely to work across your whole patient population.

## How to Run it 
5/1/25 @2000
1. Open a previous Run and run a simulation.
- PMetrics samples (simulates) hundreds or thousands of “virtual patients” by drawing parameter sets from estimated joint distribution of (Cl, V, Ka, etc.). For each simulated patient, it computes the
exposure metric (e.g., AUC or % T > MIC) under the proposed dosing regimen.

~~~
#I chose to use the results from run 2
   simlist1 <- exRes2$sim(
  limits = c(0, 3), data = "../src/ptaex1.csv",
  predInt = c(120, 144, 0.5), seed = rep(-17, 4)
)

# With Covariates
simlist2 <- exRes2$sim(
  limits = 5, data = "../src/ptaex1.csv",
  predInt = c(120, 144, 0.5), seed = rep(-17, 4),
  covariate = covariate
)
~~~

2. Define labels and what is considered success and plot
- Success was free auc:mic > 100 with a free drug fraction of 50%
  ~~~
  pta2_2 <- PM_pta$new(
  simdata = simlist2,
  simlabels = simlabels, targets = c(0.25, 0.5, 1, 2, 4, 8, 16, 32),
  free.fraction = 0.7,
  target.type = "auc", success = 100, start = 120, end = 144)
  summary(pta2_2)
  pta2_2$plot(
  ylab = "Proportion with AUC/MIC of at least 100", grid = TRUE,
  legend = list(x = "bottomleft"))
  ~~~
![image](https://github.com/user-attachments/assets/f66b6c59-96bd-4698-9231-8bc377d93fba)
#### With Covariates
![image](https://github.com/user-attachments/assets/4b5729f2-6362-4cb1-841b-eb7088a7c490)
- Success Cmax/MIC >= 10
~~~
pta3_2 <- PM_pta$new(
  simdata = simlist2,
  simlabels = simlabels,
  targets = c(0.25, 0.5, 1, 2, 4, 8, 16, 32),
  target.type = "peak", success = 10, start = 120, end = 144)
pta3_2$summary()
pta3_2$plot(ylab = "Proportion with peak/MIC of at least 10", grid = TRUE)
~~~
![image](https://github.com/user-attachments/assets/e5586f05-0edc-4159-83fa-9b404a040ef9)

- Success Cmin/MIC > 1
~~~
pta4_2 <- PM_pta$new(
  simdata = simlist2,
  simlabels = simlabels,
  targets = c(0.25, 0.5, 1, 2, 4, 8, 16, 32),
  target.type = "min", success = 1, start = 120, end = 144
)
pta4_2$summary()
pta4_2$plot(ylab = "Proportion with Cmin/MIC of at least 1", grid = TRUE, legend = list(x = "bottomleft"))
~~~
![image](https://github.com/user-attachments/assets/2271868c-f46f-4319-b9f8-35fbc50e7648)


#### The PDI (pharmacodynamic index) of each regimen, rather than the proportion of successful profiles. 
~~~
# Each regimen has the 90% confidence interval PDI around the median curve,
# in the corresponding, semi-transparent color.  Make the CI much narrower...
pta4_2$plot(type = "pdi", ci = 0.1)
~~~
![image](https://github.com/user-attachments/assets/c64175ed-c2ca-40c6-98db-d4d8d6be1b03)




