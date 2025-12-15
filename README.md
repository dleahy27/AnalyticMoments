# Intensities, Moments and SDMEs — Script and Notebook

This repository contains a Wolfram Language script (`SymbolicTest.wl`) and a companion notebook (`SymbolicTest.nb`) for analytically generating spin–density matrix elements (SDMEs), moments H, and intensities I(θ, φ). Both produce LaTeX outputs collected under a local `results/` directory. Can be edited to produce raw terminal/notebook outputs, but LaTeX outputs were chosen for the ease of directly exporting the results. Of note, our partial-wave expansions are always given in terms of the reflectivity basis and our target/nucleon helicities are given in terms of the index $k$. Here, the $k$-basis just refers to either the non-spin-flip k=0 state (++ or --) or the spin-flip k=1 state (+- or -+).

## Files
- `SymbolicTest.wl`: Runnable Wolfram Language script (CLI) with interactive prompts.
- `SymbolicTest.nb`: Interactive Mathematica notebook for exploration and generation.
- `results/`: Created on first run; contains LaTeX outputs:
  - `MomentsAnalytic.tex`: Contains the moments in terms of SDMEs
  - `sdmes_expanded.tex`: Contains the SDMEs, expanded in terms of the partial-waves
  - `MomentsWaves.tex`: Contains the moments, expanded in terms of partial-waves
  - `IntensitiesAnalytic.tex`: Contains the intensities in terms of the SDMEs and the corresponding angular functions

## Requirements
- Wolfram Language/Mathematica or Wolfram Engine
- `wolframscript` available on PATH (for CLI script runs)

## Run — Script (`SymbolicTest.wl`)
You can run the script either interactively (it prompts for `lmax` and `lprimemax`) or non‑interactively by piping values.

Interactive (prompts):
```bash
# Option A: run directly if executable
chmod +x SymbolicTest.wl
./SymbolicTest.wl

# Option B: via wolframscript
wolframscript -file SymbolicTest.wl
```

Non‑interactive (example with lmax = 0, lprimemax = 0):
```bash
printf "0\n0\n" | wolframscript -file SymbolicTest.wl
```

Outputs are written to `results/` next to the script. The script prints progress messages and the export locations when done.

> Note: The script currently computes and writes:
> - Moments H in terms of SDMEs (`MomentsAnalytic.tex`)
> - Expanded SDMEs in terms of partial waves (`sdmes_expanded.tex`)
> - Moments H explicitly expanded in partial waves (`MomentsWaves.tex`)
> - Analytic intensities I(θ, φ) in terms of SDMEs + angular terms (`IntensitiesAnalytic.tex`)

### Results directory resolution (CLI vs notebook)
The file export section creates `results/` using `NotebookDirectory[]`. When running as a pure script (no notebook front end), `NotebookDirectory[]` may be unavailable. If you encounter an error creating the `results` folder, consider changing the results directory line in `SymbolicTest.wl` to this more robust variant:
```wolfram
resultsDir = FileNameJoin[{
  If[StringQ[$InputFileName] && $InputFileName != "",
     DirectoryName[$InputFileName],
     Directory[]
  ],
  "results"
}];
If[!DirectoryQ[resultsDir], CreateDirectory[resultsDir]];
```
If you want, I can apply this patch for you.

## Run — Notebook (`SymbolicTest.nb`)
1. Open `SymbolicTest.nb` in Mathematica.
2. Set the values of `lmax` and `lprimemax` in the parameter cell (or at the prompts, if present).
3. Evaluate all cells (Kernel → Evaluation → Evaluate Notebook).
4. The outputs will be exported to the `results/` directory next to the notebook.

## Example: lmax = lprimemax = 0
This is the smallest configuration (S‑wave only, m = 0). You can generate it with either the script or the notebook.

Script (non‑interactive):
```bash
printf "0\n0\n" | wolframscript -file SymbolicTest.wl
ls -1 results/
```
Expected files:
```
IntensitiesAnalytic.tex
MomentsAnalytic.tex
MomentsWaves.tex
sdmes_expanded.tex
```

You can open these `.tex` files directly, copy the contents over or include them via `\input{results/<file>.tex}` in a LaTeX document.

### Sample Output for lmax = lprimemax = 0

**MomentsAnalytic.tex** (excerpt):
```latex
% Auto-generated H^{\alpha}(L,M)
 \begin{align*} 
  H^{0}(00)  &= \rho _{00}^{0,00}\\ 
  H^{1}(00)  &= -\rho _{00}^{1,00}\\ 
  H^{2}(00)  &= -\rho _{00}^{2,00}\\ 
  H^{3}(00)  &= -\rho _{00}^{3,00}\\ 
  H^{4}(00)  &= -\rho _{00}^{4,00}\\ 
  H^{5}(00)  &= -\rho _{00}^{5,00}\\ 
  H^{6}(00)  &= -\rho _{00}^{6,00}\\ 
  H^{7}(00)  &= -\rho _{00}^{7,00}\\ 
  H^{8}(00)  &= -\rho _{00}^{8,00}\\ 
\end{align*}
```

**sdmes_expanded.tex** (excerpt):
```latex
    % Expanded SDMEs in reflectivity basis 
    \begin{align*}
    \rho _{00}^{0,00} &= 2 \left(\left| S_{T,0}^-\right| {}^2+\left| S_{T,0}^+\right| {}^2\right) \\ 
    \rho _{00}^{1,00} &= 2 \left(\left| S_{T,0}^-\right| {}^2-\left| S_{T,0}^+\right| {}^2\right) \\ 
    \rho _{00}^{2,00} &= 0 \\ 
    \rho _{00}^{3,00} &= 0 \\ 
    \rho _{00}^{4,00} &= 2 \left(\left| S_{L,0}^-\right| {}^2+\left| S_{L,0}^+\right| {}^2\right) \\ 
    \rho _{00}^{5,00} &= -2 i \sqrt{2} \Im\left(S_{L,0}^- S_{T,0}^-{}^*+S_{L,0}^+ S_{T,0}^+{}^*\right) \\ 
    \rho _{00}^{6,00} &= -2 \sqrt{2} \Im\left(S_{L,0}^- S_{T,0}^-{}^*\right) \\ 
    \rho _{00}^{7,00} &= -2 \sqrt{2} \Re\left(S_{L,0}^+ S_{T,0}^+{}^*\right) \\ 
    \rho _{00}^{8,00} &= -2 \sqrt{2} \Im\left(S_{L,0}^- S_{T,0}^-{}^*\right) \\ 
    \end{align*}
```

**MomentsWaves.tex** (excerpt):
```latex
% Auto-generated H^{\alpha}(L,M)
 \begin{align*} 
  H^{0}(00)  &= -2 \left(\left| S_{T,0}^-\right| {}^2+\left| S_{T,0}^+\right| {}^2\right) \\ 
  H^{1}(00)  &= 2 \left(\left| S_{T,0}^-\right| {}^2-\left| S_{T,0}^+\right| {}^2\right) \\ 
  H^{2}(00)  &= 0 \\ 
  H^{3}(00)  &= 0 \\ 
  H^{4}(00)  &= 2 \left(\left| S_{L,0}^-\right| {}^2+\left| S_{L,0}^+\right| {}^2\right) \\ 
  H^{5}(00)  &= -2 i \sqrt{2} \Im\left(S_{L,0}^- S_{T,0}^-{}^*+S_{L,0}^+ S_{T,0}^+{}^*\right) \\ 
  H^{6}(00)  &= -2 \sqrt{2} \Im\left(S_{L,0}^- S_{T,0}^-{}^*\right) \\ 
  H^{7}(00)  &= -2 \sqrt{2} \Re\left(S_{L,0}^+ S_{T,0}^+{}^*\right) \\ 
  H^{8}(00)  &= -2 \sqrt{2} \Im\left(S_{L,0}^- S_{T,0}^-{}^*\right) \\ 
\end{align*}
```

**IntensitiesAnalytic.tex** (excerpt):
```latex
% Auto-generated H^{\alpha}(L,M)
 \begin{align*} 
  I^{0} &= \frac{1}{4 \pi }\left[\rho _{00}^{0,00}\right] \\ 
  I^{1} &= \frac{1}{4 \pi }\left[\rho _{00}^{1,00}\right] \\ 
  I^{2} &= \frac{1}{4 \pi }\left[\rho _{00}^{2,00}\right] \\ 
  I^{3} &= \frac{1}{4 \pi }\left[\rho _{00}^{3,00}\right] \\ 
  I^{4} &= \frac{1}{4 \pi }\left[\rho _{00}^{4,00}\right] \\ 
  I^{5} &= \frac{1}{4 \pi }\left[\rho _{00}^{5,00}\right] \\ 
  I^{6} &= \frac{1}{4 \pi }\left[\rho _{00}^{6,00}\right] \\ 
  I^{7} &= \frac{1}{4 \pi }\left[\rho _{00}^{7,00}\right] \\ 
  I^{8} &= \frac{1}{4 \pi }\left[\rho _{00}^{8,00}\right] \\ 
\end{align*}
```

## Troubleshooting
- "Cannot create results directory": See the note above about replacing `NotebookDirectory[]` with a `$InputFileName`/`Directory[]` fallback when running from CLI.
- "wolframscript: command not found": Ensure Wolfram Engine or Mathematica is installed and `wolframscript` is on your PATH.
- Long runtimes for larger `lmax`/`lprimemax`: Start with small values (e.g., 0 or 1) to validate setup before scaling up.

## Repro tips
- To rerun with different `lmax`, `lprimemax`, simply run the script again and enter new values when prompted.
- The script overwrites the `.tex` files in `results/`; delete the folder to start fresh if needed.
