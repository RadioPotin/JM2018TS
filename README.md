## Modified README.md
This repo has been modified in the context of my internship in static analysis at the CEA-LIST, France.

`GNUmakefile` was made to support both static analyzers [Frama-C](https://git.frama-c.com/pub/frama-c) and [Infer](https://github.com/facebook/infer).

It defaults to launching `Frama-c` on the test suite:
  - `make -j` launch analysis of all `.c` files in the test suite.
  - `make gui -j` launches `Frama-C`'s GUI.
  - `make evaluate -j` same as `make -j` but also launches a script that generates `eval_summary.txt` which sums up results regarding the handling of a variety of CWE by `Frama-C`, excluding some non-supported features like the analysis of recursive calls.
 
For `Infer`:
  - `make good -j` launches analysis for all "good" test cases. (cases in which no defect should be detected by the analyzer)
  - `make bad -j` launches analysis for all "bad" test cases. (cases in which defects *should* be detected by the analyzer)
  - `make infer_evaluate -j` same as `make evaluate -j` but instead launches `Infer` on the test suite and produces a file called `infer_eval_summary.txt` that summarizes the analyzer's performance.

# Original README.md forked from JMoerman's [repo](https://github.com/JMoerman/JM2018TS):
# About this test suite

This test suite was designed and used for my bachelor thesis "Evaluating the performance of open source static analysis tools".

This test suite was inspired by, and used in conjunction with the test suite presented in "Test-driving static analysis tools in search of c code vulnerabilities" by George Chatzieleftheriou and Panagiotis Katsaros.

## How to use this test suite

The .c files included in this test suite need to be preprocessed before use. The shellscript ```preprocess_files.sh``` can be used to accomplish this.

- ```preprocess_files.sh``` needs a unix like environment with gpp installed to work. 
- Usage: ```preprocess_files.sh [directory to process]```, for example ```preprocess_files.sh ./integers/overflow/```.
This should generate the sub directories ```test_correct``` (safe calls to unsafe functions), ```test_incorrect``` (unsafe calls to unsafe functions), ```test_lib_correct``` (safe functions, no entry point), ```test_lib_incorrect``` (unsafe functions, no entry point) and ```test_correct_catch_bad``` (safe calls to safe functions).
