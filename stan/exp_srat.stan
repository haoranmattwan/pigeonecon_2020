// saved as exp2_sav.stan
//
data{
	int<lower=1> N;         // Number of observations
	int<lower=1, upper=4> C;         // Number of conditions
	int<lower=1, upper=4> condID[N]; // Condition ID
	real<lower=0, upper=1> Rat[N];      // Number of tokens saved per trial
}
//
parameters{
	real zeta[C];                   // beta proxy
	real<lower=0> theta;
}
//
model{
	
	theta ~ exponential(1);
	
	for ( n in 1:N ) {
		Rat[n] ~ beta_proportion( inv_logit(zeta[condID[n]]), theta );
		}	
}
