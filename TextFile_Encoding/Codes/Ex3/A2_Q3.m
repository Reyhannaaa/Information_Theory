clc
clear all

N = [10,100,1000];
entropy_rate = zeros(1,numel(N));
avg_bits = zeros(1,numel(N));

%% starting the loop for different N
for i = 1:numel(N)
    p = zeros(1,N(i));
    symbols = 1:N(i);
    
%% Defining the probability for each N
    for n = 0:N(i)-1
        p(n+1) = 1/(1+(n^3));
    end
    probabilities = p/sum(p);

%% Creating the Huffman tree for each probability
    dict = huffmandict(symbols,probabilities);
    Huffman_tree = dict(:,2);

%% Calculating the entropy and avarage bit
    for j = 1:N(i)
        entropy_rate(i) = (probabilities(j)*log2(1/probabilities(j))) + entropy_rate(i);
        avg_bits(i) = (probabilities(j)*numel(Huffman_tree{j})) + avg_bits(i);
    end
end

%% Displaying the results
for k = 1:numel(N)
    X = sprintf('The entropy rate for N = %d is %g \n',N(k),entropy_rate(k));
    disp(X);
    Y = sprintf('The average number of bits per symbol for N = %d is %g \n',N(k),avg_bits(k));
    disp(Y);
end
