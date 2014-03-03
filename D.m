function [ b ] = D( a,m,n )
%implements downsampling matrix D in image domain
%   decimates image a by a factor of m*n. If n is left out decimates by m
%   returns decimated image b 

if nargin==2
    m=sqrt(m);n=m;
end
[imheight imwidth]=size(a); 
b=zeros(imheight/m,imwidth/n);

im_class=class(a);
a=double(a);
for ii=0:imheight/m-1
    mstart=ii*m+1;mend=(ii+1)*m;
    for jj=0:imwidth/n-1
        nstart=jj*n+1;nend=(jj+1)*n;
        b(ii+1,jj+1)=sum(sum(a(mstart:mend,nstart:nend)))/(m*n);
    end
end
b=cast(b,im_class);

end

