%%计算一个坐标的周围邻居中与自己族群相同的人的比例
function rate = cacuEthicRate(map, loc, race)
    SearchRange = 2; %考虑左右各多少个格子距离

    maxSize = size(map);
    same = 0; diff = 0;
    for i = (loc(1)-SearchRange):(loc(1)+SearchRange)
        if i <= 0 || i > maxSize(1)
            continue  %跳过这种情况，这样写可读性高些，迭代不会那么深
        end
        for j = (loc(2)-SearchRange):(loc(2)+SearchRange)
            if j <= 0 || j > maxSize(2)
                continue
            end
            resi = map(i, j);
            if resi ~= 0
                if resi == race
                    same = same + 1;
                else
                    diff = diff + 1;
                end
            end    
        end
        
    end
    rate = (same - 1) / (same + diff - 1);  %把自己剔除掉
    return
end