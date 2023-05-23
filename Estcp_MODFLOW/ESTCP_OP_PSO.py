# -*- coding: utf-8 -*-
"""
Created on Tue May 22 20:35:52 2018

@author: partha
"""
#SP=subprocess
from timeit import default_timer as timer
start= timer()
from objfunction_somo import objfunction_somo

print("Optimization Starts from Here: Wait for the Result**************")        
from pyswarm import pso
lb=[-77000, -77000, -77000,  -77000 ,-77000,-77000, -77000, -77000,  -77000 ,-77000] 
ub=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 

#xopt, fopt = pso(objfunction, lb, ub) 
xopt, fopt=pso(objfunction_somo, lb, ub, ieqcons=[], f_ieqcons=None, args=(),
               kwargs={},swarmsize=30, omega=0.5, phip=0.5, phig=0.5,
               maxiter=50, minstep=1e-7,
    minfunc=1e-7, debug=False)
    
end = timer()
print("Time taken:", end-start) 




















































