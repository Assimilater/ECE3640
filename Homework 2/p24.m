clear all;

x = load('djw6576.txt', '-ascii');
N = size(x, 1);

y1 = zeros(N, 1);
y2 = zeros(N, 1);
for n = 1:N
    % y1 = sum_(0)_(50){x[n-k]}/51
    for k = 0:50
        if (n - k > 0 && n - k <= N)
            y1(n) = y1(n) + x(n - k);
        end
    end
    y1(n) = y1(n) / 51;

    % y2 = sum_(-25)_(25){x[n-k]}/51
    for k = -25:25
        if (n - k > 0 && n - k <= N)
            y2(n) = y2(n) + x(n - k);
        end
    end
    y2(n) = y2(n) / 51;
end

figure;
subplot(3,1,1);
dsplot(x, 'x');
subplot(3,1,2);
dsplot(y1, 'y1');
subplot(3,1,3);
dsplot(y2, 'y2');

figure;
hold all;
plot(0:N-1, x, 'blue');
plot(0:N-1, y1, 'red');
plot(0:N-1, y2, 'green');
set(gca, 'FontSize', 16);
grid on;
