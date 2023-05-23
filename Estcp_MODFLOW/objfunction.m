function [ F ] = objfunction( x )
Penalty_Con=1000000
% x=[0  0   -26569.9  0   -29279.6    0   -7526.88    0   0  0];
% x=[-1  -2   -3  -4   -5    -6   -7    -8   -9  -10];
bin_vect=[0, 0, 1, 0, 1, 0, 1, 0, 0, 0]

x=x.*bin_vect;
aaa= H5F.open ('Estcp.h5','H5F_ACC_RDWR','H5P_DEFAULT');
bbb=H5D.open (aaa, '/Well/07. Property');
ccc=H5D.read(bbb,'H5T_IEEE_F64LE','H5S_ALL','H5S_ALL','H5P_DEFAULT')

ccc(:,3,1)=x(3);
ccc(:,5,1)=x(5);
ccc(:,7,1)=x(7);

H5D.write (bbb,'H5ML_DEFAULT','H5S_ALL','H5S_ALL','H5P_DEFAULT', ccc);
H5F.close (aaa);
H5D.close (bbb); 
!mf2k_h5 Estcp.mfn

cd C:\113flowpy\ESTCP_GMS\Estcp_MT3DMS;
!mt3dms53 Estcp.mts <cariagereturn1.txt;

Read_Con_File;
c15=c15;
c15_penalty=c15>=5;
c15_penalty_sum=sum(sum(c15_penalty)); 
 
cd C:\113flowpy\ESTCP_GMS\Estcp_MODFLOW; 
 
F=-sum(x)+c15_penalty_sum*Penalty_Con;


end

