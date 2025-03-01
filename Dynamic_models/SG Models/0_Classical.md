# Classical SG Model
The classical model dynamic circuit represents only the stator equivalent dynamics. Below is the circuit schematic:
<div align="center">
  <img src="https://github.com/user-attachments/assets/acf92811-e4c7-4be6-96e0-e929d46ec314" width="300">
</div>

# Equations
The model consists of 2 differential equations (mechanical-related), plus 2 algebraic equations (equivalent circuit). The list of equations is shown below:

$$
\frac{d\delta}{dt} = \omega_s(\omega - \omega_{ref})
$$

$$
2H \frac{d\omega}{dt} = (T_m - Re(E I^*) - D(\omega - \omega_{ref}) )
$$

$$
0 = Re(-E + I jX'_d + V_t∠\theta)
$$

$$
0 = Im(-E + I jX'_d + V_t∠\theta)
$$

# Typical Data
A list of typical parameters is below:

$$
\begin{aligned}
H &= 10  \\
R_s &= 0.00  \\
X'_d &= 0.05 \\
D &= 2H
\end{aligned}
$$

# References
[**Pulgar2020Power**] Pulgar, H. A. (2020, Spring). Part 2: Power system models [Lecture slides]. ECE-692 Advanced Power System Modeling and Analysis, University of Tennessee, Knoxville.

[**Sauer2017Power**] Sauer, P. W., Pai, M. A., & Chow, J. H. (2017). Power system dynamics and stability: with synchrophasor measurement and power system toolbox. John Wiley & Sons.
