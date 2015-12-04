



# unconstrained optimization

## maximum likelihood: probit

### show gradient

module maxlike

	# imports: which packages are we going to use in this module?
	using Distributions



	# methods/functions
	# -----------------

	# data creator
	# should return a tuple with beta,numobs,X,y,norm)
	# true coeff vector, number of obs, data matrix X, response vector y, and a type of parametric distribution for G.
	function makeData(n=10000)
		# fill in here the correct values
		beta = zeros(3)
		X = zeros(n,3)
		y = zeros(n)
		dist = Normal(0,1)  # here a distribution object
		return Dict("beta"=>beta,"n"=>n,"X"=>X,"y"=>y,"dist"=>dist)
	end


	# log likelihood function at x
	function loglik(betas::Vector,X::Matrix,y::Vector,distrib::UnivariateDistribution) 

	end


	# gradient of the likelihood at x
	function grad(betas::Vector,storage::Vector,X::Matrix,y::Vector,distrib::UnivariateDistribution)

	end



	# function that maximizes the log likelihood without the gradient
	# with a call to `optimize` and returns the result
	function maximize_like()


	end



	# function that maximizes the log likelihood with the gradient
	# with a call to `optimize` and returns the result
	function maximize_like_grad()

	end



	# visual diagnostics
	# ------------------

	# function that plots the likelihood
	# we are looking for a figure with 3 subplots, where each subplot
	# varies one of the parameters, holding the others fixed at the true value
	# we want to see whether there is a global minimum of the likelihood at the the true value.
	function plotLike()


	end

	# exports: which functions/variables should be visible from outside the module?
	export makeData


end





