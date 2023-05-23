def objfunction_somo(x):
    import numpy as np
    import flopy
    import pandas as pd
    import os
    import flopy.modflow as fpm
    import flopy.utils as fpu
    import matplotlib.pyplot as plt
    import flopy.utils.binaryfile as bf
    import xlsxwriter
    import random
    #x=np.array([-1.1,-2.2,-3.3,-4.4,-5.5,-6.6,-7.7,-8.8,-9.9,-10.0]
#    x=np.array([0,0,-26569.9,0,-29279.6,0,-7526.88,0,0,0])
    #    x=np.array([    -0.,     -0., -77000.,     -0., -77000.,     -0., -77000.,
    #           -0.,      0.,     -0.])
    
    #    bin_vect=[1,1,1,0,0,0,0,0,0,0]
    
    
    bin_vect=[0, 0, 1, 0, 1, 0, 1, 0, 0, 0]
    #    np.random.shuffle(bin_vect)
    
    x=np.multiply(x,bin_vect)    
    x1=x[0]
    x2=x[1]
    x3=x[2]
    x4=x[3]
    x5=x[4]
    x6=x[5]
    x7=x[6]
    x8=x[7]
    x9=x[8]
    x10=x[9]
    
    
    
    # Assign name and create modflow model object
    modelname = 'Estcp'
    mf = flopy.modflow.Modflow(modelname, exe_name='mf2005')
    
    # Model domain and grid definition
    Lx = 12500
    Ly = 10000
    ztop = 100       # have to change this value
    zbot = 0
    nlay = 1
    nrow = 20
    ncol = 25
    delr = Lx/ncol
    delc = Ly/nrow
    delv = (ztop - zbot) / nlay
    nper=1;
    perlen=1825
    
    
    # 1.Create the discretization object
    dis = flopy.modflow.ModflowDis(mf, nlay, nrow, ncol, delr=delr, delc=delc,
                                   top=ztop, botm=zbot,nper=nper, perlen=perlen)
    
    # 2. Create Basic Package
    ibd = pd.read_excel('ESTCP_Ibound.xlsx',header=None)
    ib = ibd.as_matrix()
    ibound = np.zeros((nlay, nrow, ncol), dtype=np.int64)
    ibound[0,:,:]=ib
    shd1=pd.read_excel('ESTCP_Starting_Head.xlsx',header=None)
    sh1=shd1.as_matrix()
    strt = np.zeros((nlay, nrow, ncol), dtype=np.float32)
    strt[0,:,:]=sh1
    bas = flopy.modflow.ModflowBas(mf, ibound=ibound, strt=strt, ifrefm=False) # For fixed format, ifrefm=False; Free format=True
    
    # 3.MODFLOW BCF package
    
    bcf=flopy.modflow.ModflowBcf(mf,laycon=0,tran=5000, sf1=0.0001)
    
    # Pumping Well Package
    wel1=np.array([0, 8, 4, x1], dtype=object)
    wel2=np.array([0, 8, 6, x2], dtype=object)
    wel3=np.array([0, 8, 8, x3], dtype=object)
    wel4=np.array([0, 8, 9, x4], dtype=object)
    wel5=np.array([0, 8, 10, x5], dtype=object)
    wel6=np.array([0, 8, 11, x6], dtype=object)
    wel7=np.array([0, 8, 12, x7], dtype=object)
    wel8=np.array([0, 8, 13, x8], dtype=object)
    wel9=np.array([0, 7, 7, x9], dtype=object)
    wel10=np.array([0, 9, 7, x10], dtype=object)
    
                       
    stress_period_well_data={0:[wel1,wel2,wel3,wel4,wel5,wel6,wel7,wel8,wel9,wel10]}
                                               
    
    WEL=flopy.modflow.ModflowWel(mf, stress_period_data=stress_period_well_data)
    
    
    
    
    # 4.MODFLOW LMT package
    lmt=flopy.modflow.ModflowLmt(mf, output_file_name='Estcp_mt.ftl',
                                 extension='lmt6')
    
    
    
    
    
    break_point=1
    # 5. Output control
    spd = {(0, 0): ['print head', 'print budget','print drawdown', 'save head', 'save budget','save drawdown']}
    oc = flopy.modflow.ModflowOc(mf, stress_period_data=spd, compact=True)
    
    # 6.Add PCG package to the MODFLOW model
    pcg = flopy.modflow.ModflowPcg(mf)
    
    
    
    mf.write_input()
    [success, buff] = mf.run_model()
    break_point=1
    
    ###############################################################################
    ######################################MT3DMS simulation########################
    modelname = 'Estcp_mt'
    mt1 = flopy.mt3d.Mt3dms(modflowmodel=mf, modelname=modelname,
                           namefile_ext='nam',ftlfilename='Estcp_mt.ftl')
    species_T= pd.read_excel('ESTCP_Contaminant_Species.xlsx',header=None)
    species1=species_T.as_matrix()
    btn = flopy.mt3d.Mt3dBtn(mt1,nper=nper,perlen=perlen, icbund=1, prsity=0.15,
                             ncomp=1, sconc=species1)
    dsp=flopy.mt3d.Mt3dDsp(mt1, al=150, trpt=0.2, trpv=0, dmcoef=0)
    adv=flopy.mt3d.Mt3dAdv(mt1,mixelm=-1)
    ssm = flopy.mt3d.Mt3dSsm(mt1,crch=None)
    gcg = flopy.mt3d.Mt3dGcg(mt1, mxiter=10, iter1=50, isolve=3, ncrs=0,
                       accl=1, cclose=1e-6, iprgcg=1)
    mt1.write_input()
    [success1, buff]=mt1.run_model()
    
    ucnobj = bf.UcnFile('MT3D001.UCN', precision='single')
    Con_Species=ucnobj.get_alldata(mflay=0, nodata=-9999)
    cont_last_timestep=Con_Species[0,:,:]
    concen_TF=Con_Species[0,:,:]>=5
    concen_01=concen_TF*1
    con_sum=sum(map(sum,concen_01))
    Penalty_Con=1000000
    F=-sum(x)+con_sum*Penalty_Con
    
    
    F1=np.array([F,0])
    F1=np.array_str(F1)
    x=np.array_str(x)                    
    fid=open('OP_Swarm_Package.txt', 'a')
    fid.writelines(F1)
    fid.writelines('\n')
    fid.writelines(x)
    fid.writelines('.............................................................')
    fid.writelines('\n')
    fid.close() 
    ucnobj.close() 
    return F
       























































