function [psnr, mse] = PSNR( im1,im2, peakval)
%function [psnr, mse] = PSNR( im1,im2, peakval)

im1=double(im1); im2=double(im2);
MSE=sum(sum((im1-im2).^2))/(size(im1,1)*size(im1,2));
psnr=mag2db(peakval/sqrt(MSE));

end

