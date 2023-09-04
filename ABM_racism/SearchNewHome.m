%%寻找新家的函数，从当前位置开始遍历寻找到最近的一个适合的家

function [i, j] = SearchNewHome(map, loc, race, SAMERATE)
    DISTANCE = 1; %搜寻的地址离原来家的距离
    TIRED = 0.001;  %搜寻的疲劳参数，对新家同族群的人的同质性要求，详见第17行代码
    MapSize = size(map);
    direction = [1,1;1,-1;-1,1;-1,-1];

    while 1
        for XDelta = 0:DISTANCE
            YDelta = DISTANCE - XDelta;
            for direc = 1:4
                i = loc(1) + XDelta*direction(direc,1);
                j = loc(2) + YDelta*direction(direc,2);
                if i > 0 && j > 0 && i <= MapSize(1) && j <= MapSize(2)  %坐标合法
                    if map(i, j) == 0  %是个空地
                        if cacuEthicRate(map, [i, j], race) >= (SAMERATE - (DISTANCE-1)*TIRED) %TIRED参数控制搜寻者逐渐疲劳，降低要求
                            %这个地方密度符合要求
                            return 
                        end
                    end
                end
            end

        end
        DISTANCE = DISTANCE + 1;
    end

end