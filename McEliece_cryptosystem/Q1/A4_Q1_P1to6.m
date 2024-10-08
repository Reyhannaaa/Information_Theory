%% LFSR M-sequences
clc;
clear all;
m = 7; % number of cells
Nb = 2^m - 1; % period
pnSequence = comm.PNSequence('Polynomial',[7 4 0], 'SamplesPerFrame',Nb, 'InitialConditions',[1 1 1 0 1 1 0]);
v = pnSequence()'; % 127-bit M-sequence

N1 = sum(v == 1);
N0 = sum(v == 0);
% Check if N1 = N0 + 1
isEqual = (N1 == N0 + 1);

% Display the results
disp('The 127-bit M-sequence v(n) is:');
disp(v);
fprintf('Number of 1s (N1): %d\n', N1);
fprintf('Number of 0s (N0): %d\n', N0);
fprintf('Is N1 equal to N0 + 1? %d\n', isEqual);

runTable = countRuns(v);

% Calculate expected run counts for an ideal binary random sequence
Nt = length(v)/2;
expectedNR = Nt ./ (2.^(1:height(runTable)))';

% Add expected values to the table for comparison
runTable.Expected_ideal_NR = expectedNR;

% Display the table
disp(runTable);

% Convert to bipolar
v_bipolar = 2*v - 1; 
R = ifft(fft(v_bipolar).*conj(fft(v_bipolar))); % Non-normalized periodic autocorrelation

% Compute periodic autocorrelation function
N = length(v_bipolar);
Norm_autocorr = zeros(1, N);

for tau = -((N-1)/2):((N-1)/2)
    Norm_autocorr(tau + (N-1)/2 + 1) = sum(v_bipolar .* circshift(v_bipolar, -tau));
end

% Plot the periodic autocorrelation function
figure;
plot(-((N-1)/2):((N-1)/2), Norm_autocorr);
title('Periodic Autocorrelation Function R(\tau)');
xlabel('\tau');
ylabel('R(\tau)');
grid on;

% Verify properties
disp('R value at poit 0 is:');
disp(['R(0) = ' num2str(Norm_autocorr((N-1)/2 + 1))]); % R(0)


function [runTable] = countRuns(v)
    % Initialize variables
    currentVal = v(1);
    runLength = 1;
    maxRun = length(v); % Maximum possible run length
    runCount0 = zeros(maxRun, 1);
    runCount1 = zeros(maxRun, 1);

    % Loop through the sequence to count runs
    for i = 2:length(v)
        if v(i) == currentVal
            runLength = runLength + 1;
        else
            if currentVal == 0
                runCount0(runLength) = runCount0(runLength) + 1;
            else
                runCount1(runLength) = runCount1(runLength) + 1;
            end
            currentVal = v(i);
            runLength = 1;
        end
    end
    % Count the last run
    if currentVal == 0
        runCount0(runLength) = runCount0(runLength) + 1;
    else
        runCount1(runLength) = runCount1(runLength) + 1;
    end

    % Creating the table
    runTable = table((1:maxRun)', runCount0, runCount1, 'VariableNames', {'Run_Length', 'NR0', 'NR1'});
end
