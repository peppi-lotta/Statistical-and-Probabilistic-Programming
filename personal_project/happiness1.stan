data { 
  int N;
  vector[N] x; 
  vector[N] y; 
  int mid[N]; 
} 

parameters { 
  vector[2] a;
  real bA;
  real sigma; 
}

model { 
  vector[N] mu; 
  sigma ~ exponential( 1 ); 
  a ~ normal( 1 , 0.1 ); 
  for ( i in 1:N ) { 
    mu[i] = a[mid[i]] + bA * x[i];  
  } 
  y ~ normal( mu , sigma ); 
}

generated quantities { 
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(y[n] | a[mid[n]] + bA * x[n], sigma);
  } 
}
