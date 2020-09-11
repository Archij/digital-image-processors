function H = bandfilter(type, M, N, RADII, WIDTH, ORDER)

%The bandfilter function generates a band-pass or band-stop filter
%H = BANDFILTER(TYPE, M, N, RADII, WIDTH, ORDER)  generates
%the "butter" filter H, with dimensions MxN, and with a number of bands K.
%H is a band-pass or band-stop filter, depending on the type,
% which can be 'pass' or 'reject'
%RADII is a vector of length K containing radii (up to the center of the band)
%set for each band filter
%WIDTH is a vector of length K containing the bandwidth of each band
%If WIDTH is a scalar quantity, then the same width is applied to all bands
%ORDER is a vector of length K containing an order for a "butter" filter for each band
%If ORDER is scalar, then the same order is applied to all bands

%The equation uses the "butter" filter expression to implement the band-stopfilter
%
%                 1
%Hr = ---------------------------
%              D(u,v)W
%   1 + [ --------------- ]^2n
%         D(u,v)^2 - D0^2
%
%The band-pass filter is: Hbp = 1 - Hr.

H = zeros(M, N);
K = length(RADII); %Number of bands
if length(WIDTH) == 1 %If WIDTH is entered as a scalar quantity
    
   WIDTH = WIDTH*ones(K, 1); %Then for each band is assigned the same value of width
   
end
if length(ORDER) == 1 %If the "butter" filter order is a scalar size
    
    ORDER = ORDER*ones(K, 1); %Then for each band is assigned the same value of order
    
end
%Generates a network grid array
[U, V] = dftuv(M, N);
%Calculates the distance array
D = sqrt(U.^2 + V.^2);
%Generates a filter
K = length(RADII); %Number of bands
for i = 1:K %For each band
     W = WIDTH(i);
     D0 = RADII(i);
     n = ORDER(i);
     %Generates a band-pass filter
     H = H + (1 - 1./(1 + ((D*W)./(D.^2 - D0^2 + eps)).^2*n));
end
%Determines the filter type. If the type is not 'reject', then the filter is assumed to be band-pass
if strcmp(type, 'reject')
     H = 1 - H; % Band-stop filter
end
% Scale filter to be in range [0 1]
H = H - min(H(:)); %Subtract the smallest H element from each H element. As a result, the smaller value of the H matrix will be 0
H = H./max(H(:)); %Each H element is divided by the largest H element. As a result, the higher value of the matrix H will be 1

end