%% 复刻ABM的一个案例，居住

%% 参数初始化
MAPSIZE = 150;  %地图大小
DENSITY = 0.7; %密度，非空地的占比
EthicRate = 2.5; %族群1比2的比值
MAXITER = 100; %最大迭代次数

% 选择的参数，可调
SAMERATE = 0.4;   %附近居住的同族群人的最低占比，不包含空地


%% 变量初始化
map = zeros(MAPSIZE, MAPSIZE);
rng(now); %用当前时间设置随机种子
for i = 1:MAPSIZE*MAPSIZE
    %0表示空地，1表示族群1，2表示族群2
    r = rand();
    if r < DENSITY
        if r < (EthicRate / (EthicRate+1)) * DENSITY  %理论上可以优化，但是性能应该不会多耗太多，懒得了
            map(i) = 1;
        else
            map(i) = 2;
        end
    end
end
%% 绘制初始地图
drawMap(map);
pause(5); %暂停5秒

%% 进入迭代的while循环
change_count = 10000;
while change_count > 10 && MAXITER > 0
    change_count = 0;
    MAXITER = MAXITER - 1;
    fprintf("还剩迭代次数%d\n", MAXITER);
    for i = 1:MAPSIZE
        for j = 1:MAPSIZE
            switch map(i, j)
                case 0
                case 1
                    rate = cacuEthicRate(map, [i, j], 1); %计算同族群的比例
                    if rate < SAMERATE %选择搬家
                        change_count = change_count + 1; %记录下搬家人数（作为迭代依据）
                        [newi, newj] = SearchNewHome(map, [i, j], 1, SAMERATE);
                        map(i, j) = 0; map(newi, newj) = 1;
                    end

                case 2
                    rate = cacuEthicRate(map, [i, j], 2); %计算同族群的比例
                    if rate < SAMERATE %选择搬家
                        change_count = change_count + 1; %记录下搬家人数（作为迭代依据）
                        [newi, newj] = SearchNewHome(map, [i, j], 2, SAMERATE);
                        map(i, j) = 0; map(newi, newj) = 2;
                    end
            end


        end
    end
    drawMap(map);
    %pause(1);
end


