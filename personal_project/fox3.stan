data{
  int N;
  vector[N] ar;
  vector[N] gs;
  vector[N] w;
}

parameters{
  real<lower=0> sigma; //standard diviation
  real a;
  real bAr;
  real bGs;
}

model{
  
  // Likelihood
  w ~ normal( a + bAr*ar + bGs*gs , sigma );
  
  // Priors
  a ~ normal(0, 0.2);
  bAr ~ normal(0, 0.5);
  bGs ~ normal(0, 0.5);
}

generated quantities { 
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(w[n] | a + bAr*ar[n] + bGs*gs[n], sigma);
  } 
}
