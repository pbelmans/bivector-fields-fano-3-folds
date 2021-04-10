This is the documentation of an implementation which computes the cohomology of the second exterior power of the tangent bundle for all Fano 3-folds.

It accompanies the paper

    Belmans--Fatighenti--Tanturri, Polyvector fields for Fano 3-folds

available at (arXiv link to be added once it is uploaded).


It is a combination of two methods:

1) cohomology computations using a description from [MR3470714] as a complete intersection in a toric variety
2) cohomology computations using a description from [arXiv:2009.13382] as the zero locus of a homogeneous vector bundle on a product of Grassmannians

The first is a combination of Magma and Macaulay2 code. The second is done using Macaulay2. Full mathematical details are provided in the paper.

We will document some implementation details of these two computations below. Because the computations are sometimes time-consuming, we have also provided their output.

Bibliography
------------
* [[MR3470714](https://mathscinet.ams.org/mathscinet-getitem?mr=3470714)] Tom Coates, Alessio Corti, Sergey Galkin and Alexander Kasprzyk, Quantum periods for 3-dimensional Fano manifolds. Geom. Topol. 20 (2016), no. 1, 103–256.
* [[2009.13382]](https://arxiv.org/abs/2009.13382) Lorenzo De Biase, Enrico Fatighenti and Fabio Tanturri, Fano 3-folds from homogeneous vector bundles over Grassmannians. available as arXiv:2009.13382


Toric complete intersections
============================
To compute the cohomology of the second exterior power of the tangent bundle on a Fano 3-fold `X` described as a toric complete intersection inside `F`, we do the following:

1) translate the GIT description of the key variety `F` from [MR3470714] to a toric fan, and express the divisors cutting out `X` in terms of this fan
2) compute the cohomology of the first two terms of the conormal sequence twisted by the anticanonical line bundle before restriction to key variety using the Koszul sequence
3) combine the long exact sequences obtained in this way to get the desired cohomology

The code was written using Magma 2.25-4 and Macaulay2 version 1.17, with the NormalToricVarieties package version 1.9.

The output is provided in `toric-output.txt`. The translation took 170 seconds on a machine with a Xeon E5540 processor. The cohomology computation took 5100 seconds on a Mac Mini 2020.

Files
-----
* `general.m2`: methods used by both the toric and the homogeneous computation
* `fanosearch-translation.m`: translates the GIT description of a toric variety to a fan description
* `toric-description.m2`: a description of 92/105 Fano 3-folds as a toric complete intersection
* `toric-computation.m2`: the actual computation
* `toric-output.txt`: the output of `toric-computation.m2`

Instructions
------------
To run the computation:

1. `magma fanosearch-translation.m > toric-description.m2` (and clean up Magma's start-up output)
2. `M2 toric-computation.m2 > toric-output.txt`

In `fanosearch-translation.m` we provide Magma code which translates the GIT description to a fan description, using Magma's `FanWithWeights`. This script produces Macaulay2 code as output, and the output is provided in `toric-description.m2`.

In `toric-complete-intersections.m2` we compute using the Koszul sequence the cohomology, and recombine the terms. The method `computeBivectorCohomology` describes the vector bundles in the Koszul sequence using the `NormalToricVarieties` package, and computes the cohomology of the appropriate coherent sheaves on the key variety.


Homogeneous zero loci
=====================
To compute the cohomology of the second exterior power of the tangent bundle on a Fano 3-fold `X` described as the zero locus of a homogeneous vector `E` bundle on a product of Grassmannians `F`, we do the following:

1) compute the cohomology of the first two terms of the conormal sequence twisted by the anticanonical line bundle before restriction to the key variety using the Koszul sequence
2) combine the long exact sequences obtained in this way to get the desired cohomology

The code was written using Macaulay2 version 1.17, with the SchurRings package version 1.1.

The output is provided in `homogeneous-output.txt`. The homogeneous computation took 195 seconds on a Mac Mini 2020.


Files
-----
* `general.m2`: methods used by both the toric and the homogeneous computation
* `homogeneous-methods.m2`: a collection of methods to deal with cohomology of homogeneous vector bundles on products of Grassmannians using the Borel-Weil-Bott theorem
* `homogeneous-description.m2`: a description of 14/105 Fano 3-folds as a homogeneous zero locus
* `homogeneous-computation.m2`: the actual computation
* `homogeneous-output.txt` the output of `homogeneous-computation.m2`

Instructions
------------

To run the computation:

1. `M2 homogeneous-computation.m2 > homogeneous-output.txt`

In `homogeneous-computation.m2` we compute using the Koszul sequence the cohomology, and recombine the terms. The method `computeBivectorCohomology` describes the vector bundles in the Koszul sequence in a way that `homogeneous-methods.m2` can perform the Borel-Weil-Bott theorem on them.
