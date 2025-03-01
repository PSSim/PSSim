# Simplified Excitation System (SEXS) PTI
This model corresponds to a simplified excitation system.

<div align="center">
<img src="https://github.com/user-attachments/assets/31a4eabf-1fac-4108-b910-41dad3ed3026" width="400">
</div>

# Excitation System Equations
The following equations describe the excitation system:

$$
\begin{align}
\frac{dE_{fd}}{dt} &= \frac{1}{T_{e}} \left( K_{a} \left( V_{r} + \frac{T_{a}}{T_{b}} (V_{ref}-V_{t}) \right) -E_{fd} \right) \\
\frac{V_{r}}{dt} &= \frac{1}{T_{b}} \left(( 1-\frac{T_{a}}{T_{b}})( V_{ref}-V_{t} ) - V_{r} \right) \\
E_{fd-sat} &=
\begin{cases} 
    E_{fd}, & V_{min} \leq E_{fd} \leq V_{max}\\
    V_{min}, & E_{fd} < V_{min} \\
    V_{max}, & E_{fd} > V_{max}
\end{cases}
\end{align}
$$

Note: $E_{fd-sat}$ connects the SGs model with the exciter. 

# Typical Data
A list of typical parameters is shown below:

$$
\begin{align}
K_a &= 20 \\
T_a &= 6.00 \\
T_e &= 0.314 \\
T_b &= 12.5 \\
V_{min} &= 0.00 \\
V_{max} &= 3.00 \\
\end{align}
$$

# References
[**Powerworld2025SEXSPTI**] PowerWorld Corporation. SEXS_PTI exciter model. PowerWorld. Retrieved [March 2025] from https://www.powerworld.com/WebHelp/Content/TransientModels_HTML/Exciter%20SEXS_PTI.htm

[**NEPLANv555Exciter**] NEPLAN AG. Exciter Models. Standard Dynamic Excitation Systems in NEPLAN Power System Analysis Tool. Retrieved [March 2025] from https://www.neplan.ch/wp-content/uploads/2015/08/Nep_EXCITERS1.pdf
