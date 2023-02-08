data {
  int U;
  int N;
  int<lower=1, upper=7> R[N];
  int<lower=0, upper=1> A[N];
  int<lower=0, upper=1> I[N];
  int<lower=0, upper=1> C[N];
  int id[N];
}
parameters {
  vector[U] a;
  ordered[N] cutpoints;
  real sigma;
  
  real bA;
  real bI;
  real bC;
  
  real bIA;
  real bIC;

}
model {
  vector[N] phi;
  vector[N] BI;
  bA ~ normal(0, 0.5);
  bI ~ normal(0, 0.5);
  bC ~ normal(0, 0.5);
  bIA ~ normal(0, 0.5);
  bIC ~ normal(0, 0.5);
  sigma ~ exponential(1);
  a ~ normal(0, sigma);
  cutpoints ~ normal(0 , 1.5);

  for (n in 1:N) {
    BI[n] = bI + bIA*A[n] + bIC*C[n];
    phi[n] = a[id[n]] + bA*A[n] +bC*C[n] + BI[n]*I[n];
  }
  R ~ ordered_logistic(phi, cutpoints);
}
