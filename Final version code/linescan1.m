data=loadcsv('graph1.csv');
figure('position',[50,50,600,600])
hold on;box on;clc
picture = polyshape(data(:,1), data(:,2));
plot(picture)
hatching_length = 0;line_numbers=0;d=1;eps=3;
target = polybuffer(picture,-d);
current_points_x = target.Vertices(:,1);
current_points_y = target.Vertices(:,2);
xmin = min(current_points_x); xmax = max(current_points_x);
ymin = min(current_points_y); ymax = max(current_points_y);
% 求扫描线与图形的交点，保存在cell数组 x，y中
% x{i} 表示的是第i条扫描线与图形的交点集合
% y{i} 与x{i}类似，存储纵坐标
for i = 1:length(ymin:d:ymax)
    scanline_x = [xmin, xmax];
    scanline_y = [ymin+(i-1)*d,ymin+(i-1)*d];
    % 获取交点
    % 线段 (xmin,ymin+(i-1)*d) ---- (xmax,ymin+(i-1)*d) 与图形的交点
    % 使用cell数组来保存结果
    [x{i},y{i}] = polyxpoly(scanline_x, scanline_y, current_points_x,current_points_y);
    % 对交点坐标进行排序
    [x{i}, ind] = sort(x{i});
    y{i} = y{i}(ind);
    if (length(x{i})>2) && (mod(length(x{i}),2)==0) 
        % 相邻两个数字组成一列，这两个数字代表的是一条直线，
        x{i} = reshape(x{i},2,length(x{i})/2);
        y{i} = reshape(y{i},2,length(y{i})/2);
    end
end
% debug
% spider_x=x;
% spider_y=x;
i = 1;
while ~isempty(x)
    % Lx,Ly 表示的是plot的画图辅助数组，数组长度是折线的条数
    % Lx{i} Ly{i} 表示一条折线上的所有点
    Lx{i}(1:min(length(x{1}),2)) = x{1}(:,1);
    Ly{i}(1:min(length(x{1}),2)) = y{1}(:,1);
    for j = 2:length(x)
        % 取出当前折线的最后一个点
        x_end = Lx{i}(end); y_end = Ly{i}(end);
        % 得到当前扫描线与图形的所有交点
        Intersections_x = x{j}; Intersections_y = y{j};
        % 找到距离点擦(x_end,y_end)最近的点和其下标
        distance = sqrt((x_end-Intersections_x).^2 + (y_end-Intersections_y).^2);
        [mind, m] = min(distance,[],1);
        [mind, n] = min(mind,[],2);
        m = m(n);
        % 如果最小的距离不满足设置的最长斜边要求，则跳出循环
        if mind>eps*d; break; end
        if length(Lx{i})==1 % 如果只有一条线段
            if m>1 %如果距离最近的点是线段右端点，要先添加右端点，再添加左端点。
                Intersections_x(:,n) = flip(Intersections_x(:,n)); 
                Intersections_y(:,n) = flip(Intersections_y(:,n));
            end
        elseif Lx{i}(end)>Lx{i}(end-1) % 如果辅助数组末尾元素大于倒二元素，下一个线段要从右向左绘制，也就是说端点的横坐标顺序要倒序
            % 也就是说要添加的两个点要满足先添加的点大于后添加的点
            Intersections_x(:,n) = flip(Intersections_x(:,n));
            Intersections_y(:,n) = flip(Intersections_y(:,n));
        end
        % 将线段的两个端点横纵坐标加入到plot绘制数组中
        Lx{i}(end+1:end+length(Intersections_x(:,n))) = Intersections_x(:,n)';
        Ly{i}(end+1:end+length(Intersections_y(:,n))) = Intersections_y(:,n)';
        % 删掉 x{j}和y{j}的第n列，因为已经将其放进了plot绘制数组
        x{j}(:,n) = []; y{j}(:,n) = [];
    end
    % 删除cell数组中的第一个元素,并同步更新cell数组
    x{1}(:,1) = []; y{1}(:,1) = [];
    y(cellfun(@isempty,x)) = [];
    x(cellfun(@isempty,x)) = [];
    i = i + 1;
end
for i = 1:length(Lx)
    % diff 函数用于计算数组中相邻两个元素的差值用于计算所有线加起来的长度
    % 计算刻线长度和水平线数量
    hatching_length = hatching_length + sum(sqrt(diff(Lx{i}).^2 + diff(Ly{i}).^2));
    line_numbers=line_numbers+floor(length(Lx{i})/2);
    % 画出折线图
    plot(Lx{i}, Ly{i})
    title(['lines length:', num2str(hatching_length),' lines number:',num2str(line_numbers),' d:',num2str(d),' eps:',num2str(eps)])
end
% 清除matlab工作区，防止对第二次运行造成影响
clear Lx Ly