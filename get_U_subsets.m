% Computes auxiliary matrices used in 'pauli_action.m' to compute the coherent information of a graph state under Pauli noise.
% 
% This code is based on the paper
%
% "Error Thresholds for Arbitrary Pauli Noise", J. Bausch and F. Leditzky, arXiv:1910.00471 
% 
% (c) 2019, Felix Leditzky.

function [U_array] = get_U_subsets(k,r,flag)

n = k+r;
num = 4^k;

try
    U1 = zeros(n,num);
catch
    U1 = sparse(n,num);
end
U2 = U1;
U3 = U1;
U0 = U1;
u1 = zeros(1,num);
u2 = u1;
u3 = u1;
if (nargin==3)
    disp('Computing sets Ui...')
end
for j=1:num
    if (nargin==3)
        if (mod(j,10000)==0)
            disp([num2str(j),'/',num2str(num)])
        end
    end
    % determine which qubit is in which set Ui
    % ui holds the number of elements in Ui
    vec = (dec2base(j-1,4,k)-'0')';
    U0(1:k,j) = (vec==0);
    U1(1:k,j) = (vec==1);
    u1(j) = nnz(vec==1);
    U2(1:k,j) = (vec==2);
    u2(j) = nnz(vec==2);
    U3(1:k,j) = (vec==3);
    u3(j) = nnz(vec==3);
end

subsets_k = zeros(k,2^k);
subsets_r = zeros(r,2^r);
for j=1:2^k
    subsets_k(:,j) = dec2bin(j-1,k)-'0';
    if (j<=2^r)
        subsets_r(:,j) = dec2bin(j-1,r)-'0';
    end
end

U_array = {U0,U1,U2,U3,u1,u2,u3,subsets_k,subsets_r};
end