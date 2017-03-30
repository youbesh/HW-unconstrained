module HW_unconstrained
	# imports: which packages are we going to use in this module?
	using Distributions, Optim, Plots, DataFrames, Gallium

	"""
    `input(prompt::AbstractString="")`

    Read a string from STDIN. The trailing newline is stripped.

    The prompt string, if given, is printed to standard output without a
    trailing newline before reading input.
    """
    function inpt(prompt::AbstractString="")
        print(prompt)
        return chomp(readline())
    end

    export maximize_like_grad, runAll, makeData

	# methods/functions
	# -----------------

	# data creator
	# should/could return a dict with beta,numobs,X,y,norm)
	# true coeff vector, number of obs, data matrix X, response vector y, and a type of parametric distribution for G.
	function makeData(n=10000)
		beta = [ 1; 1.5; -0.5 ]
		srand(123)
		X = randn(n, 3)
		e = randn(n)
		z = X*beta + e
		y = zeros(n)
		for i=1:n
			 if z[i] > 0
				y[i] = 1
			else
				y[i] = 0
			end
		end
		dict = Dict("beta" => beta, "numobs" => n,
		"X" => X, "y" => y, "dstr" => Normal())
		return dict
	end

	# log likelihood function at x
	# function loglik(betas::Vector,X::Matrix,y::Vector,distrib::UnivariateDistribution)
	function loglik(betas::Vector,d::Dict)
		xb = d["X"]*betas
		cdf_xb = cdf(d["dstr"], xb)
		lglk = d["y"] .* log(cdf_xb)  .+ (1-d["y"]) .* log(1 - cdf_xb)
		sum_lk = -sum(lglk) #since in the plots we'll be looking for a minimum
		return sum_lk
	end
	#sum(d["y"][i] * log(cdf(d["dstr"], d["X"][i,:]'*betas))  + (1-d["y"][i]) * (1-log(cdf(d["dstr"], d["X"][i,:]'*betas))) for i in 1:d["numobs"])



	# function that plots the likelihood
	# we are looking for a figure with 3 subplots, where each subplot
	# varies one of the parameters, holding the others fixed at the true value
	# we want to see whether there is a global minimum of the likelihood at the the true value.
	function plotLike()
	makeData()
	f(x) = loglik([x; 1.5; -0.5 ],makeData())
	ff(x) = loglik([1; x; -0.5],makeData())
	fff(x) = loglik([1; 1.5; x],makeData())
	p = Any[]
	q = plot(f, xticks=-10:1:10, label="Varying beta_1", lw=2, color="green")
	push!(p, q)
	r = plot(ff, xticks=-10:1:10, label="Varying beta_2", lw=2, color="purple")
	push!(p, r)
	s = plot(fff, xticks=-10:1:10, label="Varying beta_3", lw=2, color="orange")
	push!(p, s)
	p1 = plot(p...)
	display(p1)
	end

	# function that maximizes the log likelihood without the gradient
	# with a call to `optimize` and returns the result
	function maximize_like(x0=[0.8,1.0,-0.1],meth=:nelder_mead)
		makeData()
		k(betas) = loglik(betas, makeData())
		optimize(k, x0, NelderMead())
	end

	# gradient of the likelihood at x
	function grad!(betas::Vector,storage::Vector,d)
		xb = d["X"]*betas
		cdf_xb = cdf(d["dstr"], xb)
		pdf_xb = pdf(d["dstr"], xb)
		storage = -sum(d["y"] ./ cdf_xb .* pdf_xb  .+ (-1+d["y"]) ./ (1 - cdf_xb) .* pdf_xb)
	end

	# hessian of the likelihood at x
	function hessian!(betas::Vector,storage::Matrix,d)
	end


	"""
	inverse of observed information matrix
	"""
	function inv_observedInfo(betas::Vector,d)
	end

	"""
	standard errors
	"""
	function se(betas::Vector,d::Dict)
	end





	# function that maximizes the log likelihood with the gradient
	# with a call to `optimize` and returns the result
	function maximize_like_grad(x0=[0.8,1.0,-0.1],meth=:bfgs)
		k(betas) = loglik(betas, makeData())
		optimize(k, x0, BFGS())
	end

	function maximize_like_grad_hess(x0=[0.8,1.0,-0.1],meth=:newton)
	end

	function maximize_like_grad_se(x0=[0.8,1.0,-0.1],meth=:bfgs)
	end


	# visual diagnostics
	# ------------------

	# function that plots the likelihood
	# we are looking for a figure with 3 subplots, where each subplot
	# varies one of the parameters, holding the others fixed at the true value
	# we want to see whether there is a global minimum of the likelihood at the the true value.

	#function plotLike()

	#end

	function plotGrad()
	end


	function runAll()
		plotLike()
		m1 = maximize_like()
		m2 = maximize_like_grad()
		println("results are:")
		println("maximize_like: $(m1.minimum)")
		println("maximize_like_grad: $(m2.minimum)")
		println("")
		ok = inpt("enter y to close this session.")
		if ok == "y"
			quit()
		end
	end

end
