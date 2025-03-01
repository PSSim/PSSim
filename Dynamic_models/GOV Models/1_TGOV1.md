# Steam Turbine-Governor Model
Short description

<div align="center">
<img src="https://github.com/user-attachments/assets/a23d56af-4c7b-4ebb-92a2-243e299d1727" width="450">
</div>

# Turbine-Governor System Equations
The following equations describe the turbine-governor system:

$$
\frac{dy_{1}}{dt} = \frac{1}{T_1} \left(K_1 (P_c - (\omega -1)) - y_{1-sat}\right)
$$

$$
\frac{dy_{2}}{dt} = \frac{1}{T_3} \left(y_1 (1 - \frac{T_2}{T_3}) -y_2 \right)
$$

$$
T_m = y_2 + \frac{T_2}{T_3} y_{1-sat} - D_t (\omega - 1)
$$

$$
y_{1-sat} =
\begin{cases} 
    y_1, & P_{\text{min}} \leq y_1 \leq P_{\text{max}}\\
    P_{min}, & y_{1} < P_{\text{min}}  \\
    P_{max}, & P_{\text{max}} < y_{1} 
\end{cases}
$$

# Reference
[**Powerworld2025TGOV1**] PowerWorld Corporation. (2025). Governor model: TGOV1 and TGOV1D. Retrieved March 1, 2025, from https://www.powerworld.com/WebHelp/Content/TransientModels_HTML/Governor%20TGOV1%20and%20TGOV1D.htm
