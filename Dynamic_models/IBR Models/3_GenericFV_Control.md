# Converter frequency and voltage control
This control is based on [Ramasubramanian, D., 2016.]. The main intention is to maintain f and v references at the converters' point of interconnection.
<div align="center">
  <img src="https://github.com/user-attachments/assets/3ee38622-df1a-459b-8554-1532d05b529c" width="400">
</div>

# FV control system equations
The model consists of 7 differential equations, plus 2 algebraic equations. The list of equations is shown below:

$$
\begin{align}
\frac{ds_{1}}{dt} &= \frac{1}{T_{Gqv}} \left( s_6 + K_p(V_{ref}- s_5 - R_q Q_g) - s_1 \right) \\
\frac{ds_{2}}{dt} &= K_{iq} \left( Q_{cmd}- Q_g \right) \\
\frac{ds_{3}}{dt} &= \frac{1}{T_{Gpv}} \left( P_{ref}- \frac{s_7}{R_p}-s_3 \right) \\
\frac{ds_{4}}{dt} &= K_{ip} \left( P_{cmd}- P_g \right) \\
\frac{ds_{5}}{dt} &= \frac{1}{T_{r}}  \left( v_{t}- s_5 \right) \\
\frac{ds_{6}}{dt} &= K_{i} \left( V_{ref}- s_5 - R_q Q_g \right) \\
\frac{ds_{7}}{dt} &= \frac{1}{T_{frq}} \left( \omega_{est} - 1 - s_7 \right) \\
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
T_{r} &= 0.02 \\
R_{q} &= 0.00 \\
K_{i} &= 20.0 \\
K_{p} &= 4.00 \\
T_{frq} &= 0.01 \\
R_{p} &= 0.05
\end{align}
$$

# References
- Ramasubramanian, D., Yu, Z., Ayyanar, R., Vittal, V., & Undrill, J. (2016). Converter model for representing converter interfaced generation in large scale grid simulations. IEEE Transactions on Power Systems, 32(1), 765-773.
