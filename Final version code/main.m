step=100;
start1=tic;
for i=1:step
    [circle_length,circle_number]=contour('graph1.csv',1,false);
end
stop1=toc(start1);

start2=tic;
for i=1:step
    [circle_length,circle_number]=contour('graph1.csv',0.1,false);
end
stop2=toc(start2);

start3=tic;
for i=1:step
    [circle_length,circle_number]=contour('graph2.csv',1,true);
end
stop3=toc(start3);

start4=tic;
for i=1:step
    [circle_length,circle_number]=contour('graph2.csv',0.1,true);
end
stop4=toc(start4);

start5=tic;
for i=1:step
    [a,b]=linescan('graph1.csv',1,5,false);
end
stop5=toc(start5);

start6=tic;
for i=1:step
    [a,b]=linescan('graph1.csv',0.1,5,false);
end
stop6=toc(start6);

start7=tic;
for i=1:step
    [a,b]=linescan('graph2.csv',1,5,true);
end
stop7=toc(start7);

start8=tic;
for i=1:step
    [a,b]=linescan('graph2.csv',0.1,5,true);
end
stop8=toc(start8);

stop1=stop1/step;
stop2=stop2/step;
stop3=stop3/step;
stop4=stop4/step;
stop5=stop5/step;
stop6=stop6/step;
stop7=stop7/step;
stop8=stop8/step;
clc