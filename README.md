# graph-states-coherent-info [![arXiv](https://img.shields.io/badge/arXiv-1910.00471-blue.svg?style=flat)](https://arxiv.org/abs/1910.00471) [![forthebadge cc-sa](http://ForTheBadge.com/images/badges/cc-sa.svg)](https://creativecommons.org/licenses/by-sa/4.0)
This MATLAB code computes the coherent information of a graph state under arbitrary i.i.d. Pauli noise, implementing Algorithm 1 in the paper 

"Error Tresholds for Arbitrary Pauli Noise", Johannes Bausch and Felix Leditzky, [arXiv:1910.00471](https://arxiv.org/abs/1910.00471)

## Files
* `pauli_action.m`: Main function that computes the coherent information of a graph state given by the adjacency matrix of the graph.
* `get_U_subsets.m`: Auxiliary function that is either automatically invoked by `pauli_action.m` or precomputed by the user.
* `examples.m`: Contains some examples that illustrate how to best use the code.

## Usage
The code works with a standard MATLAB installation and does not require any special packages or add-ons.

For a C++ implementation of Algorithm of our paper that exploits the graph state's symmetries, see https://github.com/rumschuettel/CoffeeCode.
