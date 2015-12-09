from math import *
import operator as op
import numpy as np


print "#### "
print "#### Lemma 6 Verification :"
print "#### "

k = 8
V = k/2
sigma = sqrt(V)
q = 12289




### Chose one y. All 15 others leads to the same result.
y = [1,1,1,1]

### Construct a 4*4 matrix associated to y
def rot(v):
	return [-v[3],v[0],v[1],v[2]]

v1 = y
v2 = rot(v1)
v3 = rot(v2)
v4 = rot(v3)

mat = np.matrix([v1,v2,v3,v4])


### Construct the binomial law
supp = xrange(-k,k+1)

def binomial(n, r):
    r = min(r, n-r)
    if r == 0: return 1
    numer = reduce(op.mul, xrange(n, n-r, -1))
    denom = reduce(op.mul, xrange(1, r+1))
    return numer//denom

def pdf_binom(x):
	return binomial(2*k,x+k) / 2.**(2*k)


### Initialize a table to store the pdf of || x*y ||^2
### the range of the above distribution
ima = xrange(4 * (8*4)**2 )
Chi_y_Table = [0 for i in ima]

### Brute force computation of the pdf of || x*y ||^2
s = 0.
for x1 in supp:
	for x2 in supp:
		for x3 in supp:
			for x4 in supp:
				x = np.array([x1,x2,x3,x4])
				mx = x * mat
				s = mx[0,0]**2 + mx[0,1]**2 +mx[0,2]**2 + mx[0,3]**2
				p = pdf_binom(x1) * pdf_binom(x2) * pdf_binom(x3) * pdf_binom(x4)
				Chi_y_Table[s] += p                   ### The result is always a multiple of 4


print "# Chi_y summary "
avg = sum([i*Chi_y_Table[i] for i in ima])
print "average (A):", avg
var = sum([(i-avg)**2 *Chi_y_Table[i] for i in ima  ] )
print "variance (V):", var

mmax = 0
for i in ima:
	if (Chi_y_Table[i]>0):
		mmax = i
print "maximal value :", mmax
MM = max(avg,mmax-avg)
print "Bound from average (M) = ", MM







def Bernstein(n,avg,var, M,t ):
	return exp(- .5*t**2 / (n*var + 1/3. * M*t) )

c= 512
ber_tailcut = 2.5
print "# Applying Bernstein inequality"
print "c = ", c
t = c*avg*ber_tailcut
print "t / cA = ", t / (c*avg)
v_bern = c*avg + t
p_bern = Bernstein(c,avg,var, MM,t )
print "Bernstein tail value : cA + t =", v_bern
print "Bernstein tail proba p1 = 2^", log(p_bern)/log(2)
NN = t + c*avg


print "#### "
print "#### Corollary 1 :"
print "#### "


subg_k = sqrt(k/2)
tau = 13.1
subg_value = sqrt(v_bern) * sigma * tau
p_subg = exp(-tau**2/2 )

print "subgaussian parameter sigma = ", subg_k
print "tailcut parameter tau = ", tau
print "tailcut value ||v||* sigma * t = ", subg_value

print "sub-gaussian tail proba p2: 2^", log(p_subg) /log(2)
print "3q/4 = ", 3.*q/4.

print "Total failure proba <= 8 * p1 + 2 * p2 = 2^",
print log(8 * p_bern + 16 * 256 * p_subg)/log(2)