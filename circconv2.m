function [ b ] = mycircconv2( a,h )
%  circularly convolve a with h
%  result is same size as a
%  treats the center of h as the origin


b=zeros(size(a)); 

%find the origin of h
midpoint(1)=ceil(size(h,1)/2);
midpoint(2)=ceil(size(h,2)/2);

h=rot90(rot90(h));

%circularly extend a
right=a(:,1:midpoint(2)-1);
left=a(:,end-(midpoint(2)-1)+1:end);
a=[left a right];
bottom=a(1:midpoint(1)-1,:);
top=a(end-(midpoint(1)-1)+1:end,:);
a=[top;a;bottom];


for ii=0:size(b,1)-1
    for jj=0:size(b,2)-1
        b(ii+1,jj+1)=sum(sum(h.*a(ii+1:ii+size(h,1),jj+1:jj+size(h,2))));
    end
end

end



