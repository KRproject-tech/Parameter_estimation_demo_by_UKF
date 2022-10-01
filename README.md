# Parameter_estimation_demo_by_UKF
Parameter estimation Demo by Unscented Kalman Filter (UKF) [1-2].

## Overview


## Usages

__[Step 1] Edit parameters__

Edit code in "param_setting.m".

__[Step 2] Start analysis__

Execute "demo.m". 


## Images

![response](https://user-images.githubusercontent.com/114337358/193397387-294ff43d-8803-481f-b96c-6bae43ab9b28.png)

Time series of state $ x_1 := \theta (t) $.


![untitled](https://user-images.githubusercontent.com/114337358/193397522-72f5e6e8-20ad-4821-932b-a2290c713a68.png)

Time series of output $ y(t) := x_1(t)  $

![identified](https://user-images.githubusercontent.com/114337358/193397390-ce971b27-1378-4827-be87-016376857eca.png)

Identified damping and friction coefficients; $ c $ and $ \mu $, respectively.



## References

[1] Julier, S.J., Uhlmann, J.K., 2004. Unscented filtering and nonlinear estimation. Proc. IEEE 92 (3), 401–422.

[2] Julier, S.J., Uhlmann, J.K., Durrant-Whyte, H.F., 1995. A new approach for filtering nonlinear systems. In: Proceedings of 1995 American Control
Conference. ACC’95 3, pp. 1628–1632. http://dx.doi.org/10.1109/ACC.1995.529783.
