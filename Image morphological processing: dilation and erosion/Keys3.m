%Image Keys_3.tif --------------------------------------------------

f = imread('Keys_3.tif');
figure(17)
imshow(f);

se=strel('disk', 17);
f2 = imreconstruct(imerode(f,se),f);
figure(18)
imshow(f2);

f4 = imsubtract(f,f2);
figure(19)
imshow(f4)

se=strel('disk', 2);
g1 = imreconstruct(imerode(f4, se), f4);
figure(20)
imshow(g1);

f6 = imreconstruct(min(g1,f4),f4);
figure(21)
imshow(f6);

figure(22)
f7 = imsubtract(f6,f2);
imshow(f7);
