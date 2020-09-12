 function H = notchfilter(type, M, N, CENTERS, RADII, ORDER) 
% NOTCHFILTER generates frequency domain notch filter.
% H = NOTCHFILTER (TYPE, M, N, CENTERS, RADII, ORDER) generates a Butterworth notch filters H, 
%with dimensions MxN, and K number of notch pairs. H may be band-pass or band-stop
%depend on which type "Type" is entered - 'pass' or 'reject'
% CENTER is a Kx2 array containing centers for each notch (required
% enter only one coordinate pair, the second, the symmetric, program generates itself). 
%RADII is a Kx1 array containing the corresponding radii for each noch. 
%If RADII is a scalar quantity, then the same radius is
% applied to all nochs. ORDER is a Kx1 array containing a Butterworth filter
%order for each notch. If ORDER is scalar, then the same order is applied to all nochs.
 
 %The filter equation for one pair of nochs located in (u0, v0) and (-u0, v0) is the expression of the Butterworth filter
 
 %                 1
 % HR = ---------------------------
 %                D0^2
 %    1 + [ --------------- ]^n
 %           D1(u,v)D2(u,v)
 
% where D1(u,v) = [(u + M/2 - u0)^2 + (v + N/2 - v0)^2]^1/2, and, similar,
% D2(u,v) = [(u - M/2 + u0)^2 + (v - N/2 + v0)^2]^1/2. This is the noch-stop filter because it weakens 
%the frequencies at the noch locations. The noch-pass filter is characterized by the expression HP = 1 - HR.
 
%The filter is not centered in a frequency rectangle, so to view it as image or grid plot, it must be centered with H = fftshift (H).
 
%If the locations of the noch filter are determined visually by analyzing
%the spectrum, it should be noted that the upper, the left corner is in coordinates (1,1). The transformation center is located at
%coordinates (u0, v0) = (floor (M / 2) + 1, floor (N / 2) + 1).

K = size(CENTERS,1); %obtains the number of noch pairs

if length(RADII) == 1
    RADII = RADII*ones(K,1);
end
if length(ORDER) == 1
    ORDER= ORDER*ones(K,1);
end

%generates a network grid array
[U,V] = dftuv(M,N);

%generates a noch-pass filter
H = zeros(M,N);
for i=1:K
    %the coordinates of the pair of nochs (two points) are obtained for each center of noch
    U1 = U - CENTERS(i,1) + M/2;
    V1 = V - CENTERS(i,2) + N/2;
    U2 = U + CENTERS(i,1) - M/2;
    V2 = V + CENTERS(i,2) - N/2;
    
    %squared distance arrays
    D1 = sqrt(U1.^2 + V1.^2);
    D2 = sqrt(U2.^2 + V2.^2);
    D0 = RADII(i); %radius from the center of the noch to either of the two symmetrical points
    H = H + (1-1./(1+(D0^2./(D1.*D2 + eps)).^ORDER(i)));
    
end

%converts H to a noch-stop filter if type 'reject' was entered
if strcmp(type,'reject')
    H = 1 - H;
end

%scale filter in range [0, 1]
H = H - min(H(:)); %minimum filter value 0
H = H./max(H(:)); %maximum filter value 1

 end
