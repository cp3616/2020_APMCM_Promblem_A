data=loadcsv('graph2.csv');
% 处理数据
len=length(data);
data=[data(1:136,:);[nan,nan];data(137:351,:);[nan,nan];data(352:1546,:);[nan,nan];data(1547:len,:)];
figure('position',[100,100,600,600])
delta = 1;
distance=-1;
picture = polyshape(data);
picture.plot()
clc
fprintf('区域个数:%d 洞数:%d 边界数:%d\n',picture.NumRegions,picture.NumHoles,picture.numboundaries);
box on
% 旧图像与原图共存
hold on
internal_pic = picture;
step = 1;
hatching_length = 0;
circle_numbers=0;
title(['刻线长度 = ', num2str(hatching_length)])
colors=['y','m','c','r','g','b','w','k'];
while internal_pic.NumRegions
    internal_pic = polybuffer(picture,distance);
    hatching_length = hatching_length +  perimeter(internal_pic);
    plot(internal_pic,'FaceColor','green','FaceAlpha',0.1,'EdgeColor',colors(1+mod(step,length(colors))))
    step = step + 1;
    distance=distance-delta;
    circle_numbers=circle_numbers+internal_pic.numboundaries;
    title(['hatching length:', num2str(hatching_length),' circle number:',num2str(circle_numbers),' d:',num2str(delta)]);
    drawnow
end
fprintf('区域个数:%d 洞数:%d 边界数:%d\n',internal_pic.NumRegions,internal_pic.NumHoles,internal_pic.numboundaries);