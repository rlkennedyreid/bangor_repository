

function symmetric_conjugate = generateSymmetricConjugate(input)

    row_zeros = zeros(1,size(input,2));
    reversed_conjugate = conj(input(end:-1:1,:));

    symmetric_conjugate = [row_zeros;reversed_conjugate;row_zeros;input];

end