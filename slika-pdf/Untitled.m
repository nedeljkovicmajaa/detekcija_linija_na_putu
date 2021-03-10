%ucitavanje slike
first_picture = imread( '3.jpg' );
%imshow(first_picture);

%grayscale
grayscale_picture = rgb2gray( first_picture );


%median filter
grayscale_picture = imnoise( grayscale_picture, 'salt & pepper', 0.02 );
medianfilter_picture = medfilt2( grayscale_picture, [ 22, 22 ] );

%sobel filter (u ovom slucaju radi bolji posao od canny filtera)
sobel_picture = edge( medianfilter_picture, 'sobel' );

%detekcija okvira drugom bojom
second_picture = first_picture;
OV1 = first_picture(:,:,1);
OV2 = first_picture(:,:,2);
OV3 = first_picture(:,:,3);
OV1( sobel_picture ) = 255;
OV2( sobel_picture ) = 0;
OV3( sobel_picture ) = 0;
second_picture( :, :, 1 ) = OV1;
second_picture( :, :, 2 ) = OV2;
second_picture( :, :, 3 ) = OV3;

%imshow(second_picture);
%title('detektovan papir')

%projekcijska transformacija
a = [45 37;
    440 35;
    27 616;
    460 614];
b = [1 1;
    480 1;
    1 640;
    480 640];

tform3 = maketform( 'projective', a,b );
g3 = imtransform( second_picture, tform3 );
%figure,imshow( g3 )
%title('projekcijska transformacija')

%izdvajanje oivicenog oblika
J = imcrop(g3, [63 52  468 625]);
%figure, imshow(J)
%title('Izdvojen papir')

%prebacivanje u jpg format
grayscale_picture2 = rgb2gray( J );
grayscale_picture2 = imnoise( grayscale_picture2, 'salt & pepper', 0.00001 );
third_picture = imbinarize(grayscale_picture2,'adaptive','ForegroundPolarity','dark','Sensitivity',0.45);
%figure,imshow(third_picture)
%title('binarizacija')

%jpg to pdf

%1)  print '-PPDF Printer' myfilename.pdf

saveas(gcf, ['novo.pdf'])
