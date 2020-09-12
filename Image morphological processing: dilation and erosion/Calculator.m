%Image Calculator_1.tif --------------------------------------------------

f = imread('Calculator_1.tif');
figure(1)
imshow(f);
f_obr = imreconstruct(imerode(f,ones(1,71)),f);

figure(2)
imshow(f_obr);

f_thr = imsubtract(f,f_obr);
figure(4)
imshow(f_thr);

g_obr = imreconstruct(imerode(f_thr, ones(1,11)), f_thr);
figure(6)
imshow(g_obr);

g_obrd = imdilate(g_obr, ones(1,2));
figure(7)
imshow(g_obrd);

f2 = imreconstruct(min(g_obrd,f_thr),f_thr);
figure(8)
imshow(f2);