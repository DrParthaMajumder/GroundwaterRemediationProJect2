clc
clear all
close all
tic
display('Wait Program is running USING PSO****--->');
format long g
WAIT1= waitbar(0,'Please Wait');
N=30;         %% Total Population Size (Number of Particles)
D=10;          %% Dimensions of fitness function (x1,x2)
itmax=200;     %% Total function evaluation will be N*itmax
c1=2.05;
c2=2.05;
wmax=0.9;
wmin=0.4;

w=linspace(wmax,wmin,itmax); %% Linear variation of w 
%% Bounds of Variable::
a(1:N,1)=-77000;                                             %% Lower bound for x1
b(1:N,1)=0;                                          %% Upper Bound for x1

a(1:N,2)=-77000;                                  
b(1:N,2)=0;

a(1:N,3)=-77000;                                  
b(1:N,3)=0;


a(1:N,4)=-77000;                                  
b(1:N,4)=0;


a(1:N,5)=-77000;                                             %% Lower bound for x1
b(1:N,5)=0;                                          %% Upper Bound for x1

a(1:N,6)=-77000;                                  
b(1:N,6)=0;

a(1:N,7)=-77000;                                  
b(1:N,7)=0;


a(1:N,8)=-77000;                                  
b(1:N,8)=0;

a(1:N,9)=-77000;                                  
b(1:N,9)=0;


a(1:N,10)=-77000;                                  
b(1:N,10)=0;



d=(b-a);
q=d/200;
%% Bounds of variable
%% Random Initialization of position and Velocity
check=rand(N,D);
x=a+d.*rand(N,D); %% random Initialization of Position 
v=q.*rand(N,D);

vmin(1:N,1)=-1500;
vmax(1:N,1)=1500;

vmin(1:N,2)=-1500;
vmax(1:N,2)=1500;

vmin(1:N,3)=-1500;
vmax(1:N,3)=1500;

vmin(1:N,4)=-1500;
vmax(1:N,4)=1500;

vmin(1:N,5)=-1500;
vmax(1:N,5)=1500;

vmin(1:N,6)=-1500;
vmax(1:N,6)=1500;

vmin(1:N,7)=-1500;
vmax(1:N,7)=1500;

vmin(1:N,8)=-1500;
vmax(1:N,8)=1500;

vmin(1:N,9)=-1500;
vmax(1:N,9)=1500;

vmin(1:N,10)=-1500;
vmax(1:N,10)=1500;


break_point=1;
for pp=1:1:N
display(pp);    
pop=x(pp,:);    
F(pp) = objfunction( pop );
end

[F_g_best,kk]=min(F);
g_best=x(kk,:);
P_best=x;  %% pi=xi
Fp_best=F; %% Archive

break_point=2;

for it=1:1:itmax
   ITERATION_NO=it
   v(1:N,1:D)=(w(it).*v(1:N,1:D))+(c1*rand*(P_best(1:N,1:D)-x(1:N,1:D)))+(c2*rand*(repmat(g_best,N,1)-x(1:N,1:D)));
   
   v(:,1)=min(v(:,1),vmax(:,1));
   v(:,1)=max(v(:,1),vmin(:,1));
   v(:,2)=min(v(:,2),vmax(:,2));
   v(:,2)=max(v(:,2),vmin(:,2));
   v(:,3)=min(v(:,3),vmax(:,3));
   v(:,3)=max(v(:,3),vmin(:,3));
   v(:,4)=min(v(:,4),vmax(:,4));
   v(:,4)=max(v(:,4),vmin(:,4));
   v(:,5)=min(v(:,5),vmax(:,5));
   v(:,5)=max(v(:,5),vmin(:,5));
   v(:,6)=min(v(:,6),vmax(:,6));
   v(:,6)=max(v(:,6),vmin(:,6));
   v(:,7)=min(v(:,7),vmax(:,7));
   v(:,7)=max(v(:,7),vmin(:,7));
   v(:,8)=min(v(:,8),vmax(:,8));
   v(:,8)=max(v(:,8),vmin(:,8));
   v(:,9)=min(v(:,9),vmax(:,9));
   v(:,9)=max(v(:,9),vmin(:,9));
   v(:,10)=min(v(:,10),vmax(:,10));
   v(:,10)=max(v(:,10),vmin(:,10));
   
   x(1:N,1:D)=x(1:N,1:D)+v(1:N,1:D);
   
   x(:,1)=min(x(:,1),b(:,1));
   x(:,1)=max(x(:,1),a(:,1));
   x(:,2)=min(x(:,2),b(:,2));
   x(:,2)=max(x(:,2),a(:,2));
   x(:,3)=min(x(:,3),b(:,3));
   x(:,3)=max(x(:,3),a(:,3));
   x(:,4)=min(x(:,4),b(:,4));
   x(:,4)=max(x(:,4),a(:,4)); 
   x(:,5)=min(x(:,5),b(:,5));
   x(:,5)=max(x(:,5),a(:,5));
   x(:,6)=min(x(:,6),b(:,6));
   x(:,6)=max(x(:,6),a(:,6));
   x(:,7)=min(x(:,7),b(:,7));
   x(:,7)=max(x(:,7),a(:,7));
   x(:,8)=min(x(:,8),b(:,8));
   x(:,8)=max(x(:,8),a(:,8)); 
   x(:,9)=min(x(:,9),b(:,9));
   x(:,9)=max(x(:,9),a(:,9));
   x(:,10)=min(x(:,10),b(:,10));
   x(:,10)=max(x(:,10),a(:,10));
   
   
   
  
   
   for pp=1:1:N
   pop=x(pp,:);    
   F(pp) = objfunction(pop);
   end
   [minF,kk]=min(F);
   if minF<= F_g_best
   F_g_best=minF; 
   g_best=x(kk,:);       %% Imp
   end
   kkp=find(F<=Fp_best);
   P_best(kkp,:)=x(kkp,:); 
   Fp_best(kkp)=F(kkp);
   F_g_best_k(it)=F_g_best;
   waitbar(it/itmax);
   end
display('output Using Particle Swarm Optimization');
X_Sol=g_best
F_Val=F_g_best

% itk=1:1:itmax;
% plot(itk,-F_g_best_k)
% grid on
% xlabel('No of Generation ');
% ylabel('Summation of total pumping and diversion');
% 
% Mat=[itk',-F_g_best_k'];
% xlswrite('Max_Pump_and_Diversion_PSO1.xls',Mat);
% display('Program Completed'); 

%save('Results1.mat')
%save('Results2.mat')
% save('Results3.mat')  %% Important
% save('Results4.mat')

% load('Results4.mat')
toc/60
break_point=3   









