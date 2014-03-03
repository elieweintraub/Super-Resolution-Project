function [y] = imGen(x,shft_x,shft_y,h,noise_var,dwn_m,dwn_n)
%IMGEN - Generates a blurred, warped, noisy, downsampled observation
%        image,y,from an original image,x.
%Conceptually performs DHWx+n, where D is a down sample matrix, H is a
%blur matrix,W is a warp matrix , and n is a noise vector.
%function [ y ] = imGen(x,shft_x,shft_y,h,noise_var,dwn_m,dwn_n)
%function [ y ] = imGen(x,shft_x,shft_y,h,noise_var,dwn)

if nargin==6
    dwn_m=sqrt(dwn_m);dwn_n=dwn_m;
end
    
im_class=class(x);
y=DHW(x,shft_x,shft_y,h,dwn_m,dwn_n);
y=cast(double(y)+sqrt(noise_var)*randn(size(y)),im_class);

end

