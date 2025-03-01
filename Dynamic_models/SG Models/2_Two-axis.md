# Two-axis SG Model
This model represents the direct and quadrature sub-transient flux linkage dynamics. The equivalent circuit that connects the model with the grid is shown below:
<div align="center">
  <img src="https://github.com/user-attachments/assets/091e0d30-ed42-4bc8-913c-f5be5dc77b79" width="700">
</div>

# Equations
The model consists of 4 differential equations (2 mechanical-related, and 2 flix-related), plus 2 algebraic equations (equivalent circuit). The list of equations is shown below:

$$
\frac{d\delta}{dt} = \omega_s(\omega - \omega_{ref})
$$

$$
2H \frac{d\omega}{dt} = (T_m - E^{\prime}_d i_d - E^{\prime}_q i_q - (X^{\prime}_q - X^{\prime}_d)i_d i_q) 
$$

$$
T'_{d0} \frac{dE^{\prime}_q}{dt} = -E'_q - (X_d - X'_d) i_d + E_{fd}
$$

$$
T'_{q0} \frac{dE^{\prime}_d}{dt} = -E'_d - (X_q - X'_q) i_q
$$

$$

$$



# Typical Data
A list of typical parameters is below:


# References
[] ...
