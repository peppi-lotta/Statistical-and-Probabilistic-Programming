data {
  int<lower=0> N;
  vector[N] x;
}

parameters {
  real mu; //mean
  real<lower=0> sigma; //standard diviation
}

model {
  x ~ normal(mu, sigma);
  //mu ~ normal(0, 10);
  //sigma ~ gamma(2, 1);
}

generated quantities {
  //simulate new data
  vector[N] x_rep;
  for (n in 1:N) {
    x_rep[n] = normal_rng(mu, sigma);
  }
}
