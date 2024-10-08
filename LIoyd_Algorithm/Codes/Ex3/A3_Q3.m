clc
clear all

% Given pdf
pdf = @(x) 0.5 * exp(-abs(x));
func = @(x) x .* pdf(x);
N = [10, 20, 100];

for k = 1:length(N)

    % Initialize intervals and thresholds
    intervals = cell(1, N(k) + 1);
    t = zeros(1,N(k)+2);
    t(1) = -inf;
    t(2) = -(N(k)-1)/2;
    t(N(k)+2) = inf;
    intervals{1} = [t(1) , -(N(k)-1)/2];
    intervals{N(k) + 1} = [(N(k)-1)/2 , t(N(k)+2)];
    j = 2;
    for i = N(k):-2:-N(k)+3
        intervals{j} = [-(i-1)/2, -(i-3)/2];
        t(j+1) = -(i-3)/2;
        j = j+1;
    end

    % Initialize quantization levels
    quantization_levels = zeros(1,N(k)+1);
    for i = 1:N(k)+1
        quantization_levels(i) = integral(func, t(i), t(i+1)) / integral(pdf, t(i), t(i+1));
    end

    % Iterative process
    convergence_threshold = 1e-10;
    new_quantization_levels = zeros(1, N(k) + 1);

    while 1
        % Compute new thresholds
        t(2:N(k)+1) = (quantization_levels(1:end-1) + quantization_levels(2:end)) / 2;

        % Compute new quantization levels
        for i = 1:N(k)+1
            new_quantization_levels(i) = integral(func, t(i), t(i+1)) / integral(pdf, t(i), t(i+1));
        end
    
        % Convergence check
        if (max(abs(new_quantization_levels - quantization_levels)))^2 < convergence_threshold
            break;
        end
        
        quantization_levels = new_quantization_levels;
    end

    % Compute quantization intervals
    for i = 1:N(k)+1
        intervals{i} = [t(i), t(i+1)];
    end

    % Compute average quantization error
    avg_error = 0;
    for i = 1:N(k)+1
        D = @(x) (x - new_quantization_levels(i)).^2 .* pdf(x);
        avg_error = avg_error + integral(D, t(i), t(i+1));
    end

    fprintf('Results for N = %d\n', N(k));
    fprintf('Thresholds: %s\n', mat2str(t(2:N(k)+1)));
    fprintf('Quantization Levels: %s\n', mat2str(quantization_levels));
    fprintf('Quantization Intervals: ');
    for i = 1:length(intervals)-1
        fprintf('[%g, %g] , ', intervals{i}(1), intervals{i}(2));
    end
    fprintf('[%g, %g]\n', intervals{N(k)+1}(1), intervals{N(k)+1}(2));
    fprintf('Average Quantization Error : %e\n', avg_error);
    fprintf('\n')
end
