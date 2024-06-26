# Parameter_estimation_demo_by_UKF

**Communication**

<a style="text-decoration: none" href="https://twitter.com/hogelungfish_" target="_blank">
    <img src="https://img.shields.io/badge/twitter-%40hogelungfish_-1da1f2.svg" alt="Twitter">
</a>
<p>

**Language**
<p>
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/matlab/matlab-original.svg" width="60"/>
<p>


Parameter estimation Demo by Unscented Kalman Filter (UKF) [^1][^2].
Example of dynamics is for the 1 DoF arm with spring, damping, and frictional forces at a joint.
Joint angle is measured, then, unknown damping and frictional coefficients are identified by UKF [^3][^4].
In spite of discontinuous model of frictional force, UKF can be applied dislike Extended Kalman Filter (EKF). 


## Publications

This code was employed to estimate unknown parameters for the following publication(s):

* Optimal swimming locomotion of snake-like robot in viscous fluids, Journal of Fluids and Structures, Vol. 123 (2023).  
https://doi.org/10.1016/j.jfluidstructs.2023.104007

````
@article{YAMANO2023104007,
title = {Optimal swimming locomotion of snake-like robot in viscous fluids},
journal = {Journal of Fluids and Structures},
volume = {123},
pages = {104007},
year = {2023},
issn = {0889-9746},
doi = {https://doi.org/10.1016/j.jfluidstructs.2023.104007},
author = {A. Yamano and T. Kimoto and Y. Inoue and M. Chiba}
}
````

* Fluid force identification acting on snake-like robots swimming in viscous fluids, Journal of Fluids and Structures, Vol. 106 (2021).
https://doi.org/10.1016/j.jfluidstructs.2021.103351

````
@article{YAMANO2021103351,
title = {Fluid force identification acting on snake-like robots swimming in viscous fluids},
journal = {Journal of Fluids and Structures},
volume = {106},
pages = {103351},
year = {2021},
issn = {0889-9746},
doi = {https://doi.org/10.1016/j.jfluidstructs.2021.103351},
author = {A. Yamano and K. Shimizu and M. Chiba and H. Ijima},
keywords = {Snake-like robot, Swimming motion, Highly viscous fluid, Unscented Kalman filter, Parameter estimation}
}
````



## Overview

Dynamics for the 1 DoF arm with spring, damping, and frictional forces at a joint is denoted as follows,

$$
J \ddot{\theta} + c \dot{\theta} + \mu {\rm sgn}{\dot{\theta}} + k \theta = u,
$$

where damping and friction coefficients; $c$ and $\mu$ are unknown variables.
From measured time series of data $y_m := \theta_m(t)$, these variables are identified by UKF.

Then, state space representation is denoted as,

$$
\begin{array}{c}
{\bf \dot{x}} = f( {\bf x}, {\bf u}), \\
y = {\bf C} {\bf x},
\end{array}
$$

where

$$
\begin{array}{c}
{\bf x} =
\left[
\begin{array}{c}
x_1 \\
x_2 \\
\end{array}
\right] :=
\left[
\begin{array}{c}
\theta \\
\dot{\theta} \\
\end{array}
\right], \\
f( {\bf x}, {\bf u}) :=
\left[
\begin{array}{c}
x_2 \\
-J^{-1} c x_2 - J^{-1} \mu {\rm sgn} x_2 - J^{-1}k x_1 \\
\end{array}
\right] + {\bf B} u, \\
\bf{B} := 
\left[
\begin{array}{c}
0 \\
J^{-1} \\
\end{array}
\right], 
{\bf C} := 
\left[
\begin{array}{c}
1 \\
0 \\
\end{array}
\right]^T.
\end{array}
$$

Unknown damping and frictional coefficients are added to the expanded state vector as

$$
{\bf x_E} =
\left[
\begin{array}{c}
{\bf x} \\
x_3 \\
x_4 \\
\end{array}
\right] :=
\left[
\begin{array}{c}
{\bf x} \\
c \\
\mu \\
\end{array}
\right].
$$

Then, the expanded state representation is obtained as

$$
\begin{array}{c}
f( {\bf x_E}, {\bf u}) :=
\left[
\begin{array}{c}
x_2 \\
-J^{-1} c x_2 - J^{-1} \mu {\rm sgn} x_2 - J^{-1}k x_1 \\
0 \\
0 \\
\end{array}
\right] + {\bf B_E} u, \\
\bf{B}_E := 
\left[
\begin{array}{c}
0 \\
J^{-1} \\
0 \\
0 \\
\end{array}
\right], 
{\bf C}_E := 
\left[
\begin{array}{c}
1 \\
0 \\
0 \\
0 \\
\end{array}
\right]^T.
\end{array}
$$


After that, the dynamics is discretized for time to apply UKF ("./functions/c2d_func.m" [3]).

![図1](https://github.com/KRproject-tech/Parameter_estimation_demo_by_UKF/assets/114337358/c67f179f-8d55-4f0f-b6e1-c86732d4094c)





## Usages

__[Step 1] Edit parameters__

Edit code in "param_setting.m".

Process model with the state-space representation ${\bf \dot{x}} = f( {\bf x}, {\bf u})$, observation model $y = {\bf C} {\bf x}$, and input $u(t)$ are defined in the "param_setting.m" as follows;

````python
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
````

__[Step 2] Start analysis__

Execute "demo.m". 


## Images

![time_series_angle](https://github.com/KRproject-tech/Parameter_estimation_demo_by_UKF/assets/114337358/01988d56-d82c-4541-b0d1-d81eeac080da)

Time series of state $x_1 := \theta (t)$.


![untitled](https://user-images.githubusercontent.com/114337358/193397522-72f5e6e8-20ad-4821-932b-a2290c713a68.png)

Time series of output $y(t) := x_1(t)$

![identified_parameters](https://github.com/KRproject-tech/Parameter_estimation_demo_by_UKF/assets/114337358/44c5ceec-5d16-4fcb-8932-2e5c91548bbc)

Identified damping and friction coefficients; $c$ and $\mu$, and deviations; $\sigma_c$ and $\sigma_\mu$, respectively. 



### References
[^1]: Julier, S.J., Uhlmann, J.K., 2004. Unscented filtering and nonlinear estimation. Proc. IEEE 92 (3), 401–422.

[^2]: Julier, S.J., Uhlmann, J.K., Durrant-Whyte, H.F., 1995. A new approach for filtering nonlinear systems. In: Proceedings of 1995 American Control
Conference. ACC’95 3, pp. 1628–1632. http://dx.doi.org/10.1109/ACC.1995.529783.

[^3]: 足立 修一，丸田 一郎，「カルマンフィルタの基礎」，東京電機大学出版局．

[^4]: Fluid force identification acting on snake-like robots swimming in viscous fluids, Journal of Fluids and Structures, Vol. 106 (2021).  
https://doi.org/10.1016/j.jfluidstructs.2021.103351
