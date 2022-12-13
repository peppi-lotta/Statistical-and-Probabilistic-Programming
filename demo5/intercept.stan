data{
  int N;
  vector[N] x;
  vector[N] y;
}

parameters{
  real a;
  real<lower=0> sigma;
}

model{
  
  // Likelihood
  y ~ normal(a, sigma);
  
  // Priors
  a ~ normal(0, 1);
  sigma ~ gamma(2, 1);
}

generated quantities { 
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(y[n] | x[n]+a, sigma);
  } 
}