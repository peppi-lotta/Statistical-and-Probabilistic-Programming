data{
  int N;
  vector[N] x;
  vector[N] y;
}

transformed data {
  vector[N] x_sq;
  vector[N] x_cu;
  for(i in 1:N) x_sq[i] = x[i]*x[i];
  for(i in 1:N) x_cu[i] = x_sq[i]*x[i];
}

parameters{
  real a;
  real b;
  real c;
  real d;
  real<lower=0> sigma;
}

model{
  
  // Likelihood
  y ~ normal(a + b*x + c*x_sq + d*x_cu, sigma);
  
  // Priors
  a ~ normal(0, 1);
  b ~ normal(0, 1);
  c ~ normal(0, 1);
  sigma ~ gamma(2, 1);
}
generated quantities { 
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(y[n] | d*x_cu[n]+c*x_sq[n]+x[n]*b+a, sigma);
  } 
}
