%Superresolution Color Test Script
clc,clear, close all

IMG_FILENAME = 'peppers.png';   % image to superresolve
DISP_FLAG = 1;         % cntrls whether or not figures are displayed 
PRIOR = 'DAMRF';       % cntrls which prior the algorithm uses (DAMRF/GMRF) 
MAX_ITR = 80;         % max number of iterations before the algrthm haults 

%% Load original image and display it
X=imread(IMG_FILENAME);
X=imresize(X,.5);
R=X(:,:,1);G=X(:,:,2);B=X(:,:,3);
figure,imshow(X),title('Original Image')

%% Define motion, blur, noise and downsample parameters
shift_x=[0 .5 .5 0]; 
shift_y=[0 .5  0 .5];

h1=fspecial('motion'); h2=fspecial('gaussian',5,1);

h={h2,h2,h2,h2};

noise_var=5;
dwn=4;
%% Generate LR Observations
Y_R=genObsSeq(R,shift_x,shift_y,h,noise_var,dwn);
Y_G=genObsSeq(G,shift_x,shift_y,h,noise_var,dwn);
Y_B=genObsSeq(B,shift_x,shift_y,h,noise_var,dwn);

%% Run the superresolution algorithm on each channel seperately
[XSR_R Xinit_R]=GNC(Y_R,PRIOR,MAX_ITR,DISP_FLAG,...
                    shift_x,shift_y,h,noise_var,dwn);
[XSR_G Xinit_G]=GNC(Y_G,PRIOR,MAX_ITR,DISP_FLAG,...
                    shift_x,shift_y,h,noise_var,dwn);
[XSR_B Xinit_B]=GNC(Y_B,PRIOR,MAX_ITR,DISP_FLAG,...
                    shift_x,shift_y,h,noise_var,dwn);
imshow(cat(3,XSR_R,XSR_G,XSR_B))

%% Calculate PSNR
peakval=1;
B=im2double(B);R=im2double(R);G=im2double(G);
im1=[R G B];
im2init=[Xinit_R Xinit_G Xinit_B];
im2SR=[XSR_R XSR_G XSR_B];
PSNR_init=PSNR(im1,im2init,1)
PSNR_SR=PSNR(im1,im2SR,1)
