# One-axis SG Model
This model represents the quadrature sub-transient flux linkage dynamics. The equivalent circuit that connects the model with the grid is shown below:
<div align="center">
  <img src="https://github.com/user-attachments/assets/ee1cf886-6567-407c-bcab-6f02e57b25ef" width="700">
</div>

# Equations
The model consists of 3 differential equations (2 mechanical-related, and 1 flix-related), plus 2 algebraic equations (equivalent circuit). The list of equations is shown below:

$$
\frac{d\delta}{dt} = \omega_s(\omega - \omega_{ref})
$$

$$
2H \frac{d\omega}{dt} = (T_m - E'_d i_d - E'_q i_q - (X'_q - X'_d)i_d i_q) 
$$

$$
T'_{d0} \frac{dE'_q}{dt} = -E'_q - (X_d - X'_d) i_d + Efd
$$

$$
E'_d = V_t \sin(\delta - \theta) + R_s i_d - X'_q i_q
$$

$$
E'_q = V_t \cos(\delta - \theta) + R_s i_q + X'_d i_d
$$

# Typical Data
A list of typical parameters is shown below:

$$
\begin{aligned}
H &= 10  \\
R_s &= 0.00  \\
X_d &= 0.25  \\
X'_d &= 0.05 \\
X_q &= 0.20 \\
X'_q &= 0.10 \\
T'_d0 &= 5.00 \\
\end{aligned}
$$

# References
[**Pulgar2020Power**] Pulgar, H. A. (2020, Spring). Part 2: Power system models [Lecture slides]. ECE-692 Advanced Power System Modeling and Analysis, University of Tennessee, Knoxville.

Sauer, P. W., Pai, M. A., & Chow, J. H. (2017). Power system dynamics and stability: with synchrophasor measurement and power system toolbox. John Wiley & Sons.
