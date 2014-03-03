function [ im2 ] = Warp(im, shift_x,shift_y )
% WARP-translates an image by (shift_x,shift_y) using bilinear
%      interpolation for sub-pixel shifts
% function [ im2 ] = Warp(im, shift_x,shift_y )
sz=size(im);
sz_x=sz(2)+2;
sz_y=sz(1)+2;
im1=zeros(sz_y,sz_x);
im1(2:end-1,2:end-1)=im;
im_class=class(im);
[x,y]=meshgrid(1:sz_x,1:sz_y);
xi=x+shift_x;
yi=y+shift_y;
im2=cast(interp2(x,y,double(im1),xi,yi,'linear',0),im_class);
im2=im2(2:end-1,2:end-1);
end