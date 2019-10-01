# graph-states-coherent-info
This MATLAB code computes the coherent information of a graph state under arbitrary i.i.d. Pauli noise, implementing Algorithm 1 in the paper 

"Error Tresholds for Arbitrary Pauli Noise", Johannes Bausch and Felix Leditzky, arXiv:xxxx.xxxxx

The m-file `pauli_action.m` is the main function that computes the coherent information (using the auxiliary function `get_U_subsets.m` which can either be automatically invoked or precomputed). The file `examples.m` contains some examples that illustrate how to best use the code.

The code works with a standard MATLAB installation and does not require any special packages or add-ons.

For a C++ implementation of Algorithm of our paper that exploits the graph state's symmetries, see https://github.com/rumschuettel/CoffeeCode.
