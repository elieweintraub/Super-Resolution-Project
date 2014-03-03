function [ out ] = Dtrans( b,m,n )
% implements multiplication by D transpose (transpose of the downsampling
% matrix) in the image domain
% expands the matrix b by replicating pixel values in m*n blocks
% if n is left out, it expands in sqrt(m)*sqrt(m) blocks

if nargin==2
     m=sqrt(m);n=m;
end
im_class=class(b);
out=cast(kron(double(b),ones(m,n)),im_class);

end

