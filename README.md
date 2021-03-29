# MAGE
MAGE method implementation and code to reproduce graphics and results in associated paper: [Link to be added].

## How to Reproduce Graphics & Results
**General Use:** Open the file `/graphics_scripts/graphics.R` in R Studio and run it. All the necessary R files and functions will be sourced automatically, and plots will be generated. To view a specific plot, please source the entire `graphics.R` file first, then run the function to create the desired plot (e.g. `plot_heatmap` or `plot_boxplot`).

Only the data with the final results of the different algorithms is included due to privacy concerns - follow the instructions below to start with the initial data and run every function on your own.

**Specific Instructions**
1. Obtain the following publicly available data sets from [Awesome-CGM](https://github.com/irinagain/Awesome-CGM) and run their respective preprocessor scripts. Put the resulting csv files in the `/graphics_scripts/data/` folder **with the names given below**:
	- Hall (2018) => "Hall2018_processed.csv"
	- Tsalikian (2005) => "Tsalikian2005_processed.csv"
	- Dubosson (2018) => "Dubosson2018_processed.csv"

2. Run the `/graphics_scripts/load_data.R` file to properly extract the needed data.
3. Run the `/graphics_scripts/helpers.R` file which contains the following functions
	- **single_error_iglu**: calculates the error for V1 and V2 of the iglu MAGE algorithm on a given sample compared to the manual calculation
	- **pod_error_iglu**: calculates the error for V1 and V2 of the iglu MAGE algorithm on a given set of samples (indicated by sample indices) compared to manual calculations
	- **mage_error**: calculates the error for an arbitrary algorithm compared to the manual calculations
	- **optimize_ma:** Specifically for the V2 iglu MAGE algorithm. Returns a 38x38 matrix of the mean errors of the algorithm from the manual calculation
4. Run the `/graphics_scripts/ggplot_graphics.R` file which contains the following functions
	- **plot_heatmap**: plots a ggplot heatmap for the 38x38 matrix returned from the `optimize_ma` function
	- **plot_boxplot**: plots a ggplot boxplot given a data frame where each column is a different box (e.g. a use case could be each cell is the error for a specific algorithm on a sample)
	- **algorithm_errors**: constructs a data frame of errors for a given algorithm (?)
5. Run the `/graphics_scripts/external algorithms/save_df_as_csv.R` file. This will automatically save each data frame of cgm data in `cgm_dataset_df` to a separate csv file in the `/graphics_scripts/external algorithms/data/files` folder.
6. Follow these instructions to generate the manual calculations for each of the following algorithms
	- CGMAnalysis: Uncomment line 5 from `/graphics_scripts/external algorithms/cgmanalysis_mage_calc.R` and then run the file. (Note: the `cgmvariables` function sometimes fails with `test40.csv`. Delete the problematic file from the `/graphics_scripts/external algorithms/data` file and rerun.)
	- CGMQuantify: Run the `/graphics_scripts/external algorithms/cgmquantify/mage.py` file and then the `/graphics_scripts/external algorithms/cgmquantify_mage_calc.R` file
	- EasyGV: Place the raw data from each file in `/graphics_scripts/external algorithms/data/files` in the [EasyGV Excel workbook](https://www.phc.ox.ac.uk/research/technology-outputs/easygv) provided in `/graphics_scripts/external algorithms/data`. (Note: by using this workbook you agree to the EasyGV Terms and Conditions [here](https://www.phc.ox.ac.uk/research/technology-outputs/easygv).) Then, run the `/graphics_scripts/external algorithms/easygv_mage_calc.R`.

At this point, it is possible to reproduce any graphic or result in the paper. The code for reproducing the graphics in the paper is given in `/graphics_scripts/graphics.R`.

## How to Reproduce Manual Calculations
**General Use:** To reproduce the manual calculations and plots, use the files in the plot_scripts folder. Each manual calculation dataset has an R script and a corresponding pdf of plots. 

**Specific Instructions**
First obtain the raw data via [Awesome-CGM](https://github.com/irinagain/Awesome-CGM) as explained within each script. Once the raw data has been properly processed, each plot_scripts R script may be sourced to reproduce the plots showing the manual calculations. Within each script, the exact rows of data are subsetted as was done for the manual calculations. The outputs of the scripts may also be found directly under the plot_scripts/plots folder. The manual calculation for each dataset is shown in the title of the plot.

## R Packages Needed
- [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html)
- [iglu](https://cran.r-project.org/web/packages/iglu/index.html)
- [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html)
