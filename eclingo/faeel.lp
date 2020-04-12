% ...
katom(L,B2) :- ktuple(A,B1,B2), literal_tuple(B1,L).
rule(any(H),B) :- atom_tuple(H,_), rule(disjunction(H),B).
rule(any(H),B) :- atom_tuple(H,_), rule(     choice(H),B).

% ...
conjunction(B) :- literal_tuple(B),
       hold(L) :  literal_tuple(B, L), L > 0;
 fail(atom(L)) :  literal_tuple(B,-L), L > 0.

body(normal(B)) :- rule(any(_),normal(B)), conjunction(B).
body(sum(B,G))  :- rule(any(_),sum(B,G)),
    #sum { W,L :     hold(L), weighted_literal_tuple(B, L,W), L > 0 ;
           W,L : fail(atom(L)), weighted_literal_tuple(B,-L,W), L > 0 } >= G.

hold(A) :- atom_tuple(H,A), true(atom(A)), rule(any(H),B), body(B), not katom(A,_).
hold(A) :- katom(A,B2), conjunction(B2),
           conjunction(BB2) : scc(C,A), level(A,LA),
                              katom(AA,BB2), scc(C,AA), AA != A, level(AA,LAA), LAA<LA.

kscc(C,N) :- scc(C,_), N = #sum{ 1,A: scc(C,A), katom(A,_) }, N>1.
{ level(A,L) : scc(C,A), katom(A,_) } = 1 :- kscc(C,N), L=1..N.
:- kscc(C,_), scc(C,A), katom(A,_), { level(A,LA) } != 1.

hold(A) :- supp(A), not fact(A), bot.
faeel.

% preliminary
scc(faeel,A) :- katom(A,_).
