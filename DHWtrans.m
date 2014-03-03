function [y] = DHWtrans(x,shft_x,shft_y,h,dwn_m,dwn_n)
%DHWtrans - Conceptually performs (DHW)^T{x}, where D is a down sample
%           matrix, H is a blur matrix, and W is a warp matrix.
%function [ y ] = DHWtrans(x,shft_x,shft_y,h,dwn_m,dwn_n)
%function [ y ] = DHWtrans(x,shft_x,shft_y,h,dwn)

switch(nargin)
    case 6
         y=WarpT(Htrans(Dtrans(x,dwn_m,dwn_n),h),shft_x,shft_y);
    case 5
         y=WarpT(Htrans(Dtrans(x,dwn_m),h),shft_x,shft_y);
end
end