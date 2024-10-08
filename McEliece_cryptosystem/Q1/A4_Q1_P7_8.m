%% Breaking a linear LFSR
clc
clear all
% The interception key is defien here
s = [1 0 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 0 1 1 1 1 0 1 0 0 1 1 1 0 0 1 0 0 0 0 1 0 1 0];

% Initializing by m = 3
m = 3;
found = false;

%% starting a loop to find the primitive polynomial
while ~found
    %% Cumputing the binary linear equation b=Ax
    b = s(2*m:-1:m+1)';   % extracting b matrix
 
    for k = 1:m   % extracting A matrix
        for j = 1:m
            a(k,j) = s(2*m-j-k+1);
        end
    end
    R = rank(gf(a));   % computing the rank of the binary matrix A
    [x,v] = gflineq(a,b,2);   % solving the binary linear equation b=Ax

    if v==1
        %% Checking if the successive bits in s are correct according to the current x matrix
        for i = (2*m+1):length(s)
            q = s(i-1:-1:i-m);
            q_gf = gf(q,2);
            x_gf = gf(x,2);
            test_gf = q_gf*x_gf;
            test = test_gf.x;
            if test ~= s(i)
                break
            end
        end
            %% if all bits are correct, compute the next 20-bit and display the outputs
            if i == length(s)
                primitive = [1; x];
                disp('The primitive polynomial is:');
                disp(primitive');
                disp('The polynomial degree is:');
                disp(m);
                
                % computing the next 20-bit
                for j = length(s)+1:length(s)+20
                    A = s(j-1:-1:j-m);
                    A_gf = gf(A,2);
                    next_gf = A_gf*x_gf;
                    s(j) = next_gf.x;
                end
                disp('The next generated 20 bits are:');
                disp(s(41:end));
                found = true;
            end
    end
    m = m+1;
end
