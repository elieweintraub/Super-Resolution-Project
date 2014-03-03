function [ b ] = H( a,h )
%implements blurring matrix H in image domain
im_class=class(a);
b=cast(circconv2(double(a),h),im_class);

end

