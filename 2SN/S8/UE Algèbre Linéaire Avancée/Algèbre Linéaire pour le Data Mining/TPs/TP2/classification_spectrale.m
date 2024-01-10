function clust = classification_spectrale(S, k, sigma)
    [n, p] = size(S); % Get the size of input matrix S
    A = zeros(n, n); % Initialize the affinity matrix A
    
    % Compute pairwise affinities between samples
    for i = 1:n
        for j = i+1:n
            A(i, j) = exp(-(norm(S(i, :) - S(j, :))^2)/(2 * sigma^2));
            A(j, i) = A(i, j); % A is symmetric, so assign the same value to its transpose
        end
    end
    
    Dr = diag(1./sqrt(sum(A))); % Compute the diagonal matrix Dr
    L = Dr * A * Dr; % Compute the Laplacian matrix L
    
    [vep, vap] = eig(L); % Compute the eigenvectors and eigenvalues of L
    [~, ind] = sort(diag(vap), 'descend'); % Sort eigenvalues in descending order
    X = vep(:, ind(1:k)); % Select the top-k eigenvectors corresponding to the largest eigenvalues
    
    Y = zeros(n, k); % Initialize the normalized matrix Y
    
    % Normalize the rows of X to obtain Y
    for i = 1:n
        som = sqrt(sum(X(i, :).^2)); % Compute the Euclidean norm of each row
        Y(i, :) = X(i, :) / som; % Normalize the row of X and assign it to Y
    end 
    
    clust = kmeans(Y, k); % Perform k-means clustering on the normalized matrix Y
end