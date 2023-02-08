data {
  int N;
  vector[N] R;
  vector[N] A;
  vector[N] I;
  vector[N] C;
}
parameters {
  real a;
  ordered[N] cutpoints;
  real sigma;
  
  real bA;
  real bI;
  real bC;
  
  real bIA;
  real bIC;

}
model {
  bA ~ normal(0, 0.5);
  bI ~ normal(0, 0.5);
  bC ~ normal(0, 0.5);
  bIA ~ normal(0, 0.5);
  bIC ~ normal(0, 0.5);
  sigma ~ exponential(1);
  a ~ normal(0, sigma);
  cutpoints ~ normal(0 , 1.5);
  
  R ~ ordered_logistic(a + bA*A + bC*C + (bI + bIA*A + bIC*C) * I , cutpoints);
}
