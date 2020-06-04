function symmetric_conjugate = generateSymmetricConjugate(INPUT)
% generateSymmetricConjugate generate a matrix where each column is a
% symetric conjugate array of the columns in input
% 
% symmetric_conjugate = generateSymmetricConjugate(INPUT)
% 
%   INPUT: The RHS data of the conjugate array, each column is a separate
%   array
% 
%   symmetric_conjugate: The symmetric conjugated array

    row_zeros = zeros(1,size(INPUT,2));
    
%     reverse for symmetry about 0, and conjugate
    reversed_conjugate = conj(INPUT(end:-1:1,:));

%     Row of zeros for N/2 and 0 frequency
    symmetric_conjugate = [row_zeros;reversed_conjugate;row_zeros;INPUT];

end