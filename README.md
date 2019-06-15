# Reproducible Research (RR@AGILE) workshop - AGILE 2019
Limassol, 17.6.2019

This is the introductory session of the [Reproducible Research (RR@AGILE) workshop](https://o2r.info/reproducible-agile/2019/) at the [AGILE 2019](https://agile-online.org/) conference. This year, the workshop is centred on the results of the [AGILE initiative on Reproducible Research](https://o2r.info/reproducible-agile/initiative/), which aimed to discuss and draft the [Reproducible Publication Guidelines](https://osf.io/phmce/) or AGILE authors.

Reproducibility can be tackled from the perspective of readers/reviewers or authors. The idea in this workshop is to take both perspectives and to get you started with the tools and platforms that increase the level of reproducibility of computational analyses.

## Part 1: Reader/reviewer perspective

### Example 1 - Supplementary code in R.

The task is to read through the provided publication and reproduce the analysis based on the provided R script and input data in [this folder](https://github.com/cgranell/agile2019/tree/master/Readers_Example1). Depending on your previous knowledge of R this might or might not require getting familiar with the specific computational environment chosen by the authors of the publication of interest. 


**Provided material**: A publication (paper) with an R analysis and input data as supplementary material [download](https://github.com/cgranell/agile2019/tree/master/Readers_Example1)  

**Software required**: [R Studio](https://www.rstudio.com/products/rstudio/download/)

**Outputs**: successful run through the R script leading to the plot contained in the paper.

Questions to discuss:
* Which benefits do you observe from providing code and data together with the publication?
* Do the figures resulting from the R Script match the figures in the text document?
* What could make the job of you as a reader/reviewer easier?


### Example 2 - Python Notebook using Binder
Now, you are asked to work through this [Geopandas tutorial](https://github.com/jorisvandenbossche/geopandas-tutorial) tutorial and to assess the improvements regarding reproducibility in comparison to the first example. 
Look at the repo, examine the files it contains, and start an interactive session on [Binder](https://mybinder.org/) for the first file of the tutorial `01-introduction-geospatial-data.ipynb`. If you feel comfortable with Python, feel fee to run other files of the tutorial.

**Provided material**: [Geopandas tutorial](https://github.com/jorisvandenbossche/geopandas-tutorial)


## Part 2: Author perspective

### Example 1 - Create an reproducible version of the paper as an R notebook.

The author perspective focuses on the reproducibility of research work using R, GitHub and Binder. The guiding principle is to integrate the computational analysis with the text using R Markdown and providing future readers with the computational environment used during development by means of a Binder repository. 
* _R/RStudio_ is your analysis code and development environment. 
* _Github_ is a control version system to trace the changes of your analysis
* _Binder_ generates a virtual execution environment so that others can recreate your analsys with identical execution conditions. 

Therefore, you commit your R code in a remote repository in GitHub, and Binder takes it as input to create a virtual container to run your R code on the cloud.

*Software required*: R Studio, GitHub (or GitLab) account, [myBinder](https://mybinder.org/)

*Provided material*: R script (.R file) + incomplete R Markdown document (.Rmd) in this [folder](https://github.com/cgranell/agile2019/tree/master/Authors_Example1). 

*Background material*: [Chapter 4 git with RStudio and GitLab](https://vickysteeves.gitlab.io/repro-papers/git.html), and [Chapter 5 R Markdown in reproducible research](https://vickysteeves.gitlab.io/repro-papers/r-markdown-in-reproducible-research.html), from the  EGU 2018 course session on [Writing reproducible geoscience papers using R Markdown, Docker, and GitLab](https://vickysteeves.gitlab.io/repro-papers/index.html) by Daniel Nüst, Vicky Steeves, Rémi Rampin, Markus Konkol, Edzer Pebesma.

Outputs: 
* Complete .Rmd file adding code chunks (map creation) + r expressions
* Add a software and data availability statement to the R Markdown according to the [reproducible paper guidelines](https://osf.io/c8peu/)

### Example Complete - Run R notebook on Binder.

Outputs: 
* Add the Binder configuration to execute remotely the R markdown file

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/cgranell/agile2019/master)
