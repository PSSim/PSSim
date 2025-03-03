# Converter active and reactive power control
This control is based on [Ramasubramanian, D., 2016.]. The main intention is to maintain P and Q references at the converters' point of interconnection. 

<div align="center">
  <img src="https://github.com/user-attachments/assets/0b932e26-29be-4ea4-bc93-e5ec216eec2c" width="300">
</div>

# PQ control system equations
The model consists of 4 differential equations, plus 2 algebraic equations. The list of equations is shown below:

$$
\begin{align}
\frac{ds_{1}}{dt} &= \frac{1}{T_{Gqv}} \left( Q_{ref}-s_1 \right) \\
\frac{ds_{2}}{dt} &= K_{iq} \left( Q_{cmd}- Q_g \right) \\
\frac{ds_{3}}{dt} &= \frac{1}{T_{Gpv}} \left( P_{ref}-s_3 \right) \\
\frac{ds_{4}}{dt} &= K_{ip} \left( P_{cmd}- P_g \right) \\
I_{Qcmd}          &= s_2 + \frac{Q_{cmd}}{|v_{t}|} \\
I_{Pcmd}          &= s_4 + \frac{P_{cmd}}{|v_{t}|}
\end{align}
$$

$$
Q_{cmd} =
\begin{cases} 
    s_1, & Q_{\text{min}} \leq s_1 \leq Q_{\text{max}}\\
    Q_{min}, & s_{1} < Q_{\text{min}}  \\
    Q_{max}, & Q_{\text{max}} < s_{1} 
\end{cases}
$$
$$
P_{cmd} =
\begin{cases} 
    s_3, & P_{\text{min}} \leq s_3 \leq P_{\text{max}}\\
    P_{min}, & s_{3} < P_{\text{min}}  \\
    P_{max}, & P_{\text{max}} < s_{3} 
\end{cases}
$$

# Typical Data
A list of typical parameters is shown below:

$$
\begin{align}
K_{iq} &= 5.00 \\
T_{Gqv} &= 0.01 \\
K_{ip} &= 5.00 \\
T_{Gpv} &= 0.01 \\
Q_{min} &= -1.00 \\
Q_{max} &= 1.00 \\
P_{min} &= 0.00 \\
P_{max} &= 1.00 \\
\end{align}
$$

# References
- Ramasubramanian, D., Yu, Z., Ayyanar, R., Vittal, V., & Undrill, J. (2016). Converter model for representing converter interfaced generation in large scale grid simulations. IEEE Transactions on Power Systems, 32(1), 765-773.
