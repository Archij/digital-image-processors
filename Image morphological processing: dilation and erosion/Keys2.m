%Image Keys_2.tif --------------------------------------------------

f = imread('Keys_2.tif');
figure(9)
imshow(f);

se=strel('disk', 13);
f2 = imreconstruct(imerode(f,se),f);
figure(10)
imshow(f2);

f4 = imsubtract(f,f2);
figure(12)
imshow(f4)

se=strel('disk', 2);
g1 = imreconstruct(imerode(f4, se), f4);
figure(14)
imshow(g1);

f6 = imreconstruct(min(g1,f4),f4);
figure(15)
imshow(f6);

figure(16)
f7 = imsubtract(f6,f2);
imshow(f7);
