function XKnife_QA
% a convinient method to assure the coaxis of the cone and the iso center
%

close all;
clear all;

% read image
I=imread('phi30-270.bmp');
sample=double(rgb2gray(I));
% smooth the noise
kernel=fspecial('gaussian');
sample=imfilter(sample,kernel);
imshow(sample,[]);
% detect the big circle
big=sample>200;
% remove small part
big=bwareaopen(big,20);

boundary=edge(big,'canny');
[x y]=find(boundary);
points=[x y];
% fit the circle and view it
[c r]=circlefit(points);
viscircles(c',r,'Color','b');
scale=15/r;
% detect the small white circle
small=sample>110;
% figure,imshow(small,[]);
% edge detect
s=edge(small,'canny');

[sc,sr]=imfindcircles(s,[5 50]);
viscircles(sc(1,:),sr(1,:),'Color','r');
%text(150,150,sprintf('Center distance is: %d mm',pdist2(c',sc(1,:)*scale,'euclidean')));
text(150,180,sprintf('X-Direciton deviation is: %d mm(Cone to iso-center)',(c(1,1)-sc(1,1))*scale));
text(150,210,sprintf('Y-Direciton deviation is: %d mm(Cone to iso-center)',(c(2,1)-sc(1,2))*scale));
axis on
end

function [center,radius]=circlefit(data)
% fitting a circle from a data set(nx3)
% using least square method.

A=[data(:,1) data(:,2) ones(size(data,1),1)];
b=-(data(:,1).^2+data(:,2).^2);
x=A\b;
center=-0.5*(x(1:2));
radius=sqrt(center(1).^2+center(2).^2-x(3));

end



