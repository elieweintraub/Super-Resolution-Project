function[X,Xinit,itr_data]=GNC(Y,prior,MAX_ITR,disp_flag,...
                               shft_x,shft_y,h,noise_var,dwn_m,dwn_n)
%function [X,Xinit,itr_data]=GNC(Y,prior,MAX_ITR,shft_x,shft_y,...
%                                h,noise_var,dwn_m,dwn_n)
% Implementation of GNC a deterministic annealing algorithm to find
% the MAP estimate of the superresolved image
%
% Returns:   X     - final est. of the image (i.e. the superresolved img)
%         Xinit    - initial guess of the algorithm
%         itr_data - est. of img after each iteration of the algorithm
%
% Note: the parameter disp_flag determines whether output is displayed in
%       the form of figures


%%%%%%%%%%%%%%%%  tunable parameters of the algorithm  %%%%%%%%%%%%%%%%%%%%
gamma=3000; gamma_target=100; k=.95; alpha=2.5; epsilon=.7; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Y=im2double(Y);

if nargin==9
    dwn_m=sqrt(dwn_m);dwn_n=dwn_m; 
end

%% Compute initial guess 
X=initguess(Y,shft_x,shft_y,dwn_m,dwn_n);

%If nargout>=2 store it
if nargout>=2
    Xinit=X;
end

% If disp_flag==1 display it
if disp_flag==1
    figure('Name','Initial Guess'),imshow(X),title('Initial Guess');
end

%If nargout==3 preallocate matrix for iteration data
if nargout==3 
    itr_data=zeros([size(X),MAX_ITR]);
end

%% Main Loop

Xdiff=zeros(size(X));

nrm=inf;
n=0;

while (nrm>=epsilon || gamma~=gamma_target) && n<MAX_ITR
   disp(['iteration: ' num2str(n) '...']) 
   
   Xdiff(:)=-alpha*grad_n(X,Y,prior,gamma,...
                         shft_x,shft_y,h,noise_var,dwn_m,dwn_n);  
   
   %Update estimate
   X=X+Xdiff;
   
   %Check for convergence at local minimum. If yes, relax gamma
   nrm=norm(Xdiff,'fro');
   if nrm<epsilon
       gamma=max(gamma_target,k*gamma);
   end
   
   %If disp_flag==1 display estimate of every 10th iteration
   if disp_flag==1 && (mod(n,10)==0 || gamma==gamma_target)
       figure,imshow(X),drawnow, title(['iteration ' num2str(n)]);
   end
   
   n=n+1;
   
   %If nargout==3 store iteration data
   if nargout==3
       itr_data(:,:,n)=X;
   end
   
end

%Remove extra preallocated space
if nargout==3 
    itr_data(:,:,n+1:end)=[];
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITGUESS-Calculates initial guess for GNC algorithm                    % 
% function [Xo]= initguess(Y,shft_x,shft_y,dwn_m,dwn_n)                   % 
%    Computes initial guess as the average of the realigned and upsampled %
%    observation images                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Xo]= initguess(Y,shft_x,shft_y,dwn_m,dwn_n)

im_class=class(Y);

[height_Y,width_Y, numObs]=size(Y);

height_X=height_Y*dwn_m;
width_X=width_Y*dwn_n;

X=zeros(height_X,width_X,numObs);

%Setup vectors for interpolation
xi_vec=linspace(1,width_Y,width_X); 
yi_vec=linspace(1,height_Y,height_X);

[x,y]=meshgrid(1:width_Y,1:height_Y);
[xi,yi]=meshgrid(xi_vec,yi_vec);

%realign the images and upsample them
for ii=1:numObs
    Y(:,:,ii)=Warp(Y(:,:,ii),-shft_x(ii),-shft_y(ii));
    X(:,:,ii)=interp2(x,y,double(Y(:,:,ii)),xi,yi,'linear',0);
end
%Compute the initial guess as the mean 
Xo=cast(mean(X,3),im_class);
end