-- Method:
-- translate a bundle from our list notation to an element of a suitable SchurRing
-- we often need different SchurRings to be compatible, so if a list of SchurRings is given as a third argument, the bundle will be translated as an element of the last ring of the list
-- if only two arguments are present, then the SchurRing is created from the scratch and then the function with the SchurRing as a third argument is called
toSchurRingsNotation = method()

-- function with two arguments
toSchurRingsNotation(List, List) := (X, F) -> (
  -- we define our SchurRing iteratively, constructing a SchurRing for each tautological bundle in each Grassmannian
  listOfRanks := X / (G -> ({G_0} | for i from 1 to #G-1 list G_i - G_(i-1)));
  qs := apply(#X, i -> value concatenate {"q", toString i});
  us := apply(#X, i -> value concatenate {"u", toString i});
  myVars := apply(2*#X, i -> (join(us, qs))_(#X * (i % 2) + i // 2));
  listOfRings := {schurRing(QQ, myVars_0, (first listOfRanks)_0)};

  for i from 1 to #(flatten listOfRanks) - 1 do listOfRings = append(listOfRings, schurRing(last listOfRings, myVars_i, (flatten listOfRanks)_i));

  -- we call the 3-argument function
  toSchurRingsNotation(X, F, listOfRings)
);
TEST ///
  X = {{2,4}, {2,5}};
  F = {{{1,0,1,1}, {0,0,0,1,0}}, {{0,0,1,1}, {0,0,0,0,0}}, {{0,0,0,0}, {0,0,0,1,1}}, {{0,0,0,0}, {0,0,0,1,1}}};
  toSchurRingsNotation(X, F)
///

-- function with three arguments
toSchurRingsNotation(List, List, List) := (X, F, listOfRings) -> (
  listOfRanks := X / (G -> ({G_0} | for i from 1 to #G-1 list G_i - G_(i-1)));

  -- for each summand of F, translate our notation to the SchurRings notation and then sum everything up
  sum (F / (f -> (
    -- f is a single summand of F, where f is the box product of irreducible homogeneous vector bundles on the corresponding Grassmannian
    fWithCommas := flatten for i from 0 to #f-1 list reverse (divideList(f_i, reverse listOfRanks_i));

    -- now the elements of fWithCommas are the plethysms to be applied to u0, q0, u1, q1, ... in this very order, and then we take the product
    product for i from 0 to #fWithCommas-1 list (listOfRings_i)_(fWithCommas_i)
  )))
)
TEST ///
  X = {{2,4}, {2,5}};
  F = {{{1,0,1,1}, {0,0,0,1,0}}, {{0,0,1,1}, {0,0,0,0,0}}, {{0,0,0,0}, {0,0,0,1,1}}, {{0,0,0,0}, {0,0,0,1,1}}};
  F1 = toSchurRingsNotation(X, F)
  G = {{{0,0,1,1}, {0,0,0,0,0}}, {{0,0,0,0}, {0,0,0,1,1}}, {{0,0,0,0}, {0,0,0,1,1}}};
  G1 = toSchurRingsNotation(X, G)
  F1 + G1 -- incompatible SchurRings

  -- but if I reconstruct the list of SchurRings from F and feed it into the function, I get compatible rings:
  listOfRings := append(drop(((ring F1).baseRings), 2), ring F1);

  -- let's feed it
  G2 = toSchurRingsNotation(X, G, listOfRings)
  F1 + G2 -- compatible SchurRings
///


-- Method:
-- translate a bundle in SchurRing notation to our list notation, giving the inverse of toSchurRingsNotation
toListNotation = method()

toListNotation(RingElement) := (FSchur) -> (
  listOfTerms := apply(listForm(FSchur), T -> {{first toList T}, last toList T});
  listOfRings := append(drop(((ring FSchur).baseRings), 2), ring FSchur);

  for i from 2 to #listOfRings do (
    listOfTerms = flatten apply(listOfTerms, T -> (
      pivot := T_0;
      apply(listForm(T_1), L -> {append(pivot, L_0), L_1})
    ));
  );

  -- we reconstruct the ambient variety X from FSchur
  X := listOfRings / (R -> R.numgens);
  X = pack(2, X);
  X = X / (x -> {x_0, x_1 + x_0});

  -- every element of listOfTerms is a list of two elements:
  -- b) the first one encodes the plethysms of the tautological bundles in reversed order
  -- a) the last one is the multiplicity of the bundle
  flatten (listOfTerms / (T -> (
    apply(sub(last T, ZZ), i -> (
      -- for each bundle we add zeroes where needed
      revT := pack(2, reverse(T_0));
      for i from 0 to #X-1 list flatten reverse {revT_i_0 | (for j from 1 to X_i_0 - #revT_i_0 list 0), revT_i_1 | (for j from 1 to X_i_1 - X_i_0 - #revT_i_1 list 0)}
    ))
  )))
)
TEST ///
  X = {{2, 4}, {2, 5}}
  F = {{{1,0,1,1},{0,0,0,1,0}},{{0,0,1,1},{0,0,0,0,0}},{{0,0,0,0},{0,0,0,1,1}},{{0,0,0,0},{0,0,0,1,1}}};
  FSchur = toSchurRingsNotation(X, F)
  G = toListNotation(FSchur)
  G == F
  sort G == sort F
///


-- Method:
-- return the cotangent bundle of the product of Grassmannians X
cotangentBundle = method()
cotangentBundle(List) := (X) -> (
  -- on a Grassmannian {k,n} the cotangent bundle is given, in our notation by (n-k-1 times 1) | 0 | 2 | (k-1 times 1)
  -- on a product, the cotangent bundle is the sum of the pullbacks of the cotangent bundles
  for i from 0 to #(X) - 1 list (
    for j from 0 to #(X) - 1 list (
      gr := X_j;
      n := gr_1;
      k := gr_0;
      if j == i then (for h from 1 to n - k - 1 list 1) | {0, 2} | (for h from 1 to k - 1 list 1) else (for h from 1 to n list 0)
    )
  )
)
TEST ///
  X = {{2,4}, {2,5}}
  cotangentBundle(X)
///


-- Method:
-- compute the canonical bundle of a zero locus on a product of Grassmannians before restriction
canonicalOfZeroLocus = method ()
canonicalOfZeroLocus(List, List) := (X, F) -> (
  -- this is the top exterior power of the bundle and sum it with the top exterior of the cotangent bundle of the product of Grassmannians

  -- compute the top exterior power of the bundle `F`
  FSchur := toSchurRingsNotation(X, F);
  detFSchur := exteriorPower(dim FSchur, FSchur);
  detF := toListNotation(detFSchur);

  -- we will reuse the Schur rings introduced for `F`
  listOfRings := append(drop(((ring FSchur).baseRings), 2), ring FSchur);

  -- compute the top exterior power of the cotangent bundle
  cotangent := cotangentBundle(X);
  cotangentSchur := toSchurRingsNotation(X, cotangent, listOfRings);
  canonicalSchur :=  exteriorPower(dim cotangentSchur, cotangentSchur);
  canonical := toListNotation(canonicalSchur);

  -- adjunction formula
  result := canonical_0 - detF_0;

  -- adding an integer to every element of a list does not change the bundle the list represents, so we can rescale the lists to simplify
  return result / (b -> (apply(b, bi -> bi - min(b))));
);
TEST ///
  X = {{2, 4}, {2, 5}};
  F = {{{1,0,1,1},{0,0,0,1,0}},{{0,0,1,1},{0,0,0,0,0}},{{0,0,0,0},{0,0,0,1,1}},{{0,0,0,0},{0,0,0,1,1}}};
  canonicalOfZeroLocus(X, F)
///



-- Method:
-- Borel--Weil--Bott for an irreducible equivariant vector bundle on a Grassmannian
-- if acyclic, then it returns {-1, -1}
-- otherwise {i, d}, meaning that the ith cohomology has dimension d
BorelWeilBott = method()
BorelWeilBott(List) := (L) -> (
  n := #L;
  s := symbol s;
  R := schurRing(QQ, s, n);
  D := reverse(apply(n, i -> i));
  LD := L+D;
  rep:= #(unique LD);
  if (rep) != n then {-1,-1} else (
    W := (reverse sort LD) - D;
    m := min W;
    if m > 0 then (
      gam := toSequence W;
      LSUB := L - apply(n, i -> i + 1);
      CO := 0;
      for i from 0 to #L - 1 do (for j from i + 1 to #L -1 do (if LSUB_i < LSUB_j then CO = CO + 1));
      {CO,dim (s_gam)}
    ) else (
      MINL := apply(n, i -> -m);
      W2 := W + MINL;
      gam2 := toSequence W2;
      LSUB = L - apply(n, i -> i + 1);
      CO = 0;
      for i from 0 to #L - 1 do (for j from i + 1 to #L - 1 do (if LSUB_i < LSUB_j then CO = CO+1));
      {CO, dim (s_gam2)}
    )
  )
)
TEST ///
  L={2,1,1,1,1,1,1,1,0,0}
  BorelWeilBott L
  L={3,3,3,1,0}
  BorelWeilBott L
  L={1,0,2}
  BorelWeilBott L
  L={2,1,1}
  BorelWeilBott({3,0,3})
  BorelWeilBott({1,0,1})
///


-- Method:
-- the Kunneth formula for bundles on the product of Grassmannians
kunneth = method()
kunneth(List) := (divVect) -> (
  kun := apply(divVect, l -> BorelWeilBott(l));
  return if all(kun, k -> first k >= 0) then ({sum apply(kun, k -> first k),product apply(kun,k -> last k)}) else {-1, -1};
)
TEST ///
  divVect = {{1,0,2}, {3,0,3}, {2,1,1}};
  kunneth divVect
  divVect / (d -> BorelWeilBott d)
  divVect = {{1,0,2}, {3,0,3}, {2,1,1}, {0,0,1}}
  kunneth divVect
  divVect / (d -> BorelWeilBott d)
///



-- Method:
-- compute the cohomology groups of the bundle `F` over `X`
cohomologyOfBundle = method ()
cohomologyOfBundle(List) := (F) -> (
  cohomologies := F / (f -> kunneth f);
  sort if #cohomologies == 1 then cohomologies else (
    if all(cohomologies, c -> first c == -1) then {{-1, -1}}
    else (
      groupsAppearing := select(unique (cohomologies / (c -> first c)), k -> k >= 0);
      groupsAppearing / (i -> (
        onlyIthCohom := select(cohomologies, c -> first c == i);
        {i, sum (onlyIthCohom / (c -> last c))}
      ))
    )
  )
)
TEST ///
  F = {{{1,0,2}}, {{3,0,3}}, {{2,1,1}}, {{0,0,1}}}
  cohomologyOfBundle F
  F = {{{0,0,1}}, {{0,0,1}}}
  cohomologyOfBundle F
  F = {{{3,0,3}}}
  cohomologyOfBundle F
///



-- Method:
-- compute the cohomology groups of the restriction of the bundle G to the zero locus of a general section of the bundle F* over X
cohomologyOfRestrictedBundle = method()
cohomologyOfRestrictedBundle(List, List, List) := (X, F, G) -> (
  -- use SchurRings to construct the exterior powers of `F` and tensor them by `G`
  listOfRanks := X / (G -> ({G_0} | for i from 1 to #G-1 list G_i - G_(i-1)));
  FSchur := toSchurRingsNotation(X, F);
  listOfRings := append(drop(((ring FSchur).baseRings), 2), ring FSchur);
  rankF := dim FSchur;
  listWedgeKF := for i from 0 to rankF list exteriorPower(i,FSchur);
  GSchur := toSchurRingsNotation(X, G, listOfRings);
  listWedgeKFTensorGSchur := listWedgeKF / (w -> w*GSchur);

  -- now translate everything back into our list notation
  listWedgeKFTensorG :=  listWedgeKFTensorGSchur / (w -> toListNotation(w));

  -- each element of listWedgeKFTensorG is a list representing a bundle, and we want to know the cohomology group of this bundle.
  listCohomologiesWedgeKFTensorG := listWedgeKFTensorG / (w -> cohomologyOfBundle(w));

  -- we then fit all together in a long exact sequence whose last term is precisely what we want
  -- we also know that the higher cohomology groups vanish, so we force them to do
  dimX := sum (X / (x -> x_0*(x_1 - x_0)));
  toFeed := reverse listCohomologiesWedgeKFTensorG / (c -> (
    for i from 0 to dimX list (
      posI := (position(c, d -> first d == i));
      if posI === null then 0 else c_posI_1
    )
  ));

  result := fold((A, B) -> thirdTerm(A, B), toFeed);
  for i from 0 to dimX - rankF list ((result_i) % ideal(for j from dimX - rankF + 1 to dimX list result_j))
)
TEST ///
  X = {{2, 4}, {2, 5}};
  F = {{{1,0,1,1}, {0,0,0,1,0}}, {{0,0,1,1}, {0,0,0,0,0}}, {{0,0,0,0}, {0,0,0,1,1}}, {{0,0,0,0}, {0,0,0,1,1}}};
  G = cotangentBundle(X);
  cohomologyOfRestrictedBundle(X, F, G)
///
