% PERMUTATION ENTROPY OF 10000 RANDOM NUMBERS
% Define the length of the data series and create random data between 0 and 1
data_length = 10000; % Adjust this to your desired data length
random_data = rand(1, data_length);

% Define the order (m) and sliding window size (N_w)
m = 2;
N_w = 512;

% Initialize an array to store permutation entropy values
permutation_entropy = zeros(1, data_length - N_w + 1);

% Calculate permutation entropy
for i = 1:(data_length - N_w + 1)
    % Extract the data within the sliding window
    window_data = random_data(i:i + N_w - 1);
    
    % Calculate permutations
    permutations = zeros(1, N_w - m + 1);
    for j = 1:(N_w - m + 1)
        [~, idx] = sort(window_data(j:j + m - 1));
        permutations(j) = idx(1);
    end
    
    % Calculate the permutation probabilities
    prob = histcounts(permutations, 1:(m+1)) / (N_w - m);
    
    % Calculate permutation entropy
    permutation_entropy(i) = -sum(prob .* log2(prob + (prob == 0)));
end

% Plot the data series
figure;
subplot(2, 1, 1);
plot(1:data_length, random_data)
xlabel('Time Index')
ylabel('Data Value')
title('Random Data Series')

% Plot the permutation entropy
subplot(2, 1, 2);
plot(1:(data_length - N_w + 1), permutation_entropy)
xlabel('Time Index')
ylabel('Permutation Entropy')
title('Permutation Entropy of Random Data (N_w = 512, m = 2')
ylim([0 2]);

% Adjust the figure layout
sgtitle('Random Data and Permutation Entropy')

%PERMUTATION ENTROPY PATTERN SEGMENT 3000-4000
%{
% Define the length of the data series
data_length = 10000;

% Create the original random data
original_data = rand(1, data_length);

% Define the segment [3000, 4000]
segment_start = 3000;
segment_end = 4000;

% Extract the original data within the specified segment
original_segment = original_data(segment_start:segment_end);

% Calculate the mean and variance of the original segment
mean_original = mean(original_segment);
variance_original = var(original_segment);

% Create a sine wave pattern with similar mean and variance
frequency = 1/1000; % Adjust the frequency to control the pattern
time = 1:(segment_end - segment_start + 1);
pattern = mean_original + sqrt(variance_original) * sin(2 * pi * frequency * time);

% Replace the original data in the segment with the sine wave pattern
modified_data = original_data;
modified_data(segment_start:segment_end) = pattern;

% Calculate permutation entropy for the modified data
m = 2;
N_w = 512;
permutation_entropy = zeros(1, data_length - N_w + 1);

for i = 1:(data_length - N_w + 1)
    window_data = modified_data(i:i + N_w - 1);
    permutations = zeros(1, N_w - m + 1);
    
    for j = 1:(N_w - m + 1)
        [~, idx] = sort(window_data(j:j + m - 1));
        permutations(j) = idx(1);
    end
    
    prob = histcounts(permutations, 1:(m+1)) / (N_w - m);
    permutation_entropy(i) = -sum(prob .* log2(prob + (prob == 0)));
end

% Plot the original and modified data
figure;
subplot(2, 1, 1);
plot(1:data_length, modified_data)
xlabel('Time Index')
ylabel('Data Value')
title('Modified Data Series with Sine Wave Pattern')

% Plot the permutation entropy for the modified data
subplot(2, 1, 2);
plot(1:(data_length - N_w + 1), permutation_entropy)
xlabel('Time Index')
ylabel('Permutation Entropy')
title('Permutation Entropy of Modified Data')
ylim([0 2]);
%}




