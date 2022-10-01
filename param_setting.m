%% ��͏���
tmax = 50;                                      %% ��͎���
dt = 5e-2;                                      %% ���ݎ���
x0 = [ 0 0 0.1 0.05].';                        	%% �����l
P0 = diag( [ 0.1 0.1 0.1 0.1]);                 %% E[(x-E[x])*(x-E[x])^T]: �덷�����U�s��
Q = 0e-0;                                      	%% E[v^T*v]: �V�X�e���G���̕��U
R = 25e-4;                                      	%% E[w^T*w]: �ϑ��G���̕��U
kappa = 0;                                      %% �V�O�}�|�C���g�v�Z�p�����[�^

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


