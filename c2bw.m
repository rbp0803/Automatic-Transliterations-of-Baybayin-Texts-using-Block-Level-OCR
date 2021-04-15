%============================================================================%
%Note:                                                                       %
%This is a subfunction from the Baybayin and Latin Script Recognition System % 
%(Baybayin_identifier.m) for converting the input rgb image into binary      %
%data using the modified kmeans function                                     %  
%----------------------------------------------------------------------------%

function [v1,v2]=c2bw(u)
u=im2double(rgb2gray(u));
[c,a] = kmeans_mod(u,2);
%c is now a binary image 
%a gives the intensity values of the two clusters
v1=(c==max(a(:))); %finding the background
v2=(c==min(a(:))); %finding the foreground
