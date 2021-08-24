// saved as exp2_s5_or_s6.stan
//
data{
	int<lower=1> N;         // Number of observations
	int<lower=1, upper=3> C;         // Number of conditions
	int<lower=1, upper=3> condID[N]; // Condition ID
	int<lower=0> FC[N];     // Number of consumption
}
//
parameters{
	real intercept[C];                   // beta proxy
	real<lower=0> overdisp;
}
//
model{
	real muFC[N];
	
	intercept ~ normal(0, 3);
	overdisp ~ exponential(1);
	
	for ( n in 1:N ) {
		muFC[n] = intercept[condID[n]];
		FC[n] ~ neg_binomial_2_log(muFC[n], overdisp);
	}
	
}
