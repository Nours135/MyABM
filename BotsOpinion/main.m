
%% 机器人在opinion climate形成中的作用，基于沉默螺旋理论 %%

%% Hyperparameters
clear;
% The generalised preferential attachment model described by Dorogovtsev, Mendes, and Samukhin
N = 100; % count of nodes (total)
Bots = 5;
% hyperpara
M = 6;
GAMMA = 2.5;

%% 1 network initialization
% network
degrees = zeros(N, 1);
edges_mat = zeros(N);
% generation
CurNode = 1;  % generated node count
attrative = zeros(N, 1); % nodes attractiveness score, supporting net generation
for node = 2:(N - Bots) % 
    % update degree
    degrees = sum(edges_mat, 2, 'default');
    % update attractivenes
    attrative(1:CurNode, 1) = M * (GAMMA - 2) + degrees(1:CurNode, 1);
    weights = attrative(1:CurNode, 1) ./ sum(attrative(1:CurNode, 1));
    re = randsample(CurNode, M, true, weights);
    % add egde in mat
    for i = 1:M
        edges_mat(re(i), node) = 1;edges_mat(node, re(i)) = 1;
    end
    CurNode = CurNode + 1;
end


%% 2 agent initialization
SelfCensor = unifrnd(0, 1, N, 1); % static
Opinion = zeros(N, 1); % static
OpinionDecide = unifrnd(0, 1, N, 1); 
posiCount = 0;
for agent = 1:(N - Bots)  % to control the amount of agents who hold the positive opinion strictly equals to N/2
    if OpinionDecide(agent, 1) > (0.5 - 0.1*(agent > 50)) && posiCount < N/2 - Bots
        Opinion(agent, 1) = 1;
        posiCount = posiCount + 1;
    end
    if posiCount >= N/2 - Bots
        break;
    end
end
%Opinion = 2 * Opinion - 1;  % change 0 & 1 to -1 & 1 

Confidence = unifrnd(0, 1, N, 1);
ConfidenceHidden = Confidence;



%% bots initialization
for bot = 0:(Bots-1)
    SelfCensor(N-bot, 1) = 0; % robots speak out anyway 
    Opinion(N-bot, 1) = 1; % robots support positive opinion
    
    % update degree
    degrees = sum(edges_mat, 2, 'default');
    % update attractivenes
    attrative(1:CurNode, 1) = M * (GAMMA - 2) + degrees(1:CurNode, 1);

    % robots' attach preference
    % (1) Preferential attachment
    weights = attrative(1:CurNode, 1) ./ sum(attrative(1:CurNode, 1));
    % (2) Inverse Preferential attachment
    %weights = 1 - (attrative(1:CurNode, 1) ./ sum(attrative(1:CurNode, 1)));
    %weights = weights ./ sum(weights);
    % (3) Random attachment
    %weights = ones(CurNode, 1) ./ CurNode;

    re = randsample(CurNode, M, true, weights);
    % add egde in mat
    for i = 1:M
        edges_mat(re(i), CurNode+1) = 1;edges_mat(CurNode+1, re(i)) = 1;
    end
    CurNode = CurNode + 1;
end


%% 4 iteration
SpeakOut = Confidence >= SelfCensor;
MaxIter = 30;

SpeakOutFormer = SpeakOut; % stop iteration
Stats = zeros(MaxIter, 3);  

for iter =1:MaxIter
    % cacluate opinion climate observed by each agent
    LocalOpinionClimate = zeros(N, 1);
    for agent = 1:N
        % retreive neighbours
        neighbours = edges_mat(1:N, agent);
        % have the same opinion as this agent
        SameOpinion = Opinion(agent, 1) == Opinion;
        SameOpinion = 2 .* SameOpinion - 1;  % change 0 & 1 to -1 & 1 
        
        environment = neighbours .* SpeakOut .* SameOpinion;  
        if sum(abs(environment)) == 0 % noboy speak out
            LocalOpinionClimate(agent, 1) = 0;
        else
            LocalOpinionClimate(agent, 1) = sum(environment)/sum(abs(environment));
        end
    end
    % update hidden confidence
    ConfidenceHidden = max(ConfidenceHidden + LocalOpinionClimate, 0);

    % sigmoid hidden confidence to obtain confidence
    Confidence = 2 ./ (1 + exp(-ConfidenceHidden)) - 1; 

    % update speakOut
    SpeakOutFormer = SpeakOut; 
    SpeakOut = Confidence >= SelfCensor;
   
    DrawNet(edges_mat, SpeakOut, Opinion);
    fprintf('iter %d. ', iter);
    %input('input anything for next iter: ')
    pause(1);

    if sum(SpeakOutFormer ~= SpeakOut) == 0 && iter > 15
        break
    end
end












