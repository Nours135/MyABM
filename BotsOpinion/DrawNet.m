function a = DrawNet(mat, Speakout, Opinion)
    a = 0;
    Opinion = 2 * Opinion - 1;  % change 0 & 1 to -1 & 1 
    Condition = Speakout .* Opinion;
    N = size(mat);
    N = N(1);
    G = graph(mat);
    %figure();

   
    %map=[1 0 0;0 0 1;1 1 1]; % 红蓝黑
    color = zeros(N, 3);
    color(1:N, 1) = (Condition == 1);% | (Condition == 0); % positive -> red
    color(1:N, 3) = (Condition == -1);% | (Condition == 0); % negative -> blue
    colormap(color)
    p = plot(G, 'MarkerSize', 10 , 'Layout','force', 'NodeColor', color);

    posi_count = sum(Condition == 1);
    nega_count = sum(Condition == -1);
    muted_count = sum(Condition == 0);
    txt = ['posi:', num2str(posi_count), '. nega: ', num2str(nega_count), '. muted: ', num2str(muted_count)];
    text(-4.5, 4.5, txt)

end