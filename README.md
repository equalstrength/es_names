# Overview

The code in this replication package generates the analytical material described on the paper "*The perception of names in experimental studies on ethnic origin: a cross-national validation in Europe*" based on a comparative study conducted across nine European countries (Ghekiere et al, 2023). 

# Data Availability

The data for this project are under embargo until XXXXX.

## Statement about Rights

- [X] I certify that the author(s) of the manuscript have legitimate access to and permission to use the data used in this manuscript. 
- [X] I certify that the author(s) of the manuscript have documented permission to redistribute/publish the data contained within this replication package. Appropriate permission are documented in the [LICENSE.txt](LICENSE.txt) file.


## License for Data

The data are licensed under a Creative Commons/CC-BY-NC license. See LICENSE.txt for details.

## Summary of Availability

- [X] All data **are** publicly available.
- [ ] Some data **cannot be made** publicly available.
- [ ] **No data can be made** publicly available.



### Software Requirements

- [X] The replication package contains one or more programs to install all dependencies and set up the necessary directory structure.

- R version 4.4.1
  - `tidyverse` (2.0.0)
  - `haven` (2.5.4)
  - `gt` (0.10.1)
  - `sjPlot` (2.8.16)
  - the file "[`0_setup.R`](0_setup.R)" will install all dependencies (latest version), and should be run once prior to running other programs.


#### Summary

Approximate time needed to reproduce the analyses on a standard (CURRENT YEAR) desktop machine:

- [X] <10 minutes
- [ ] 10-60 minutes
- [ ] 1-2 hours
- [ ] 2-8 hours
- [ ] 8-24 hours
- [ ] 1-3 days
- [ ] 3-14 days
- [ ] > 14 days

Approximate storage space needed:

- [X] < 25 MBytes
- [ ] 25 MB - 250 MB
- [ ] 250 MB - 2 GB
- [ ] 2 GB - 25 GB
- [ ] 25 GB - 250 GB
- [ ] > 250 GB



## Description of code

- Code in "[`0_setup.R`](0_setup.R)" will check the installed packages and install the required ones if not installed yet.
- Code in "[`1_process.R`](1_process.R)" will process all national raw data, combine them into one dataset, transform and recode variables, generate derived variables and export the working dataset. 
- Code in "[`2_analysis.R`](2_analysis.R)" will import the workigng dataset and generate all tables and figures present in the publication.

### License for Code

The code is licensed under a CC BY-NC-SA 4.0 license. See [LICENSE.txt](LICENSE.txt) for details.

## List of tables and programs

The provided code reproduces:

- [ ] All numbers provided in text in the paper
- [X] All tables and figures in the paper
- [ ] Selected tables and figures in the paper, as explained and justified below.


| Figure/Table #    | Program                         | Line Number | Output file                      | Note                            |
|-------------------|---------------------------------|-------------|----------------------------------|---------------------------------|
| Table 1.1         | [`2_analysis.R`](2_analysis.R)  |    17       | [`tb_sample.png`](img/tb_sample.png) ||
| Figure 2.1        | [`2_analysis.R`](2_analysis.R)  |    29       | [`fig_ols.png`](img/fig_ols.png)     ||
| Table 2.1         | [`2_analysis.R`](2_analysis.R)  |    57       | [`tb_nigeria.png`](img/tb_nigeria.png) ||


## References

---

## Acknowledgements


