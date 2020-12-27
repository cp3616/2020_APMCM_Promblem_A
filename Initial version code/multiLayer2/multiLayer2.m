%% 微信公众号：数学模型（MATHmodels�?%  联系方式：mathmodels@outlook.com 或添加微�? KingOfModels

clear; clc; close all
xy = load('graph2.dat');
figure('position',[50,50,400,600])
d = 1;
p0 = polyshape(xy);
p0.plot()
box on
hold on
set(gca,'YDir','reverse')
axis image;
pj = p0;
j = 1;
C = 0;
title(['length of hatching lines = ', num2str(C)])

while pj.NumRegions
    pj = polybuffer(p0,-d*j);
    C = C +  perimeter(pj);
    pj.plot()
    title(['length of hatching lines = ', num2str(C)]);
    
    j = j + 1;
    drawnow
    pause(0.5)
end
