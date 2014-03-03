function [y] = DHW(x,shft_x,shft_y,h,dwn_m,dwn_n)
%DHW - Generates a blurred, warped, and downsampled image from an original 
%      image,x.
%Conceptually performs DHWx, where D is a down sample matrix, H is a
%blur matrix,W is a warp matrix.
%function [ y ] = DHW(x,shft_x,shft_y,h,dwn_m,dwn_n)
%function [ y ] = DHW(x,shft_x,shft_y,h,dwn)

switch(nargin)
    case 6
         y=D(H(Warp(x,shft_x,shft_y),h),dwn_m,dwn_n);
    case 5
         y=D(H(Warp(x,shft_x,shft_y),h),dwn_m);
end
end