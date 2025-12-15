#!/usr/bin/env wolframscript
(* Converted Mathematica script from SymbolicTest.nb *)
(* This script contains all functional definitions and test cases *)


ClearAll["Global`*"]

(* User input for angular momentum quantum numbers *)
lmax = Input["Enter maximum orbital angular momentum (lmax): ", 0];
lprimemax = Input["Enter maximum primed orbital angular momentum (lprimemax): ", 0];
Lmax = lmax + lprimemax;


(* ============ SYMBOLIC DEFINITIONS ============ *)

(* Wave label mapping *)
lToWave[l_Integer] := Switch[l, 
  0, S, 
  1, P, 
  2, Symbol["D"], 
  3, F, 
  _, ToString[l]
];

epsToStr[eps_] := Switch[eps, 
  1, "+", 
  -1, "-", 
  _, "+"
];

(* Custom formatting for Rho *)
MakeBoxes[Rho[α_, l1_, l2_, m1_, m2_], TraditionalForm] := SubsuperscriptBox[
  "ρ",
  RowBox[{MakeBoxes[m1, TraditionalForm], MakeBoxes[m2, TraditionalForm]}],
  RowBox[{MakeBoxes[α, TraditionalForm], ",", MakeBoxes[l1, TraditionalForm], MakeBoxes[l2, TraditionalForm]}]
];

(* Custom formatting for T and L *)
Format[T[l_, eps_, m_]] := Subsuperscript[(lToWave[l]), (T, m), epsToStr[eps]];
Format[L[l_, eps_, m_]] := Subsuperscript[(lToWave[l]), (L, m), epsToStr[eps]];

(* H moments definition in terms of SDMEs*)
(* H^alpha where alpha > 0 has intrinic negative built in*)
H[α_, L_, M_] /; α > 0 := -Sum[
  ((2 l2 + 1)/(2 l1 + 1)) *
  Quiet@ClebschGordan[{l2, 0}, {L, 0}, {l1, 0}] *
  Quiet@ClebschGordan[{l2, m2}, {L, M}, {l1, m2}] *
  Rho[α, l1, l2, m1, m2],
  {l1, 0, lmax}, {l2, 0, lprimemax},
  {m1, -l1, l1}, {m2, -l2, l2}
];

H[α_, L_, M_] /; α == 0 := Sum[
  ((2 l2 + 1)/(2 l1 + 1)) *
  Quiet@ClebschGordan[{l2, 0}, {L, 0}, {l1, 0}] *
  Quiet@ClebschGordan[{l2, m2}, {L, M}, {l1, m2}] *
  Rho[α, l1, l2, m1, m2],
  {l1, 0, lmax}, {l2, 0, lprimemax},
  {m1, -l1, l1}, {m2, -l2, l2}
];

(* SDME in reflectivity basis *)
SDMRE[α_, l1_, l2_, m1_, m2_, eps_] := Piecewise[{
  (* α = 0 *)
  {T[l1, eps, m1] Conjugate[T[l2, eps, m2]] + 
   (-1)^(m2 - m1) T[l1, eps, -m1] Conjugate[T[l2, eps, -m2]],
   α == 0},
  
  (* α = 1 *)
  {-eps ((-1)^m1 T[l1, eps, -m1] Conjugate[T[l2, eps, m2]] + 
         (-1)^m2 T[l1, eps, m1] Conjugate[T[l2, eps, -m2]]),
   α == 1},
  
  (* α = 2 *)
  {-I eps ((-1)^m1 T[l1, eps, -m1] Conjugate[T[l2, eps, m2]] - 
           (-1)^m2 T[l1, eps, m1] Conjugate[T[l2, eps, -m2]]),
   α == 2},
  
  (* α = 3 *)
  {T[l1, eps, m1] Conjugate[T[l2, eps, m2]] - 
   (-1)^(m2 - m1) T[l1, eps, -m1] Conjugate[T[l2, eps, -m2]],
   α == 3},
  
  (* α = 4 *)
  {2 L[l1, eps, m1] Conjugate[L[l2, eps, m2]],
   α == 4},
  
  (* α = 5 *)
  {-1/Sqrt[2] (
    (-1)^m1 (L[l1, eps, m1] Conjugate[T[l2, eps, m2]] - 
             T[l1, eps, m1] Conjugate[L[l2, eps, m2]]) +
    (-1)^m2 (L[l1, eps, m2] Conjugate[T[l2, eps, m1]] - 
             T[l1, eps, m2] Conjugate[L[l2, eps, m1]])),
   α == 5},
  
  (* α = 6 *)
  {I/Sqrt[2] (
    L[l1, eps, m1] Conjugate[T[l2, eps, m2]] - 
    T[l1, eps, m1] Conjugate[L[l2, eps, m2]] - 
    eps ((-1)^m2 (L[l1, eps, m2] Conjugate[T[l2, eps, m1]] - 
                  T[l1, eps, m2] Conjugate[L[l2, eps, m1]]))),
   α == 6},
  
  (* α = 7 *)
  {-1/Sqrt[2] (
    eps ((-1)^m1 (L[l1, eps, m1] Conjugate[T[l2, eps, m2]] + 
                  T[l1, eps, m1] Conjugate[L[l2, eps, m2]])) +
    (-1)^m2 (L[l1, eps, m2] Conjugate[T[l2, eps, m1]] + 
             T[l1, eps, m2] Conjugate[L[l2, eps, m1]])),
   α == 7},
  
  (* α = 8 *)
  {I/Sqrt[2] (
    L[l1, eps, m1] Conjugate[T[l2, eps, m2]] - 
    T[l1, eps, m1] Conjugate[L[l2, eps, m2]] + 
    eps ((-1)^m1 (Conjugate[L[l1, eps, m1]] T[l2, eps, m2] - 
                  Conjugate[T[l1, eps, m1]] L[l2, eps, m2]))),
   α == 8}
}];

(* Builds the moments H in terms of partial waves (expanding SDMEs) *)
HWaves[α_, L_, M_] := Sum[
  ((2 l2 + 1)/(2 l1 + 1)) *
  Quiet@ClebschGordan[{l2, 0}, {L, 0}, {l1, 0}] *
  Quiet@ClebschGordan[{l2, m2}, {L, M}, {l1, m2}] *
  (SDMRE[α, l1, l2, m1, m2,1] + SDMRE[α, l1, l2, m1, m2,-1]),
  {l1, 0, lmax}, {l2, 0, lprimemax},
  {m1, -l1, l1}, {m2, -l2, l2}
];

(* Rho symmetry rules *)
Rho /: Rho[a_, l1_, l2_, m1_, m2_] /; (
  (m1 < 0 || m2 < 0) && 
  MemberQ[{2, 3, 5, 6}, a] && 
  m1 != -m2
) := -((-1)^(m1 - m2)) Rho[a, l1, l2, -m1, -m2];

Rho /: Rho[a_, l1_, l2_, m1_, m2_] /; (
  m1 < 0 && m1 == -m2 && 
  MemberQ[{2, 3, 5, 6}, a]
) := -((-1)^(m1 - m2)) Rho[a, l1, l2, -m1, -m2];

Rho /: Rho[a_, l1_, l2_, m1_, m2_] /; (
  (m1 < 0 || m2 < 0) && 
  MemberQ[{0, 1, 4, 7, 8}, a] && 
  m1 != -m2
) := ((-1)^(m1 - m2)) Rho[a, l1, l2, -m1, -m2];

Rho /: Rho[a_, l1_, l2_, m1_, m2_] /; (
  m1 < 0 && m1 == -m2 && 
  MemberQ[{0, 1, 4, 7, 8}, a]
) := ((-1)^(m1 - m2)) Rho[a, l1, l2, -m1, -m2];

(* Complex number simplification tools *)

(* Functional version of the cleaner *)
toReImPair[expr_] := expr //. SimplifyComplex;

(* Cleaner, forces conversion to real and imaginary sums*)
SimplifyComplex = {
  ruleAbs = a_ Conjugate[a_] :> Abs[a]^2,
  
  c_. (a_. Conjugate[b_.] + b_. Conjugate[a_.]) :> 
   2 c Re[a Conjugate[b]], 
  c_. (a_. Conjugate[b_.] - b_. Conjugate[a_.]) :> 
   2 I c Im[a Conjugate[b]],
  c_. (z_ + Conjugate[z_]) :> 2 c Re[z],
  c_. (z_ - Conjugate[z_]) :> 2 I c Im[z],
  
   (c_. a_. Conjugate[b_.] + c_. b_. Conjugate[a_.]) :> 
   2 c Re[a Conjugate[b]], (c_. a_. Conjugate[b_.] + 
      d_. b_. Conjugate[a_.]) /; d === -c :> 2 I c Im[a Conjugate[b]],
   (c_. z_ + c_. Conjugate[z_]) :> 2 c Re[z],
  (c_. z_ + d_. Conjugate[z_]) /; d === -c :> 2 I c Im[z]
};

(* ============ TESTING SECTION ============ *)

(* Test 1: SDMRE with SimplifyComplex *)
(*
Print["Test 1: SDMRE[0,1,1,1,1,1] with SimplifyComplex"];
Print[SDMRE[0, 1, 1, 1, 1, 1] /. SimplifyComplex];
Print[""];

(* Test 2: Sum of Rho *)
Print["Test 2: Sum of Rho[0,l1,l2,m1,m2] over all indices"];
Print[Sum[Rho[0, l1, l2, m1, m2],
  {l1, 0, 1}, {l2, 0, 1},
  {m1, -l1, l1}, {m2, -l2, l2}
]];
Print[""];
*)

(* ============ FILE EXPORT SECTION ============ *)

(* Create results directory if it doesn't exist *)
resultsDir = FileNameJoin[{NotebookDirectory[], "results"}];
If[!DirectoryQ[resultsDir], CreateDirectory[resultsDir]];

(* Export moments in terms of SDMEs to LaTeX *)
outputFile = FileNameJoin[{resultsDir, "MomentsAnalytic.tex"}];
content = StringJoin["% Auto-generated H^{\\alpha}(L,M)\n \\begin{align*} \n"];

For[al = 0, al <= 8, al++,
  For[Li = 0, Li <= Lmax, Li++,
    For[M = 0, M <= Li, M++,
      rhs = H[al, Li, M];
      content = StringJoin[content,
        "  H^{", ToString@TeXForm[al], "}(",
        ToString@TeXForm[Li], ToString@TeXForm[M], ")  &= ",
        ToString@TeXForm@FullSimplify[rhs],
        " \\\\ \n"
      ];
    ]
  ]
];

content = StringJoin[content, "\\end{align*}\n"];
Export[outputFile, content, "String"];
Print["Exported moments to " <> outputFile];

(* Export expanded SDMEs in terms of partial-waves to LaTeX *)
file = FileNameJoin[{resultsDir, "sdmes_expanded.tex"}];
content = StringJoin["% Expanded SDMEs in terms of partial-waves \n \\begin{align*}\n"];

For[alpha = 0, alpha <= 8, alpha++,
  For[l1 = 0, l1 <= lmax, l1++,
    For[l2 = 0, l2 <= lprimemax, l2++,
      For[m1 = -l1, m1 <= l1, m1++,
        For[m2 = -l2, m2 <= l2, m2++,
          lhs = Rho[alpha, l1, l2, m1, m2];
          rhs = SDMRE[alpha, l1, l2, m1, m2, 1];
          content = StringJoin[content,
            ToString@TeXForm[lhs], " &= ",
            ToString@TeXForm@FullSimplify[rhs /. SimplifyComplex],
            " \\\\ \n"
          ];
        ]
      ]
    ]
  ]
];

content = StringJoin[content, "\\end{align*}\n"];
Export[file, content, "String"];
Print["Exported SDMEs in terms of partial waves to " <> file];

(* Export moments in terms of partial-waves to LaTeX *)
outputFile = FileNameJoin[{resultsDir, "MomentsWaves.tex"}];
content = 
  StringJoin["% Auto-generated H^{\\alpha}(L,M) in terms of partial-waves\n \\begin{align*} \n"];

For[alpha = 0, alpha <= 8, alpha++,
 For[Li = 0, Li <= Lmax, Li++,
  For[M = 0, M <= Li, M++,
   content = 
    StringJoin[content, "  H^{", ToString@TeXForm[alpha], "}(", 
     ToString@TeXForm[Li], ToString@TeXForm[M], ")  &= "];
   rhs = 0;
   For[l1 = 0, l1 <= Lmax, l1++,
    For[l2 = 0, l2 <= lprimemax, l2++,
     For[m1 = -l1, m1 <= l1, m1++,
      For[m2 = -l2, m2 <= l2, m2++,
       rhs += ((2 l2 + 1)/(2 l1 + 1))*
          Quiet@ClebschGordan[{l2, 0}, {Li, 0}, {l1, 0}]*
          Quiet@ClebschGordan[{l2, m2}, {Li, M}, {l1, m2}]*(SDMRE[
             alpha, l1, l2, m1, m2, -1] + 
            SDMRE[alpha, l1, l2, m1, m2, 1]);
       ]
      ]
     ]
    ];
   If[alpha == 0, rhs = -rhs];
   Print[FullSimplify[rhs //. SimplifyComplex]];
   content = 
    StringJoin[content, 
     ToString@TeXForm@FullSimplify[rhs //. SimplifyComplex] , " \\\\ \n"];
   ]
  ]
 ]


content = StringJoin[content, "\\end{align*}\n"];
Export[outputFile, content, "String"];
Print["Exported moments in terms of partial-waves to " <> outputFile];

(* Intensities in terms of SDMEs and angular terms*)
outputFile = FileNameJoin[{resultsDir, "IntensitiesAnalytic.tex"}];
content = 
  StringJoin["% Auto-generated I^{\\alpha}(\\theta, \\phi) in terms of SDMEs and angular terms\n \\begin{align*} \n"];
For[al = 0, al <= 8, al++,
  rhs = 0;
  For[Li = 0, Li <= Lmax, Li++,
   For[M = 0, M <= Li, M++,
    rhs += ((2 Li + 1)/(4 Pi)) H[al, Li, M]*
       Refine[Conjugate[
         WignerD[{Li, 0, -M}, \[Theta], \[Phi]]], {Element[\[Theta], 
          Reals], Element[\[Phi], Reals]}];
    ]
   ];
  If[al != 0, rhs = -rhs];
  content = 
   StringJoin[content, "  I^{", ToString@TeXForm[al], "} &= " , 
    ToString@TeXForm[1/Denominator@FullSimplify[rhs]], "\\left[", 
    ToString@TeXForm@Numerator@Simplify[rhs], "\\right] \\\\ \n"];
  ];
content = StringJoin[content, "\\end{align*}\n"];
Export[outputFile, content, "String"];
Print["Exported intensities to " <> outputFile];

Print["Script execution completed successfully."];
