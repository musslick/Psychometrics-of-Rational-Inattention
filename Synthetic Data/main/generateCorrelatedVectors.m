function vectors = generateCorrelatedVectors(nElements, nVectors, correlation)

n = nElements;
k = nVectors;
d = sqrt(nVectors);
Sigma = eye(nVectors, nVectors);

% set up Sigma
for row =1:k
    for col = 1:k
        row_block = ceil(row/d);
        col_block = ceil(col/d);
        if(row_block == col_block)
            if(row ~= col)
                Sigma(row, col) = correlation;
            end
        else
            Sigma(row, col) = 0;
        end
    end
end

X = getVectorSetFromSimilarityMatrix(Sigma, n);

% norm each column vector
for col = 1:size(X,2)
    n = norm(X(:, col));
    X(:, col) = X(:, col) / n;
end

vectors = X;

end