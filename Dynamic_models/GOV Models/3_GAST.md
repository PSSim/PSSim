# Gas Turbine-Governor (GAST) Model

The GAST governor model represents the dynamic behavior of a gas turbine speed governor, which regulates fuel flow. It operates by sensing speed deviations from a reference setpoint and adjusting the fuel valve accordingly, incorporating droop control to balance system frequency. The model includes a primary speed control loop, fuel system dynamics with transport delays, and actuator and valve constraints.

<div align="center">
  <img src="https://github.com/user-attachments/assets/e0af684c-1428-4fc2-80e7-772a7fdc31e2" width="500">
</div>

# Turbine-Governor System Equations
The following equations describe the turbine-governor system:

$$
\begin{align}
    \frac{dx_{g1}}{dt} &= \frac{1}{T_1} \left(\min(aux_1, aux_2) - x_{g1} \right), \\
    \frac{dx_{g2}}{dt} &= \frac{1}{T_2} \left( x_{g1-sat} - x_{g2} \right), \\
    \frac{dx_{g3}}{dt} &= \frac{1}{T_3} \left( x_{g2} - x_{g3} \right) \\
    aux_1 &= P_{ref} - K_1 (\omega - 1), \\
    aux_2 &= A_t + K_t (A_t - x_{g3}).
\end{align}
$$

$$
x_{g1-sat} =
\begin{cases} 
    x_{g1}, & P_{\text{min}} \leq x_{g1} \leq P_{\text{max}}\\
    P_{min}, & x_{g1} < P_{\text{min}}  \\
    P_{max}, & P_{\text{max}} < x_{g1} 
\end{cases}
$$
# Typical Data
A list of typical parameters is shown below:

$$
\begin{align}
T_1 &= 0.25 \\
T_2 &= 0.25 \\
T_3 &= 2.50 \\\
K_1 &= 20 \\
D_t &= 0.25 \\
A_t &= Pmax \\
K_t &= 2.50 \\
P_{min} &= 0.00 \\
P_{max} &= 10.00 \\
\end{align}
$$

# Reference
[**NEPLANv555Governor**]  NEPLAN AG. Turbine-governor Models. Standard Dynamic Excitation Systems in NEPLAN Power System Analysis Tool. Retrieved [March 2025] from https://www.neplan.ch/wp-content/uploads/2015/08/Nep_TURBINES_GOV.pdf
