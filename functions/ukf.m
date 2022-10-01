function [ xhat_new, P_new, g_k] = ukf( f, h, B, b, xhat, y, u, P, Q, R, kappa)

N = length( xhat);
M = length( y);

%% �V�O�}�|�C���g�v�Z

sqrt_P = chol( P).';

X_km1 = [ xhat      xhat*ones(1,N) + sqrt( N + kappa)*sqrt_P        xhat*ones(1,N) - sqrt( N + kappa)*sqrt_P];

w_vec = [ kappa/(N + kappa);
          1/(2*(N + kappa))*ones(2*N,1)];

      
      
%% �\���X�e�b�v

%%[0] �V�O�}�|�C���g�X�V
Xm_k = zeros(N,2*N+1);
for ii = 1:(2*N+1)
    Xm_k(:,ii) = f( X_km1(:,ii)) + B*u;
end

%%[1] ���O��Ԑ����
xhat_m_k = Xm_k*w_vec;

%%[2] ���O�덷�����U�s��
w_mat1 = repmat( permute( w_vec, [ 3 2 1]), [ N N 1]);
Xm_k_m_xhat_m_k = repmat( permute( (Xm_k - xhat_m_k*ones(1,2*N+1)), [ 1 3 2]), [ 1 N 1]);
Pm_k = sum( w_mat1.*Xm_k_m_xhat_m_k.*permute( Xm_k_m_xhat_m_k, [ 2 1 3]), 3) + b*Q*b.';

%%[3] �V�O�}�|�C���g�Čv�Z
sqrt_Pm_k = chol( Pm_k).';

Xm_k = [ xhat_m_k      xhat_m_k*ones(1,N) + sqrt( N + kappa)*sqrt_Pm_k        xhat_m_k*ones(1,N) - sqrt( N + kappa)*sqrt_Pm_k];

%%[4] �o�̓V�O�}�|�C���g�̍X�V
Ym_k = zeros(M,2*N+1);
for ii = 1:(2*N+1)
    Ym_k(:,ii) = h( Xm_k(:,ii));
end

%%[5] ���O�o�͐���l
ym_k = Ym_k*w_vec;

%%[6] ���O�o�͌덷�����U�s��
w_mat2 = repmat( permute( w_vec, [ 3 2 1]), [ M M 1]);
Ym_k_m_ym_k = repmat( permute( (Ym_k - ym_k*ones(1,2*N+1)), [ 1 3 2]), [ 1 M 1]);
Pm_yy_k = sum( w_mat2.*Ym_k_m_ym_k.*permute( Ym_k_m_ym_k, [ 2 1 3]), 3);

%%[7] ���O��ԁE�o�͌덷�����U�s��
w_mat3 = repmat( permute( w_vec, [ 3 2 1]), [ N M 1]);
Xm_k_m_xhat_m_k2 = repmat( permute( (Xm_k - xhat_m_k*ones(1,2*N+1)), [ 1 3 2]), [ 1 M 1]);
Ym_k_m_ym_k2 = repmat( permute( (Ym_k - ym_k*ones(1,2*N+1)), [ 1 3 2]), [ 1 N 1]);
Pm_xy_k = sum( w_mat3.*Xm_k_m_xhat_m_k2.*permute( Ym_k_m_ym_k2, [ 2 1 3]), 3);


%%[8] �J���}���Q�C��
g_k = Pm_xy_k*inv( Pm_yy_k + R);


%% �t�B���^�����O�X�e�b�v

%%[0] ��Ԑ���l
xhat_new = xhat_m_k + g_k*(y - ym_k);

%%[1] ����덷�����U�s��
P_new = Pm_k - g_k*Pm_xy_k.';

end

