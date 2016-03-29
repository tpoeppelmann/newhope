from math import *
from scipy.special import erf,binom

k = 16

## Construct the centered binomial pdf
L_Bnn = [binom(2*k,k+i) for i in range(k+1)]
f_B = float(2*sum(L_Bnn) - L_Bnn[0])
L_B = [x/f_B for x in L_Bnn]

def psi(i):
	return L_B[abs(i)]

supp_psi = xrange(-k,k+1)

### Construct the rounded_gaussian pdf
sig = sqrt(k/2)
tau = 30
tail = int(ceil(tau*sig))
supp_chi = xrange(-tail,tail+1)

### Define the cdf of the continuous gaussian of variance 1
def Phi(z): 
	return .5 * (1 + erf(z/sqrt(2)))

### Define the pdf of the rounded gaussian
def chi(i):
	return Phi((i+.5)/sig) - Phi((i-.5)/sig)


### Sanity check of proper normalization 
assert (sum([chi(i) for i in supp_chi]) - 1.) < 2.**(-45)
assert (sum([psi(i) for i in supp_psi]) - 1.) < 2.**(-45)


### Compute the Renyi Sum
a = 9.
S = 0.
for k in supp_psi:
	S += (psi(k)**a) / (chi(k)**(a-1))
R = S**(1./(a-1))

### Print the result
print "R_",a," ( psi || chi ) = ", R
print "R_",a," (  P  ||  Q  ) = ", R**(5*1024)
