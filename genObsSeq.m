function [y] = genObsSeq(x,shft_x,shft_y,h,noise_var,dwn_m,dwn_n)
%GENOBSSEQ - Generates a sequence of blurred, warped, noisy,and downsampled
%            observation images,y,from an original image,x.
%Conceptually performs DH_rW_rx+n_r, where D is a down sample matrix, H_r 
%is a blur matrix for the rth observation image, W_r is a warp matrix for 
%the rth observation image, and n_r is a noise vector for the rth 
%observation image.
%function [ y ] = GenObsSeq(x,shft_x,shft_y,h,noise_var,dwn_m,dwn_n)
%function [ y ] = GenObsSeq(x,shft_x,shft_y,h,noise_var,dwn)
%Note: shft_x, shft_y are vectors of length r. h is a cell of blur kernels.
%      noise_var, dwn_m, dwn_n  are scalars.  

im_class=class(x); 

if nargin==6
    dwn_m=sqrt(dwn_m);dwn_n=dwn_m;
end
   
nObs=length(shft_x); % number of observation images
sz=size(x);          % size of original image x
y=zeros(sz(1)/dwn_m,sz(2)/dwn_n,nObs,im_class);

for r=1:nObs
    y(:,:,r)=imGen(x,shft_x(r),shft_y(r),h{r},noise_var,dwn_m,dwn_n);
end

end