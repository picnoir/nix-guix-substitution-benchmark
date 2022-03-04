# Nix/Guix Substitution Efficiency Benchmark

This benchmark consists in a data acquisition part (`./compareSubsEfficiency`) and a data processing part, a Jupyter Notebook (`./analysis-notebook/Analysis.ipynb`).

You can perform the data acquisition with:

```sh
./compareSubsEfficiency analysis-notebook/bench-results
```

You can perform the data processing with:

```sh
cd analysis-notebook
nix-shell
jupyter-lab
```
