%����������
%pop_size: ��Ⱥ��С
%chromo_size: Ⱦɫ�峤��
%cross_rate: �������
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