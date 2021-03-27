# MAGE
MAGE method implementation and code to reproduce graphics and results in associated paper: [Link to be added].

## How to Reproduce Graphics & Results
**General Use:** Open the file ```/graphics_scripts/graphics.R``` in R Studio and run it. All the necessary R files and functions will be sourced automatically, and plots will be generated. To view a specific plot, please source the entire `graphics.R` file first, then run the function to create the desired plot (e.g. `plot_heatmap` or `plot_boxplot`).

Only the data with the final results of the different algorithms is included due to privacy concerns - follow the instructions below to start with the initial data and run every function on your own.

**File Specific Instructions**
1. Obtain the following publicly available data sets from [Awesome-CGM](https://github.com/irinagain/Awesome-CGM) and run their respective preprocessor scripts. Put the resulting csv files in the `/graphics_scripts/data/` folder **with the names given below**:
	- Hall (2018) => "Hall2018_processed.csv"
	- Tsalikian (2005) => "Tsalikian2005_processed.csv"
	- Dubosson (2018) => "Dubosson2018_processed.csv"

2. Run the `/graphics_scripts/load_data.R` function to properly extract the needed data.

## R Packages Needed
- [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html)
- [iglu](https://cran.r-project.org/web/packages/iglu/index.html)
- [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html)
