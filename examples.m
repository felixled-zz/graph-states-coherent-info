% Examples for computing the coherent information of graph states using the
% MATLAB routine 'pauli_action.m', taken from the paper "Error Thresholds
% for Arbitrary Pauli Noise", Johannes Bausch and Felix Leditzky,
% arXiv:xxxx.xxxxx

%% CI of a repetition code on 5 system qubits (see eq.20 in [BL19]) under depolarizing noise.

G = zeros(6);
G(1,2:6) = 1;
G = G + G';

p = 0.19;

ci_rep5 = pauli_action(G,p,5,1);
plot(graph(G))
disp(['5-repetition code, p = ',num2str(p),': CI = ',num2str(ci_rep5)])
fprintf('\n')

%% the same for p_{0.1} with random (p_1,p_2,p_3):

q = rand(1,3); q = q/sum(q);
p = [0.9,0.1*q];

ci_rep5 = pauli_action(G,p,5,1);
plot(graph(G))
disp(['5-repetition code, p = (',num2str(p(1)),',',num2str(p(2)),',',num2str(p(3)),',',num2str(p(4)),...
    '): CI = ',num2str(ci_rep5)])
fprintf('\n')

%% Shor code (see eq.(35) in [BL19]) under depolarizing noise.

Gs = zeros(10);
Gs(1:3,[4,7,10]) = 1;
Gs(4,5:6) = 1;
Gs(7,8:9) = 1;
Gs = Gs + Gs';
plot(graph(Gs))

p = 0.19;
% We now precompute the U subsets since we need them later as well.
U9 = get_U_subsets(9,1);

ci_shor = pauli_action(Gs,p,9,1,U9);
disp(['Shor code, p = ',num2str(p),': CI = ',num2str(ci_shor)])
fprintf('\n')

%% Compare the 5-repetition code and the Shor code in the high-noise regime of
% the depolarizing channel.

p = linspace(0.18,0.2,100);
U5 = get_U_subsets(5,1);

for j=1:100
    disp(['Iteration: ',num2str(j)])
    ci(j,:) = [pauli_action(G,p(j),5,1,U5),pauli_action(Gs,p(j),9,1,U9)];
end
plot(p,ci),legend('5-rep','Shor')
fprintf('\n')

%% Compare random graph states on k=9 system vertices and r=5 environment vertices to repetition code

q = rand(1,3); q = q/sum(q);
x = 0.2;
p = [1-x,x*q];

k = 9;
r = 5;
n = k+r;

U = get_U_subsets(9,5);

% create random binary matrix
G1 = randi(2,n,n)-1;
% take the upper triangular part (without the diagonal) and symmetrize to
% get valid adjacency matrix of a graph
G1 = triu(G1,1); G1 = G1 + G1';
ci_rand1 = pauli_action(G1,p,k,r,U);

G2 = randi(2,n,n)-1;
G2 = triu(G2,1); G2 = G2 + G2';
ci_rand2 = pauli_action(G2,p,k,r,U);

G3 = randi(2,n,n)-1;
G3 = triu(G3,1); G3 = G3 + G3';
ci_rand3 = pauli_action(G3,p,k,r,U);

Grep = zeros(n,n);
Grep(1,2:10) = 1; 
Grep(10,11:end) = 1;
Grep = Grep + Grep';
ci_rep9 = pauli_action(Grep,p,k,r,U);

disp(['Random graphs for p = (',num2str(p(1)),',',num2str(p(2)),',',num2str(p(3)),',',num2str(p(4)),'):'])
disp(['CI1 = ',num2str(ci_rand1)])
disp(['CI2 = ',num2str(ci_rand2)])
disp(['CI3 = ',num2str(ci_rand3)])
disp('Repetition code:')
disp(['CIrep = ',num2str(ci_rep9)])