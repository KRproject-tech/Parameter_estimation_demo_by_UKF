function [ xhat_new, P_new, g_k] = ukf( f, h, B, b, xhat, y, u, P, Q, R, kappa)

N = length( xhat);
M = length( y);

%% シグマポイント計算

sqrt_P = chol( P).';

X_km1 = [ xhat      xhat*ones(1,N) + sqrt( N + kappa)*sqrt_P        xhat*ones(1,N) - sqrt( N + kappa)*sqrt_P];

w_vec = [ kappa/(N + kappa);
          1/(2*(N + kappa))*ones(2*N,1)];

      
      
%% 予測ステップ

%%[0] シグマポイント更新
Xm_k = zeros(N,2*N+1);
for ii = 1:(2*N+1)
    Xm_k(:,ii) = f( X_km1(:,ii)) + B*u;
end

%%[1] 事前状態推定量
xhat_m_k = Xm_k*w_vec;

%%[2] 事前誤差共分散行列
w_mat1 = repmat( permute( w_vec, [ 3 2 1]), [ N N 1]);
Xm_k_m_xhat_m_k = repmat( permute( (Xm_k - xhat_m_k*ones(1,2*N+1)), [ 1 3 2]), [ 1 N 1]);
Pm_k = sum( w_mat1.*Xm_k_m_xhat_m_k.*permute( Xm_k_m_xhat_m_k, [ 2 1 3]), 3) + b*Q*b.';

%%[3] シグマポイント再計算
sqrt_Pm_k = chol( Pm_k).';

Xm_k = [ xhat_m_k      xhat_m_k*ones(1,N) + sqrt( N + kappa)*sqrt_Pm_k        xhat_m_k*ones(1,N) - sqrt( N + kappa)*sqrt_Pm_k];

%%[4] 出力シグマポイントの更新
Ym_k = zeros(M,2*N+1);
for ii = 1:(2*N+1)
    Ym_k(:,ii) = h( Xm_k(:,ii));
end

%%[5] 事前出力推定値
ym_k = Ym_k*w_vec;

%%[6] 事前出力誤差共分散行列
w_mat2 = repmat( permute( w_vec, [ 3 2 1]), [ M M 1]);
Ym_k_m_ym_k = repmat( permute( (Ym_k - ym_k*ones(1,2*N+1)), [ 1 3 2]), [ 1 M 1]);
Pm_yy_k = sum( w_mat2.*Ym_k_m_ym_k.*permute( Ym_k_m_ym_k, [ 2 1 3]), 3);

%%[7] 事前状態・出力誤差共分散行列
w_mat3 = repmat( permute( w_vec, [ 3 2 1]), [ N M 1]);
Xm_k_m_xhat_m_k2 = repmat( permute( (Xm_k - xhat_m_k*ones(1,2*N+1)), [ 1 3 2]), [ 1 M 1]);
Ym_k_m_ym_k2 = repmat( permute( (Ym_k - ym_k*ones(1,2*N+1)), [ 1 3 2]), [ 1 N 1]);
Pm_xy_k = sum( w_mat3.*Xm_k_m_xhat_m_k2.*permute( Ym_k_m_ym_k2, [ 2 1 3]), 3);


%%[8] カルマンゲイン
g_k = Pm_xy_k*inv( Pm_yy_k + R);


%% フィルタリングステップ

%%[0] 状態推定値
xhat_new = xhat_m_k + g_k*(y - ym_k);

%%[1] 事後誤差共分散行列
P_new = Pm_k - g_k*Pm_xy_k.';

end


