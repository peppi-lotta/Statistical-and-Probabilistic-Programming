data{
  int N;
  vector[N] x;
  vector[N] y;
}

parameters{
  real<lower=0> sigma; //standard diviation
  real a;
  real bA;
}

model{
  
  // Likelihood
  y ~ normal( a + bA*x , sigma );
  
  // Priors
  a ~ normal(0, 1);
  bA ~ normal(0, 2);
}

generated quantities { 
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(y[n] | a + bA*x[n], sigma);
  } 
}
