%% 解析条件
tmax = 50;                                      %% 解析時間
dt = 5e-2;                                      %% 刻み時間
x0 = [ 0 0 0.1 0.05].';                        	%% 初期値
P0 = diag( [ 0.1 0.1 0.1 0.1]);                 %% E[(x-E[x])*(x-E[x])^T]: 誤差共分散行列
Q = 0e-0;                                      	%% E[v^T*v]: システム雑音の分散
R = 25e-4;                                      	%% E[w^T*w]: 観測雑音の分散
kappa = 0;                                      %% シグマポイント計算パラメータ

%% system parameter
%%[0] continuous time system
J = 1;
k = 1;
f =@( x)[ x(2);
          -1/J*x(3)*x(2) - 1/J*x(4)*sign( x(2)) - 1/J*k*x(1);
          0;
          0];
B = [ 0;
      1/J;
      0;
      0];
bd = [ 1;
       1;
       0;
       0];
C = [ 1 0 0 0];
ut = @( t)( 1.0);
 
%%[1] discrete time system
[ fd, Bd] = c2d_func( f, B, dt);
hd = @( x_k)( C*x_k);


