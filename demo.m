%Superresolution GrayScale Test Script
clc,clear, close all

IMG_FILENAME = 'cameraman.tif'; % image to superresolve
BLUR_KERNEL = 'motion';         % blur kernel (argument to fspecial) 
DISP_FLAG = 1;         % ctrls whether or not figures are displayed 
PRIOR = 'DAMRF';       % ctrls which prior the algorithm uses (DAMRF/GMRF) 
MAX_ITR = 100;         % max number of iterations before the algrthm haults 
%% Load original image and display it
X=imread(IMG_FILENAME);
figure('Name','Original Image'),imshow(X),title('Original Image')

%% Define motion, blur, noise and downsample parameters 
shift_x=[0 .5 .5 0]; 
shift_y=[0 .5  0 .5];

h=fspecial(BLUR_KERNEL);
h={h,h,h,h};

noise_var=5;

dwn=4;

%% Generate LR Observations and display them
Y=genObsSeq(X,shift_x,shift_y,h,noise_var,dwn);

figure('Name','LR Observations')
montage(reshape(Y,size(Y,1),size(Y,2),1,size(Y,3)));
title('LR Observations')

%% Run the Superresolution Algorithm
[XSR,Xinit,itr_data]=GNC(Y,PRIOR,MAX_ITR,DISP_FLAG,...
                        shift_x,shift_y,h,noise_var,dwn);

%% Calculate PSNR of different ROI's as well as the whole image
X=im2double(X);

%Original image/Superresolved image/Initial guess
bckgrnd=X(1:50,1:50);    
bckgrndSR=XSR(1:50,1:50);           
bckgrndinit=Xinit(1:50,1:50); 

grass=X(end-49:end,end-49:end); 
grassSR=XSR(end-49:end,end-49:end);  
grassinit=Xinit(end-49:end,end-49:end); 

camera=X(60:84,132:170);       
cameraSR=XSR(60:84,132:170);        
camerainit=Xinit(60:84,132:170);

face=X(57:80,107:132);          
faceSR=XSR(57:80,107:132);           
faceinit=Xinit(57:80,107:132); 

peakval=1;
PSNR_bckgrnd=PSNR(bckgrnd,bckgrndSR,peakval)
PSNR_grass=PSNR(grass,grassSR,peakval)
PSNR_camera=PSNR(camera,cameraSR,peakval)
PSNR_face=PSNR(face,faceSR,peakval)
PSNR_wholeimage=PSNR(X,XSR,peakval)

%% Calculate the ISNR and plot it
isnr=ISNR(X,Xinit,itr_data);
n_itr=1:size(itr_data,3)+1; % +1 to account for initial guess
figure('Name','ISNR as a Function of Iteration Number')
plot(n_itr,isnr),title('ISNR as a Function of Iteration Number')
xlabel('n'),ylabel('ISNR [dB]')
