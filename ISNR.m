function [ isnr ] = ISNR(X,Xinit,itrData )
%ISNR - Takes the original image, the initial guess and the estimates of 
%       each iteration and returns the ISNR from initial guess to each 
%       iteration. Optionally plots the ISNR as a function of iteration
%       number.
%   function [ isnr ] = ISNR(Xinit,itrData )

itrData=cat(3,Xinit,itrData);
n_itr=size(itrData,3);
itrData=reshape(itrData,[],n_itr);
XX=repmat(X(:),1,n_itr);
isnr=20*log10(sum((X(:)-Xinit(:)).^2)./sum((XX-itrData).^2));
if nargout==0
    figure('Name','ISNR as a Function of Iteration Number')
    plot(1:n_itr,isnr),title('ISNR as a Function of Iteration Number')
    xlabel('n'),ylabel('ISNR [dB]')
end
end

