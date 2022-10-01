clc
clear all
close all hidden

%% delete
delete( '*.asv')

%% add path
add_pathes

%% initializing
initializing

%% parameter
param_setting


%% solve ODE
time_m = 0:dt:tmax;


i_time = 1;
hx = zeros(length( x0),length( time_m));
hy = zeros(length( hd( x0)),length( time_m));
hx(:,1) = x0;
for time = time_m(1:end-1)
   
    disp( time)
    
    x = hx(:,i_time);
    u = ut( time);
    
    v_noise = 0e-0*randn(1);
    w_noise = 5e-2*randn(1);
    
    x = fd( x) + bd*v_noise + Bd*u;
    y = hd( x) + w_noise;
    
    hx(:,i_time+1) = x;
    hy(:,i_time+1) = y;
    
    i_time = i_time + 1;
end



%% estimate parameter

i_time = 1;
P = P0;
hx_hat = 0*hx;
hy_hat = 0*hy;
xhat = 0*x0;
for time = time_m(1:end-1)
   
    disp( time)
    
    y = hy(:,i_time);
    u = ut( time);
    
    [ xhat, P, g_k] = ukf( fd, hd, Bd, bd, xhat, y, u, P, Q, R, kappa);
    hx_hat(:,i_time) = xhat;
    
    yhat = hd( xhat);
    hy_hat(:,i_time) = yhat;
    
    i_time = i_time + 1;
end


%% plot data

i_ax = 1;


h_fig(1) = figure( 1);
set( h_fig(1), 'Position', [ 10 100 600 400])
h_ax(i_ax) = axes( 'Parent', h_fig(1));

plot( h_ax(i_ax), time_m, hx(1,:), 'bo-', time_m, hx_hat(1,:), 'r^-')
xlabel( h_ax(i_ax), 'Time [-]')
ylabel( h_ax(i_ax), 'Angle [rad]')
grid( h_ax(i_ax), 'on')

legend( 'Simulated', 'Estimated')
i_ax = i_ax + 1;




h_fig(2) = figure( 2);
set( h_fig(2), 'Position', [ 610 100 600 400])
h_ax(i_ax) = axes( 'Parent', h_fig(2));

plot( h_ax(i_ax), time_m, hx(3,:), 'b-', time_m, hx(4,:), 'bo-', time_m, hx_hat(3,:), 'r-', time_m, hx_hat(4,:), 'ro-')
xlabel( h_ax(i_ax), 'Time [-]')
ylabel( h_ax(i_ax), 'Parameters [-]')
grid( h_ax(i_ax), 'on')

legend( 'Damping ', 'Friction parameter', 'Estimated damping parameter', 'Estimated friction parameter', 4)
i_ax = i_ax + 1;


h_fig(3) = figure( 3);
set( h_fig(3), 'Position', [ 1210 100 600 400])
h_ax(i_ax) = axes( 'Parent', h_fig(3));

plot( h_ax(i_ax), time_m, hy(1,:), 'b-', time_m, hy_hat(1,:), 'r--', 'LineWidth', 1)
xlabel( h_ax(i_ax), 'Time [-]')
ylabel( h_ax(i_ax), 'Output [-]')
grid( h_ax(i_ax), 'on')

legend( 'Simulated ', 'Estimated')
i_ax = i_ax + 1;


