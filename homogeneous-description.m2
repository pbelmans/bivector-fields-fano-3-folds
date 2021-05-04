-*
Notation
In what follows, the pair F, E represents a product of Grassmannians and a homogeneous vector bundle on it
- F is given as a list {F1, F2, ..., Fn}, each element being a list made of two natural numbers representing the ith Grassmannian factor in the product.
  Example: {2, 5} represents Gr(2,5), while {1, 4} represents P^3. Thus F={{1, 4}, {2, 5}} will stand for P^3 x Gr(2,5).
- E is given as a list {E1, E2, ..., Em}, each element Ei representing an irreducible homogeneous bundle on F, summand of the bundle E.
  Each Ei is given as a list of n elements, where n is the number of factors of F. If Ei = {H1, ..., Hn}, each Hi represents an irreducible homogeneous bundle on the ith factor of F.
  Finally, a bundle H on a Grassmannian {k,l} is given as a list of l elements, to be interpreted in this way:
  - the first l-k elements give the Schur functor to be applied to the quotient bundle Q on Gr(k,l), whilst
  - the last k elements give the Schur functor to be applied to the tautological rank k bundle on Gr(k,l).
  The bundle H is the tensor product of the two Schur functors.
  Example: on F = {{1, 4}, {2, 5}}, we denote by U1, Q1 and U2, Q2 the tautological bundle of ranks 1,3,2,3 respectively. The bundle
  E = {
      {{0, 0, 0, 1}, {1, 1, 0, 1, 1}}, -- first summand; this is S_(0) Q1 \otimes S_(1) U1 \otimes S_(1,1) Q2 \otimes S_(1,1) U2, also known as O(-1) \boxproduct (wedge^2 Q2 (-1))
      {{0, 0, 0, 0}, {0, 0, 0, 1, 1}}, -- second summand; this is S_(0) Q1 \otimes S_(0) U1 \otimes S_(0) Q2 \otimes S_(1,1) U2, also known as O \boxproduct O(-1)
      {{0, 0, 0, 0}, {0, 0, 0, 1, 1}}, -- third summand; this is S_(0) Q1 \otimes S_(0) U1 \otimes S_(0) Q2 \otimes S_(1,1) U2, also known as O \boxproduct O(-1)
      {{0, 0, 0, 0}, {0, 0, 0, 1, 1}}  -- fourth summand; this is S_(0) Q1 \otimes S_(0) U1 \otimes S_(0) Q2 \otimes S_(1,1) U2, also known as O \boxproduct O(-1)
    }
  thus represents O_{Gr(2,5)}(-1)^{\oplus 3} \otimes (O_{P^3}(-1) \boxtimes Q*_{Gr(2,5)}).
*-

homogeneous = new MutableHashTable;

F = {{2, 5}};
E = {
      {{0, 0, 0, 2, 2}},
      {{0, 0, 0, 1, 1}},
      {{0, 0, 0, 1, 1}}
    };
homogeneous#"1-5" = {F, E};

F = {{2, 5}};
E = {
      {{0, 0, 0, 2, 1}},
      {{0, 0, 0, 1, 1}}
    };
homogeneous#"1-6" = {F, E};

F = {{2, 6}}
E = {
      {{0, 0, 0, 0, 1, 1}},
      {{0, 0, 0, 0, 1, 1}},
      {{0, 0, 0, 0, 1, 1}},
      {{0, 0, 0, 0, 1, 1}},
      {{0, 0, 0, 0, 1, 1}}
    };
homogeneous#"1-7" = {F, E};

F = {{3, 6}};
E = {
      {{0, 0, 0, 1, 1, 0}},
      {{0, 0, 0, 1, 1, 1}},
      {{0, 0, 0, 1, 1, 1}},
      {{0, 0, 0, 1, 1, 1}}
    };
homogeneous#"1-8" = {F, E};

F = {{2, 7}};
E = {
      {{1, 0, 0, 0, 0, 1, 1}},
      {{0, 0, 0, 0, 0, 1, 1}},
      {{0, 0, 0, 0, 0, 1, 1}}
    };
homogeneous#"1-9" = {F, E};

F = {{3, 7}};
E = {
      {{0, 0, 0, 0, 1, 1, 0}},
      {{0, 0, 0, 0, 1, 1, 0}},
      {{0, 0, 0, 0, 1, 1, 0}}
    };
homogeneous#"1-10" = {F, E};

F = {{2, 5}};
E = {
      {{0, 0, 0, 1, 1}},
      {{0, 0, 0, 1, 1}},
      {{0, 0, 0, 1, 1}}
    };
homogeneous#"1-15" = {F, E};

F = {{1, 2}, {2, 5}};
E = {
      {{0, 1}, {0, 0, 0, 1, 1}},
      {{0, 0}, {0, 0, 0, 1, 1}},
      {{0, 0}, {0, 0, 0, 1, 1}},
      {{0, 0}, {0, 0, 0, 1, 1}}
    };
homogeneous#"2-14" = {F, E};

F = {{2, 4}, {1, 4}};
E = {
      {{0, 0, 1, 0}, {0, 0, 0, 1}},
      {{0, 0, 1, 1}, {0, 0, 0, 1}},
      {{0, 0, 1, 1}, {0, 0, 0, 0}}
    };
homogeneous#"2-17" = {F, E};

F = {{1, 3}, {2, 5}};
E = {
      {{0, 0, 1}, {0, 0, 0, 1, 0}},
      {{0, 0, 0}, {0, 0, 0, 1, 1}},
      {{0, 0, 0}, {0, 0, 0, 1, 1}},
      {{0, 0, 0}, {0, 0, 0, 1, 1}}
    };
homogeneous#"2-20" = {F, E};

F = {{1, 5}, {2, 4}};
E = {
      {{0, 0, 0, 0, 1}, {0, 0, 1, 0}},
      {{0, 0, 0, 0, 0}, {0, 0, 1, 1}},
      {{0, 0, 0, 0, 1}, {0, 0, 1, 0}}
    };
homogeneous#"2-21" = {F, E};

F = {{1, 4}, {2, 5}};
E = {
      {{0, 0, 0, 1}, {1, 1, 0, 1, 1}},
      {{0, 0, 0, 0}, {0, 0, 0, 1, 1}},
      {{0, 0, 0, 0}, {0, 0, 0, 1, 1}},
      {{0, 0, 0, 0}, {0, 0, 0, 1, 1}}
    };
homogeneous#"2-22" = {F, E};

F = {{2, 4}, {2, 5}};
E = {
      {{1, 0, 1, 1}, {0, 0, 0, 1, 0}},
      {{0, 0, 1, 1}, {0, 0, 0, 0, 0}},
      {{0, 0, 0, 0}, {0, 0, 0, 1, 1}},
      {{0, 0, 0, 0}, {0, 0, 0, 1, 1}}
    };
homogeneous#"2-26" = {F, E};

F = {{1, 2}, {1, 3}, {1, 2}};
E = {
      {{0, 2}, {0, 0, 2}, {0, 0}}
    };
homogeneous#"9-1" = {F, E};
