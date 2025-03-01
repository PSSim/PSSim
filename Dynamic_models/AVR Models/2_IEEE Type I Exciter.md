# IEEE Type I Exciter
The IEEE type-1 exciter models the use of a DC generator as an amplifier and exciter. The regulator section allows automatic voltage control by comparing the signals (terminal voltage) with a reference and amplifying the error signal.
<div align="center">
<img src="https://github.com/user-attachments/assets/ac8fd7f8-ca1f-4a66-a3d6-c2a41eed3824" width="400">
</div>

# Excitation System Equations
The following equations describe the excitation system:

$$
T_E \frac{dE_{fd}}{dt} = -\left(K_E + S_E(E_{fd})\right) E_{fd} + V_R
$$

$$
T_A \frac{dV_R}{dt} = -V_R + K_A R_f - \frac{K_A K_F}{T_F} E_{fd} + K_A (V_{ref} - V_t)
$$

$$
T_F \frac{dR_f}{dt} = -R_f + \frac{K_F}{T_F} E_{fd}
$$

$$
\text{with} \quad V_R^{min} \leq V_R \leq V_R^{max}
$$

# Typical Data
A list of typical parameters is shown below:

$$
\begin{align}
K_a &= 20 \\
T_a &= 0.20 \\
K_e &= 1.00 \\
T_e &= 0.314 \\
K_f &= 0.630 \\
T_f &= 0.35 \\
T_b &= 12.5 \\
V_R^{min} &= -10.00 \\
V_R^{max} &= -10.00 \\
\end{align}
$$

# Reference
[**Pulgar2020Power**] Pulgar, H. A. (2020, Spring). Part 2: Power system models [Lecture slides]. ECE-692 Advanced Power System Modeling and Analysis, University of Tennessee, Knoxville.

[**NEPLANv555Exciter**] NEPLAN AG. Exciter Models. Standard Dynamic Excitation Systems in NEPLAN Power System Analysis Tool. Retrieved [March 2025] from https://www.neplan.ch/wp-content/uploads/2015/08/Nep_EXCITERS1.pdf
