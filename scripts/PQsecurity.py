from math import *

## The root hermite factor delta of BKZ-b
def delta_BKZ(b):
	return ( (pi/b)**(1./b) * b / (2*pi*exp(1)))**(1./(2.*b-2.))

## log_2 of best plausible Quantum Cost of SVP in dimension b
def best_plausible(b):
	return .2075 * b

## log_2 of best known Quantum Cost of SVP in dimension b
def best_known(b):
	return .268 * b


## Test the primal attack
def primal_check_b(q,n,s,b):
	d = 2*n + 1
	delta = delta_BKZ(b)
	return s * sqrt(b) < delta**(2.*b-d-1) * q**(n* 1./d)

## Find the smallest block-size for the primal attack
def primal_get_b(q,n,s):
	for b in range(50,2*n+1):
		if primal_check_b(q,n,s,b):
			return b

## Test the dual attack
def dual_check_b(q,n,s,b,sec):
	d = 2*n
	delta = delta_BKZ(b)
	l = delta**(d-1) * q**(1.*n/d)
	tau = l * s / q
	x = - pi * tau**2
	y = - sec * log(2)
	return x > y 

## Find the smallest block-size for the dual attack
def dual_get_b(q,n,s,sec):
	for b in range(50,2*n+1):
		if dual_check_b(q,n,s,b,sec):
			return b


verbose = False
## Create a report on the best BKZ primal attack
def break_params(q,n,ssigma):
	if verbose:
		print "Parameters : q = ", q, "n = ", n , " sigma = ", ssigma
	b = primal_get_b(q,n,ssigma)

	if verbose:
		print "-- Primal  --", "\t",
		print "blck:", b, "\t",
		print "rhf : ", sqrt(delta_BKZ(b)), "\t",
		print "BKA : 2^",best_known(b), " \t",
		print "BPA : 2^", best_plausible(b)
	else:
		print "Primal &",b, "&", int(ceil(best_known(b))), "&", int(ceil(best_plausible(b))), "\\\\"


	b = dual_get_b(q,n,ssigma,128)

	if verbose:
		print "--Dual-128 --", "\t",
		print "blck:", b, "\t",
		print "rhf : ", sqrt(delta_BKZ(b)), "\t",
		print "BKA : 2^",best_known(b), " \t",
		print "BPA : 2^", best_plausible(b)
	else:
		print "Dual ($\epsilon = 2^{-128}$)&",b, "&", int(ceil(best_known(b))), "&", int(ceil(best_plausible(b))), "\\\\"

	b = dual_get_b(q,n,ssigma,1)

	if verbose:
		print "--Dual -1  --", "\t",
		print "blck:", b, "\t",
		print "rhf : ", sqrt(delta_BKZ(b)), "\t",
		print "BKA : 2^",best_known(b), " \t",
		print "BPA : 2^", best_plausible(b)
	else:
		print "Dual ($\epsilon = 1/2$)&", b, "&", int(ceil(best_known(b))), "&", int(ceil(best_plausible(b))), "\\\\"

print "### BCNS PostQuantum-KE proposal ###"
break_params(2**32,1024,3.192)
print

print "### Our PostQuantum-KE proposal ###"
break_params(12289,1024,sqrt(12/2))
print 

print "### Weaker version with n=512 ###"
break_params(12289,512,sqrt(8/2))
print 

