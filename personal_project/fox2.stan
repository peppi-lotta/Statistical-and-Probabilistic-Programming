data{
  int N;
  vector[N] af;
  vector[N] gs;
  vector[N] w;
}

parameters{
  real<lower=0> sigma; //standard diviation
  real a;
  real bAf;
  real bGs;
}

model{
  
  // Likelihood
  w ~ normal( a + bAf*af + bGs*gs , sigma );
  
  // Priors
  a ~ normal(0, 0.2);
  bAf ~ normal(0, 0.5);
  bGs ~ normal(0, 0.5);
}

generated quantities { 
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(w[n] | a + bAf*af[n] + bGs*gs[n], sigma);
  } 
}
