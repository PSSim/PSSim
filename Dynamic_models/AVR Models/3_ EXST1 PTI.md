# IEEE Type ST1 Excitation System Model
Short description

<div align="center">
<img src="https://github.com/user-attachments/assets/87670413-20b8-466e-8e0a-1e1caddf3957" width="600">
</div>

# Excitation System Equations
The following equations describe the excitation system:

$$
\frac{dv_{m}}{dt} = \frac{1}{T_r} \left( v_t - v_m \right)
$$

$$
\frac{dv_{rll}}{dt} = \frac{1}{T_c} \left(  \left( \frac{T_c}{T_b} (v_{ref} - v_m - v_f - v_{rll}) - v_{rll}\right) - v_{rll} \right)
$$

$$
\frac{dE_{fd}}{dt}  = \frac{1}{T_a} \left( K_a \left( \frac{T_c}{T_b} (V_{ref} - v_m - v_f - v_{rll}) - v_{rll} \right) - E_{fd} \right)
$$

$$
\frac{dv_{f}}{dt} = \frac{1}{T_f} \left(\left( \frac{K_f * K_a}{T_a}   \left( \frac{T_c}{T_b}  (v_{ref} - v_m - v_f - v_{rll}) - v_{rll} \right) - E_{fd-sat}\right) - v_f \right)
$$

$$
\begin{align}
E_{fd-sat} &=
\begin{cases} 
    E_{fd}, & v_{fmin} \leq E_{fd} \leq v_{fmax}\\
    v_{fmin}, & E_{fd} < v_{min} \\
    v_{fmax}, & E_{fd} > v_{max}
\end{cases}
\end{align}
$$

where, 

$$
v_{fmin}  = |v_t| v_{rmin} - K_c i_{fd}
$$
$$
v_{fmax}  = |v_t| v_{rmax} - K_c i_{fd}
$$

$$
v_q = \mathrm{Im}\left(v_t e^{-j (\delta - \frac{\pi}{2})}\right)
$$

$$
I_{fd}  = i_d x_q +i_qR_s + v_q
$$

Note: $I_{fd}$ is the field current associated with $E_{fd}$, while $i_d$ and $i_q$ are the injected currents at the point of interconnection.


# Reference
- [**Powerworld2025EXST1PTI**] PowerWorld Corporation. (2025). Exciter model: EXST1_PTI. Retrieved March 1, 2025, from https://www.powerworld.com/WebHelp/Content/TransientModels_HTML/Exciter%20EXST1_PTI.htm?tocpath=Transient%20Stability%20Add-On%20(TS)%7CTransient%20Models%7CGenerator%7CExciter%7C_____66

- Andes Documentation. (n.d.). EXST1: Static excitation system. Andes. Retrieved March 1, 2025, from https://docs.andes.app/en/stable/groupdoc/Exciter.html#exst1

