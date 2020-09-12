
rgb = imread('lemons_2.jpg');
figure(1)
imshow(rgb);

I  = rgb2gray(rgb); %converts to the gray level image
figure(2)
imshow(I)

hy = fspecial('sobel'); %creates a Sobel filter
hx = hy'; %transposed matrix
Iy = imfilter(double(I), hy, 'replicate'); %filter with Sobel filter
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Ix.^2); %gradient
figure(3)
imshow(gradmag,[])


subt = double(I)-gradmag; %the gradient is subtracted from the original gray level image
figure(4)
imshow(subt);

bw = im2bw(I, graythresh(I)); %convert to binary image, for white pixels
%taking the pixels that are above the threshold determined by the graytresh function
figure(5)
imshow(bw)

er = imopen(subt,strel('disk',4)); %morphological opening with a disc-shaped structural element with radiuss 4
figure(6)
imshow(er)

bw = im2bw(er); %convert to binary image
figure(7)
imshow(bw)

BW2=imerode(bwareaopen(bw,500),strel('disk',4)); %Erosion to obtain a black space between the lemon white figure
BW2 = imfill(BW2,'holes'); %fills the formed black holes in lemon shapes
BW2=imerode(bwareaopen(BW2,500),strel('disk',3)); %continue erosion
figure(8)
imshow(BW2)

D = bwdist(BW2); %Euclidean distance image
figure(9)
imshow(D,[])
DL = watershed(D); %"Watershed" algorithm for obtaining boundaries from a binary, erosion processed image
bgm = DL == 0; %where the value is zero, there will be "watershed" lines
bgm = imdilate(bgm,strel('disk',1)); %creates the thickest borders
figure(10)
imshow(imcomplement(bgm)) %bgm suffix (binary value inverse)

R = rgb(:,:,1); %red band
G = rgb(:,:,2); %green band
B = rgb(:,:,3); %blue band
R(bgm) = 0; %for pixels that match the boundaries of the bgm image, set the values to 0 
%(put black borders on the original image)
G(bgm) = 0;
B(bgm) = 0;
figure(11)
Result(:,:,1) = R; %create RGB image
Result(:,:,2) = G;
Result(:,:,3) = B;
imshow(Result)
imwrite(Result,'lemons_2_Segmentets.jpg'); %save the segmentation result in .jpg format

