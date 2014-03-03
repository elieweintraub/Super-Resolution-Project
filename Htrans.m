function [ b ] = Htrans( a,h )
% implements multiplication by H traspose (the transpose of the blurring
% matrix) in the image domain
im_class=class(a);
b=cast(circconv2(double(a),rot90(rot90(h))),im_class);

end

