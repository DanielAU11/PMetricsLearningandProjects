# Results of Probability of Target Attainment

### What is Probability of Target Attainment (PTA)?
This feature allows us to quantify how likely a given dosing regimen is to achieve a predefined pharmacokinetic/pharmacodynamic target. For example, an AUC/MIC ratio used to determine
the antibiotic AUC to the time above the minimum inhibitory concentration (MIC) needed to inhibit microorganisms. %T > MIC and Cₘᵢₙ/MIC are other measures. 

Allows us to answer this question: “If I give this dose to patients whose PK parameters vary as they do in the population, what fraction of them will hit my efficacy target?”

### Why it is Used?
- Inter‐patient variability: Patients differ in clearance (Cl), volume (V), absorption (Ka), etc.
- PK/PD targets: For antibiotics, antivirals, or other drugs, you often have an exposure target (e.g., AUC/MIC ≥ 400 for vancomycin) that correlates with clinical success.
- Dose selection: PTA lets you compare regimens (e.g., 1 g q12h vs. 2 g q8h) and choose the one most likely to work across your whole patient population.

## How to Run it 
1. Open a previous Run and runa simulation.
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

2. Define labels and what is considered success
- Success was free auc:mic > 100 with a free drug fraction of 50%
![image](https://github.com/user-attachments/assets/f66b6c59-96bd-4698-9231-8bc377d93fba)
- Success Cmax/MIC >= 10
![image](https://github.com/user-attachments/assets/e5586f05-0edc-4159-83fa-9b404a040ef9)
-Success Cmin/MIC > 1
![image](https://github.com/user-attachments/assets/2271868c-f46f-4319-b9f8-35fbc50e7648)

plot the PDI (pharmacodynamic index) of each regimen, rather than the proportion of successful profiles. A PDI plot is always available for PMpta objects.


$$PTA = \frac {\text{number of simulated patients whose exposure ≥ target}}{\text{total number of simulations}}$$

#### With Covariates
![image](https://github.com/user-attachments/assets/4b5729f2-6362-4cb1-841b-eb7088a7c490)

