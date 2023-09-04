function [] = drawMap(map)
    map_size = size(map);
    im = zeros(map_size(1), map_size(2), 3);
    for i = 1:map_size(1)
        for j = 1:map_size(2)
            resident = map(i, j);
            switch resident
                case 0 %无人居住
                    im(i, j, 1) = 50;im(i,j,2) = 50; im(i,j,3) = 50; %颜色设置为白色
                case 1 %族群1，红色
                    im(i,j,1) = 50;
                case 2 %族群2，蓝色
                    im(i,j,3) = 50;
            end
        end
    end
    im2 = imresize(im,[map_size(1)*12, map_size(2)*12], "nearest");
    imshow(im2);
end