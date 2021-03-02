tic
 
reader = vision.VideoFileReader('original.mp4');
viewer = vision.DeployableVideoPlayer;
 
 
while ~isDone(reader)
    z = step(reader);
    
    I = imadjust(z,[0.3 0.7],[]);
    %imshow(I);
    red = I(:,:,1);
    green = I(:,:,2);
    blue = I(:,:,3);
    
    a = red>0.75;
    b = (green<0.78) & (green>0.63);
    my_image1 = a & b;
    
    a = red > 0.8;
    b = green > 0.8;
    c = blue > 0.8;
    my_image2 = a & b & c;
    
    my_image = my_image1 + my_image2;
    PSF = fspecial('gaussian',7,10);
    Blurred = imfilter(my_image, PSF, 'symmetric', 'conv');
    BW2 = edge(Blurred,'canny');
    
    c = [137, 1202, 706, 604];
    r = [706, 706, 433, 436];
    BW = roipoly( BW2, c, r);
    just_lines =  BW & BW2;
    
    [H, T , R] = hough( just_lines );
    P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    lines = houghlines(just_lines,T,R,P);
    
    
    
    max_len = 0;
    
    if(length(lines)~=0) 
        ii = insertShape(z,'line',[lines(1).point1,lines(1).point2],'LineWidth',5);
    end
    
    for k = 2:length(lines)
      
      ii = insertShape(ii,'line',[lines(k).point1,lines(k).point2],'LineWidth',5); 
      len = norm(lines(k).point1 - lines(k).point2);
      if ( len > max_len)
         max_len = len;
      end
  
    end
        step(viewer, ii);
 
     
    
end
toc
