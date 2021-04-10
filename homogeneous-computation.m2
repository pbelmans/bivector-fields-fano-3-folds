needsPackage("SchurRings");

load "general.m2";
load "homogeneous-methods.m2";

-- the Fano 3-folds for which the toric methods don't apply
load "homogeneous-description.m2";

-- The main computational part: the cohomology of the second exterior power of
-- the tangent bundle on a Fano 3-fold which is a homogeneous zero locus in a product of Grassmannians

-- Method:
-- (a) compute the canonical line bundle before adjunction
-- (b) write down the bundles appearing in the twisted conormal sequence
-- (c) compute the cohomologies of their restriction by means of Koszul complexes
-- (d) recombine everything to get the result
computeBivectorCohomology = method()
computeBivectorCohomology(List, List) := (F, E) -> (
  -- we compute the line bundle whose restriction will be the canonical bundle of the zero locus of `F`
  omega := canonicalOfZeroLocus(F, E);

  -- we twist the elements of the conormal sequence by `omega^*`
  -- in our notation this means substracting and rescaling
  -- the first term in the conormal sequence is the conormal bundle `F`, which we already have
  conormalTwisted := E / (f -> (
    fTwisted := f - omega;
    apply(fTwisted, fT -> fT / (g -> g - min(fT)))
  ));

  -- the second term in the conormal sequence is the cotangent bundle, also twist this
  cotangent := cotangentBundle(F);
  cotangentTwisted := cotangent / (f -> (
    fTwisted := f - omega;
    apply(fTwisted, fT -> fT / (g -> g - min(fT)))
  ));

  -- now we compute via the Koszul complex the cohomologies of the restriction of conormalTwisted and cotangentTwisted
  twistedConormalCohomology := cohomologyOfRestrictedBundle(F, E, conormalTwisted);
  twistedCotangentCohomology := cohomologyOfRestrictedBundle(F, E, cotangentTwisted);

  -- now we fit them in the twisted conormal short exact sequence and get the cohomologies of what we want
  return thirdTerm(twistedConormalCohomology, twistedCotangentCohomology);
);

TEST ///
  F = {{2, 5}};
  E = {
        {{0, 0, 0, 2, 2}},
        {{0, 0, 0, 1, 1}},
        {{0, 0, 0, 1, 1}}
      };
  computeBivectorCohomology(F, E)
///

-- compute it for all cases
result = applyPairs(hashTable pairs homogeneous, (key, pair) -> (key, computeBivectorCohomology(pair_0, pair_1)));
print(result)
