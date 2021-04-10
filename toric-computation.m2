loadPackage "NormalToricVarieties";

load "general.m2";
load "toric-description.m2";

-- The main computational part: the cohomology of the second exterior power of
-- the tangent bundle on a Fano 3-fold which is a toric complete intersection

-- Method:
-- (a) compute cohomology in the Koszul resolution of the first 2 entries of the twisted conormal sequence
-- (b) recombine to get the cohomology of the second exterior power of the tangent bundle
computeBivectorCohomology = (F, X) -> (
  omega := OO toricDivisor F;
  Omega := cotangentSheaf F;

  -- honest toric variety, so shortcut the computation
  if #X == 0 then (
    return apply(dim F + 1, i -> rank HH^i(F, Omega ** (dual omega)));
  )
  -- complete intersection within a toric variety
  else (
    -- vector bundle cutting out `X` inside `F`
    E := directSum apply(X, D -> OO D);
    -- determinant of `E`
    D := exteriorPower(#X, E);

    -- Koszul computation
    A := apply(#X + 1, j ->
      apply(dim F + 1, i ->
        rank HH^i(F, (dual exteriorPower(#X - j, E)) ** (dual E) ** (dual omega) ** (dual D))));
    B := apply(#X + 1, j ->
      apply(dim F + 1, i ->
        rank HH^i(F, (dual exteriorPower(#X - j, E)) ** Omega ** (dual omega) ** (dual D))));

    return (thirdTerm(fold((A, B) -> thirdTerm(A, B), A), fold((A, B) -> thirdTerm(A, B), B)))_{0..3};
  );
);

-- compute it all
time result = applyPairs(hashTable pairs toric, (key, pair) -> (key, computeBivectorCohomology(pair_0, pair_1)));
print(result);
