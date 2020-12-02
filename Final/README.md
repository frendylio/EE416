# Chapter 4
- Decimation (Low sampling)
    - Reduce the sampling rate of a discrete-time signal
    - Reduce storage and computational requirements
    - Steps:
        - Convolution
        - Then you downsampling (Delete the rows)
    - Advantages:
        - Low computation
    - Disadvantages:
        - Some Aliasing
- Interpolation
    - Increase the sampling rate of a discrete-time signal
    - Higher sampling rate preserves fidelity
    - Steps:
        - Put it up
        - Then Convolution
    - Advantages:
        - Easy to Compute
        - Reduce aliasing compared to pixel replications
    - Disadvantages:
        - Soften image due to attenuation in pass-band
        - Allows some aliased frequency spectrum 
    
# Chapter 5