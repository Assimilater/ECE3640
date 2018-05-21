clear all;
a = [1, -1, -1];
b = 1;
N = 0:100;

% delta function
x = zeros(101, 1);
x(1) = 1;

% impulse response
h = filter(b, a, x);

figure;
dsplot(h, 'filter(b, a, delta(n))');
