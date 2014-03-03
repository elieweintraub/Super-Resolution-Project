function [grd_n]=grad_n(xhat,y,prior,gamma,...
                        shft_x,shft_y,h,noise_var,dwn_m,dwn_n)
%GRAD_N - Computes the gradient used in the GNC algorithm to find the MAP
%         estimate of the superresolved image
% For the prior either a DAMRF or a GMRF can be used

im_class=class(xhat);
xhat=double(xhat);

lambda=0.005;
sz=size(xhat);
nObs=length(shft_x);

if nargin==9
    dwn_m=sqrt(dwn_m);dwn_n=dwn_m;
end

dx1=[zeros(sz(1),1),xhat(:,2:end)-xhat(:,1:end-1)]; % x(i,j)-x(i,j-1)
dx2=[xhat(:,1:end-1)-xhat(:,2:end),zeros(sz(1),1)]; % x(i,j)-x(i,j+1)
dy1=[zeros(1,sz(2));xhat(2:end,:)-xhat(1:end-1,:)]; % x(i,j)-x(i-1,j)
dy2=[xhat(1:end-1,:)-xhat(2:end,:);zeros(1,sz(2))]; % x(i,j)-x(i+1,j)

switch prior
    case 'DAMRF'
        G_n=2*(dx1.*exp(-dx1.^2/gamma)+dx2.*exp(-dx2.^2/gamma)...
            +dy1.*exp(-dy1.^2/gamma)+dy2.*exp(-dy2.^2/gamma));
    case 'GMRF'
        G_n=2*(dx1+dx2+dy1+dy2);
end
        
G_n=cast(G_n,im_class); 

grd_n=zeros(sz,im_class);
for r=1:nObs
tmp=DHW(cast(xhat,im_class),shft_x(r),shft_y(r),h{r},dwn_m,dwn_n)-y(:,:,r);
grd_n=grd_n+DHWtrans(tmp,shft_x(r),shft_y(r),h{r},dwn_m,dwn_n);
end

grd_n=grd_n/noise_var+lambda*G_n;

end