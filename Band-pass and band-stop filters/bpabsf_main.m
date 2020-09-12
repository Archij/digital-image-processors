%size of filter
M = 600;
N = 600;
%radiuss
RADII = [50 200];
%bandwidth
WIDTH = [5 5];
%Butterworth filter order
ORDER = 20;
Hr = bandfilter('reject', M, N, RADII, WIDTH, ORDER);
Hp = bandfilter('pass', M, N, RADII, WIDTH, ORDER);
figure(1)
mesh(fftshift(Hr)) %draw a 3D surface for the band-stop filter
%use fftshift to center the filter
colormap(jet);
figure(2)
mesh(fftshift(Hp)) %draw a 3D surface for the band-pass filter
%use fftshift to center the filter
colormap(jet);

% save in tif format with a resolution of 300 DPI
print -f1 -dtiff -r300 D://bandreject_filter.tif
print -f2 -dtiff -r300 D://bandpass_filter.tif

%read the image and calculate its spectrum
figure(3)
f = imread('FigP4.5(a)(HeadCT_corrupted).tif');
imshow(f);
[M, N]  = size(f);
F = fft2(f); %obtain the 2D discrete Fourier transform of the image f
figure(4)
imshow(fftshift(log(1+abs(F))),[]); %get a spectrum that shows pulses
%center the spectrum with fftshift
imdistline; %determine the Euclidean distances from the coordinate center to each pulse
RADII = [57.98, 19.03, 9.22, 20.02, 56.59]; %radii (Euclidean distances) to the center of the bands
WIDTH = 3; %bandwidth
ORDER = 2; %"butter" filter order
Hr = bandfilter('reject', M, N, RADII, WIDTH, ORDER); %obtain a band-stop filter
fr = dftfilt(f, Hr); %filter the image f with a band-stop filter
figure(5)
imshow(fr,[]); %show the original image f, which is free of noise

Hp = 1 - Hr; %obtain a band-pass filter according to formula 1 - band-stop filter
fp = dftfilt(f, Hp); %filter the image f with a band-pass filter
figure(6)
imshow(fp,[]); %shows the noise image of the original image f



