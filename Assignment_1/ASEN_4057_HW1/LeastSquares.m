function [ m,b ] = LeastSquares( x,y )
%Computes coefficients and constants for best fit line through data (x,y).
%Gives m and b for best fit line of form y=mx+b.
A = 0;
B = 0;
c = x.*y;
C = 0;
d = x.*x;
D = 0;
N = length(x);
for i=1:N
    A = A+x(i);
    B = B+y(i);
    C = C+c(i);
    D = D+d(i);
end

m = (A*B-N*C)/(A^2-N*D);
b = (A*C-B*D)/(A^2-N*D);
end

