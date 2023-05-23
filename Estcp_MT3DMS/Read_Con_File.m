% clc
% clear all
% close all
fid=fopen('MT3D001.UCN','r');
format long g
data=fread(fid,'float32');
data_length_c=length(data);


  m=data(12:data_length_c);
 l=length(m);
 c_vect=m';
 for ii=1:20
     for jj=1:25
         btc(ii,jj)=c_vect((jj-1)+1+(ii-1)*25);
      end
  end
c15=btc;
fclose(fid);
break_point=1;