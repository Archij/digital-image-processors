%impulsive noise ("salt" noise) removal with 5x5 median filter and 3x3 harmonic filter

s = imread('FigP5.2(a)(salt_only).tif');
figure(1)
imshow(s);
fsmed = spfilt(s,'median',5,5); %5x5 median filter
figure(2)
imshow(fsmed);
schmean = spfilt(s,'chmean',3,3,-5); %3x3 harmonic filter with degree Q = -5
figure(3)
imshow(schmean);

%impulsive noise ("pepper" noise) removal with 5x5 median filter and 3x3 harmonic filter

p = imread('FigP5.2(b)(pepper_only).tif');
figure(4)
imshow(p);
pmed = spfilt(p,'median',5,5);
figure(5)
imshow(pmed);
pchmean = spfilt(p,'chmean'); %default harmonic filter with dimensions 3x3 and degree Q = 1.5
figure(6)
imshow(pchmean);


%Impulsive noise ("salt and pepper" noise) removal with 9x9 adaptive median filter
figure(7)
imshow(s);
figure(8)
imshow(p);
sadaptmed = adpmedian(s, 9); %adaptive median filter with dimensions 9x9
sadaptmed = gscale(sadaptmed);
figure(9)
imshow(sadaptmed);
padaptmed = adpmedian(p, 9); %adaptive median filter with dimensions 9x9
padaptmed = gscale(padaptmed);
figure(10)
imshow(padaptmed);