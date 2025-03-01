# Gas Turbine-Governor (GAST) Model

Short description

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

# Reference
[**NEPLANv555Governor**]  NEPLAN AG. Turbine-governor Models. Standard Dynamic Excitation Systems in NEPLAN Power System Analysis Tool. Retrieved [March 2025] from https://www.neplan.ch/wp-content/uploads/2015/08/Nep_TURBINES_GOV.pdf
