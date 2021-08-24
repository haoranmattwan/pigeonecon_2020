// saved as cond1_sav_nor.stan
//
data{
	int<lower=1> N;         // Number of observations
	int<lower=1> S;         // Number of subjects
	int<lower=1> subID[N];  // Subject IDs
	int<lower=1> C;         // Number of conditions
	int<lower=1> condID[N]; // Condition ID
	real<lower=0, upper=1> Sav[N];      // Number of tokens saved per trial
}
//
transformed data {
	vector[S] u;
	for (s in 1:S) {
		u[s] = 1;
	}
}
//
parameters{
	matrix[C, S] z;                   // beta proxy
	cholesky_factor_corr[C] L_Omega;  // prior correlation
	vector<lower=0>[C] tau;           // prior scale
	row_vector[C] gamma;              // population means
	real<lower=0> theta[S];
}
//
transformed parameters{
	matrix[S,C] zeta;                 // individual coefficients for each subject in each condition
	zeta = u * gamma + (diag_pre_multiply(tau,L_Omega) * z)';
}
//
model{
	to_vector(z) ~ normal(0,1);
	L_Omega ~ lkj_corr_cholesky(2);
	tau ~ exponential(1.5);
	to_vector(gamma) ~ normal(0,1.5);
	theta ~ exponential(1);

	for ( n in 1:N ) {
		Sav[n] ~ beta_proportion( inv_logit(zeta[subID[n],condID[n]]),theta[subID[n]]);
		}	
}
