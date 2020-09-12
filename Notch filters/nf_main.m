%Noch filter testing
f = imread('FigP4.5(a)(HeadCT_corrupted).tif');
figure(1)
imshow(f)

%Use the spectrum of the image f and determine the centers of the nochs using the function pixval, 
%find the coordinates of the pulses (216,216), (236,256), (256,247), (256,266), (276,256), (296,296).
%Image dimensions: 512x512
Hnr = notchfilter('reject', 512, 512, [216 216; 236 256; 256 247; 256 266; 276 256; 296 296], 5, 10);
q = dftfilt(f,Hnr); %filters image f with a noch-stop filter
figure(3)
imshow(q,[]);
g = gscale(q); %Intensity scaling to 8-bit intensities (all intensities in the range [0 255])
figure(3)
imshow(g);

%Images need to be subtracted to compare with the Celan_image.tif (obtained by band-pass Butterworth filter)
g2 = imread('Clean_image.tif');
d = imsubtract(g,g2); %image difference
figure(4)
imshow(d,[]);

%With a noch-pass filter obtain a noise image
Hnp = 1 - Hnr; %Obtain a noch-pass filter
qn = dftfilt(f, Hnp); %Filters the image f with a noch-pass filter
figure(5)
imshow(qn,[]);


