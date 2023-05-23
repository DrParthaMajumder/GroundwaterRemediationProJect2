clc
clear all
close all
a=char(13);

fin=fopen('cariagereturn1.txt','w');
dlmwrite('cariagereturn1.txt',a);
fclose(fin);