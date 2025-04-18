# REGC_B Model
The Renewable Energy Generator/Converter (REGC) processes the real ($I_{Pcmd}$) and reactive ($I_{Qcmd}$) current commands from the control model and controls the output of real ($ip$) and reactive ($iq$) current injection to the grid.

<div align="center">
<img src="https://github.com/user-attachments/assets/953e391a-0091-47f2-aaab-eb713abe9119" width="500">
</div>

# Renewable Energy Generator/Converter System Equations
The model consists of 4 differential equations, plus 4 algebraic equations (Internal equations and equivalent circuits). The list of equations is shown below:

## Differential equations

$$
\begin{align}
\frac{di_{iq}}{dt}  &= \frac{-1}{T_Q} \left( I_{Qcmd} + i_{iq} \right) \\
\frac{di_{id}}{dt}  &= \frac{1}{T_D} \left( I_{Pcmd} - i_{id} \right) \\
\frac{dE_{x}}{dt}  &= \frac{1}{T_{ed}} \left( E_{d} - E_{x} \right) \\
\frac{dE_{y}}{dt}  &= \frac{1}{T_{eq}} \left( E_{q} - E_{y} \right)
\end{align}
$$

## Algebraic Equations

### Internal block Eqn. (1)
$$
\begin{align}
E_{d} &= v_d + i_{id} R_f - i_{iq} Xf\\
E_{q} &= v_q + i_{iq} R_f + i_{id} Xf \\
\end{align}
$$

### Equivalent circuit

$$
\begin{align}
E_{x} &= v_d + i_{d} R_f - i_{q} Xf\\
E_{y} &= v_q + i_{q} R_f + i_{d} Xf \\
\end{align}
$$

Note: $v_d$ and $v_q$ are the terminal voltages in the d-q axis. This model assumes that the d-axis is aligned with the terminal voltage, such that $v_q=0$ and a PLL is not necessary to track the grid voltage.

# Typical Data
A list of typical parameters is shown below:

$$
\begin{aligned}
T_Q &= 0.01  \\
T_D &= 0.01  \\
T_{eq} &= 0.01 \\
T_{ed} &= 0.01 \\
R_{f} &= 0.004 \\
X_{f} &= 0.05
\end{aligned}
$$

# References
- Ramasubramanian, D., Yu, Z., Ayyanar, R., Vittal, V., & Undrill, J. (2016). Converter model for representing converter interfaced generation in large scale grid simulations. IEEE Transactions on Power Systems, 32(1), 765-773.
- Farantatos, E. (2018). Model user guide for generic renewable energy system models. Technical Update 3002014083, EPRI.

