data{
  int N;
  vector[N] x;
  vector[N] w;
}

parameters{
  real<lower=0> sigma; //standard diviation
  real a;
  real bX;
}

model{
  
  // Likelihood
  w ~ normal( a + bX*x , sigma );
  
  // Priors
  a ~ normal(0, 0.2);
  bX ~ normal(0, 0.5);
}

generated quantities { 
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(w[n] | a  + bX*x[n], sigma);
  } 
}
