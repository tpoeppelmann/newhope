from math import *
import operator as op
import numpy as np
from random import *
import sys



q = 12289
q2 = q/2

B = np.matrix([[1,0,0,0],[0,1,0,0],[0,0,1,0],[.5,.5,.5,.5]])
g = np.array([.5,.5,.5,.5])

Tests = 10000

def modq(x):
	return (x+q2) % q - q2

def modqv(L):
	return map(modq,L)

def mod1(x):
	return (x+.5) % 1 - .5

def mod1v(L):
	return map(mod1,L)


def mod4(x):
	return x %4

def mod4v(L):
	return map(mod4,L)


def LDEncode(k):
	return 4*[(k % 2)/2.]


def norm2(x):
	return sum([a*a for a in x])

def norm1(x):
	return sum([abs(a) for a in x])

def norminfty(x):
	return max([abs(a) for a in x])

def CVPD4(x):
	v0 = map(round, x )
	v1 = map(round, [a - .5 for a in x])
	if norm1(x-v0) < 1.:
		return np.array([v0[0],v0[1],v0[2],0]) + v0[3] * np.array([-1,-1,-1,2])
	else:
		return np.array([v1[0],v1[1],v1[2],1]) + v1[3] * np.array([-1,-1,-1,2])

print "testing Vornoi reduction in D4"
for i in range(Tests):
	t = np.array([10 *(random()-.5) for i in range(4)])
	v = np.array(t - CVPD4(t)*B)[0]
	if norm1(v)>1:
		print "Norm l_1 condition violated (Type A Voronoi Relevant Vector)"
		exit(0)
	if norminfty(v)>.5:
		print "Norm l_oo condition violated (Type B Voronoi Relevant Vector)"
		exit(0)
print "All",Tests, "tests passed"
sys.stdout.flush()

def LDDecode(x):
	if norm1(mod1v(x)) <= 1:
		return 0
	return 1


def HelpRec(x):
	b = randint(0,1)
	c = CVPD4(4 * (1./q * x + 1.*b * g/q))
	return mod4(c)

def Rec(x,r):
	return LDDecode(1./q * x - .25 * np.array((r * B).flat))

print "testing Reconciliation"
h = 0

for ii in range(Tests):
	x = np.array([randint(0,q-1) for i in range(4)])
	e = np.array([np.random.normal(0,500) for i in range(4)])
	if norminfty(e)> .75 * q/4.:
		h+=1
		print h,ii,norminfty(e)
	xx = x + e
	r = HelpRec(x)
	k = Rec(x,r)
	kk = Rec(xx,r)
	if not k==kk:
		print "Key agreement failure"
		print ii,norm1(e)
		exit(0)

print "All",Tests, "tests passed"
sys.stdout.flush()
print "Getting stats"
sys.stdout.flush()
h = 0

sample = 256*100000

for i in range(20):
	s = 0
	for ii in range(sample):
		x = np.array([randint(0,q-1) for i in range(4)])
		r = HelpRec(x)
		k = Rec(x,r)
		s += k

	print sample ,s, 1.*s/sample
	print "diff :", sample - 2*s
	sys.stdout.flush()