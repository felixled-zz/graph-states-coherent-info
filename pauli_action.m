% Compute the coherent information of a Pauli channel (p0,p1,p2,p3) acting
% on a graph state |G>.
% 
% Input: 
% G ... Adjacency matrix of a simple undirected graph on n = k + r vertices 
%       (must be symmetric and only contain 0's and 1's). 
% p ... Probability vector (p0,p1,p2,p3) of length 4. 
%       Can also be a single number, in which case p = [1-p,p/3,p/3,p/3] is the depolarizing channel with probability p. 
% k ... Number of system vertices. 
% r ... Number of environment vertices. 
% U_array (optional) ... 
%       Array of auxiliary matrices used in the computation that can be
%       obtained using the routine get_U_subsets (supplied with code).
% 
% Output: 
% cI ... Coherent information of the state sigma_RB obtained from a
%        Pauli channel acting on the graph state |G>. 
% lambda ... Coefficient vector of the diagonal joint state sigma_RB. 
% lambda_a ... Coefficient vector of the diagonal marginal state sigma_B.
% 
% This code is based on Algorithm 1 of the paper 
%
% "Error Thresholds for Arbitrary Pauli Noise", J. Bausch and F. Leditzky, arXiv:1910.00471 
% 
% (c) 2019, Felix Leditzky.

function [cI,lambda,lambda_a] = pauli_action(G,p,k,r,U_array)
if (length(p)~=4)
    % If p is a single probability, we default to the depolarizing channel.
    if (length(p)==1)
        assert(0<=p&&p<=1,'p must be a probability, i.e., a real number between 0 and 1.');
        p = [1-p,p/3,p/3,p/3];
    else
        error('p-vector has wrong length!')
    end
end

% If U_array is not provided, we obtain it from the auxiliary function
% get_U_subsets.
if (nargin < 5)
    U_array = get_U_subsets(k,r);
end

p0 = p(1);
q1 = p(2)/p0;
q2 = p(3)/p0;
q3 = p(4)/p0;

assert(min(min(G==G'))==1,'Adjacency matrix of a graph must be symmetric.')
n = length(G);
assert(n==r+k,'Number of channel + purifying qubits does not match number of graph vertices.');

[~,U1,U2,U3,u1,u2,u3,A_sub,B_sub] = U_array{:};

U = mod(G*(U1+U2)+U2+U3,2);
Ua = U(1:k,:);

coeff_ind = bi2de(U','left-msb')'+1;
coeff_ind_a = bi2de(Ua','left-msb')'+1;
coeff = (q1.^u1).*(q2.^u2).*(q3.^u3);

lambda = zeros(1,2^n);
lambda_a_tmp = zeros(1,2^k);
mult = zeros(size(lambda));
mult_a = zeros(size(lambda_a_tmp));
for j=1:length(coeff_ind)
    lambda(coeff_ind(j)) = lambda(coeff_ind(j)) + coeff(j);
    mult(coeff_ind(j)) = mult(coeff_ind(j)) + 1;
    lambda_a_tmp(coeff_ind_a(j)) = lambda_a_tmp(coeff_ind_a(j)) + coeff(j);
    mult_a(coeff_ind_a(j)) = mult_a(coeff_ind_a(j)) + 1;
end
lambda = lambda*p0^k;
lambda_a_tmp = lambda_a_tmp*p0^k;

Gab = G(1:k,k+1:n);
GabB = mod(Gab*B_sub,2);
lambda_a = zeros(size(lambda_a_tmp))';

for j=1:size(GabB,2)
    U_str = mod(GabB(:,j)+A_sub,2);
    U_ind = bi2de(U_str','left-msb')'+1;  
    lambda_a = lambda_a + lambda_a_tmp(U_ind)';
end
lambda_a = lambda_a'/2^r;
cI = (shannon_entropy(lambda_a)-shannon_entropy(lambda))/k;
end