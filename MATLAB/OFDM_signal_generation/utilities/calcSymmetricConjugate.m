function symmetric_conjugate = calcSymmetricConjugate(INPUT)
% CALCSYMMETRICCONJUGATE function to generate a matrix where each column is a
% symetric conjugate array of the columns in INPUT.
%   The number of rows in each column will be 2+(2*(number of rows per col
%   in input))

    row_zeros = zeros(1,size(INPUT,2));
    
%     reverse for symmetry about 0, and conjugate
    reversed_conjugate = conj(INPUT(end:-1:1,:));

%     Row of zeros for N/2 and 0 frequency
    symmetric_conjugate = [row_zeros;reversed_conjugate;row_zeros;INPUT];

end