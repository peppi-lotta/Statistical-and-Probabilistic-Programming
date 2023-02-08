data{
  int N;
  vector[N] ar;
  vector[N] af;
  vector[N] gs;
  vector[N] w;
}

parameters{
  real<lower=0> sigma; //standard diviation
  real a;
  real bAr;
  real bAf;
  real bGs;
}

model{
  
  // Likelihood
  w ~ normal( a + bAr*ar + bAf*af + bGs*gs , sigma );
  
  // Priors
  a ~ normal(0, 0.2);
  bAr ~ normal(0, 0.5);
  bAf ~ normal(0, 0.5);
  bGs ~ normal(0, 0.5);
}

generated quantities { 
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(w[n] | a + bAr*ar[n] + bAf*af[n] + bGs*gs[n], sigma);
  } 
}
