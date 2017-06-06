%单点变异操作
%pop_size: 种群大小
%chromo_size: 染色体长度
%cross_rate: 变异概率
function mutation(pop_size, chromo_size, mutate_rate)
global pop;
global G;
fprintf('generation %d procedure:mutation\n',G);
for i=1:pop_size
    if rand < mutate_rate
        mutate_pos = round(rand*chromo_size);
        if mutate_pos == 0
            continue;
        end
        fprintf('index %d mutation pos: %d\n',i,mutate_pos);
        pop(i,mutate_pos) = 1 - pop(i, mutate_pos);
    end
end