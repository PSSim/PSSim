# IEESGO governor

<div align="center">
  <img src="https://github.com/user-attachments/assets/5cb04ebc-7cc9-4ebb-996f-bde774c5ce2a" width="400">
</div>


$$ 
T_1 \dot{y}_1 = -y_1 + K_1 (\omega - 1) 
$$

$$ 
T_3 \dot{y}_3 = -y_3 + y_1
$$

$$ 
T_4 \dot{T}_m = -T_m + P_C - y_2
$$

$$ 
y_{2i} = \left( 1 - \frac{T_2}{T_3} \right) y_3 + \frac{T_2}{T_3} y_1
$$

Applying limits over the algebraic variable \( y_2 \):

$$
y_2 =
\begin{cases} 
    P_C - P_{\text{min}}, & P_{\text{min}} > P_C - y_{2i} \\
    P_C - P_{\text{max}}, & P_{\text{max}} < P_C - y_{2i} \\
    y_{2i}, & P_{\text{min}} \leq P_C - y_{2i} \leq P_{\text{max}}
\end{cases}
$$

# Reference
[1] Pulgar, H. A. (2020, Spring). Part 2: Power system models [Lecture slides]. ECE-692 Advanced Power System Modeling and Analysis, University of Tennessee, Knoxville.
