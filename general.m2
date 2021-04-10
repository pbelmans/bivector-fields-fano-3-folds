-- Method:
-- determine the cohomology of the third term `C` in the long exact cohomology sequence from a short exact sequence 0 -> A -> B -> C -> 0
thirdTerm = method()
thirdTerm(List, List) := (A, B) -> (
  -- make sure they are equal length by padding if necessary
  A = join(A, #B - #A : 0);
  B = join(B, #A - #B : 0);

  -- create common ring: determine the already used generators
  old := join(generators ring A_0, generators ring B_0);
  x := symbol x;
  R := ZZ[old, x_#old..x_(#old + #A - 1)];

  -- redefine A, B and create the cokernel C
  oldAToR := map(R, ring A_0, apply(#(generators ring A_0), i -> (generators R)_i));
  oldBToR := map(R, ring B_0, apply(#(generators ring B_0), i -> (generators R)_(i + #(generators ring A_0))));
  A = apply(A, a -> oldAToR(a));
  B = apply(B, b -> oldBToR(b));
  C := (generators R)_{-#A..-1};

  -- long exact sequence: reorder three lists appropriately
  les := join(A, B, C);
  les = apply(3 * #A, i -> les_(#A * (i % 3) + (i // 3)));

  -- split into shorter sequences whenever a zero appears and determine linear equation from it
  equations := {};
  subsequence := {};
  for v in join(les, {0}) do (
    -- continue building subsequence
    if not zero v then subsequence = append(subsequence, v);

    -- finished a (non-empty) subsequence so append and start again
    if zero v and #subsequence > 0 then (
      equations = append(equations, sum(apply(#subsequence, i -> (-1)^i * subsequence_i)));
      subsequence = {};
    );
  );

  -- determine equations from Euler characteristic being 0 for every sequence
  result := apply(C, e -> e % ideal equations);

  -- convert the variables in the result to a minimal ring
  variables := select(unique flatten (result / (c -> flatten entries first coefficients(c))), v -> (degree v)_0 > 0);
  y := symbol y;
  S := ZZ[y_0..y_(#variables - 1)];
  substitutions := (for i from 0 to #variables - 1 list variables_i => y_i);
  substitutions = substitutions | apply(select(generators ring C_0, g -> not member(g, variables)), g -> g => 1);

  return result / (v -> sub(v, substitutions));
);


-- Method:
-- given a list L and a list K such that (sum K) == #L, this functions divides L into sublists of length K_0, K_1, ...
divideList = method()
divideList(List,List) := (L,K) -> (
  counter := 0;
  for i from 0 to #K - 1 list (
    for j from 0 to K_i - 1 list L_(j + sum(for l from 0 to i - 1 list K_l))
  )
)
TEST ///
  L = {0,1,0};
  listOfRanks = {1,2};
  divideList(L, listOfRanks)
  L = {1,2,3,4,5,6,7};
  listOfRanks = {1,2,3,1};
  divideList(L, listOfRanks)
///
