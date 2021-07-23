# MAGE
The goal of our work is to “Design an open-source algorithm that calculates MAGE more accurately than existing algorithms and enables easy exploration of the data through a visual display”. This repository holds the intuition, implementation, and code to reproduce graphics and results in the associated paper: [Link to be added].  

More specifically, you can find:
1. 4 CGM data sets from the T1D Exchange
2. 51 manual MAGE calculations (6 were excluded from analyses)
3. Functions used to evaluate and analyze the MAGE algorithms: iglu_ma (proposed), [iglu_naive](https://cran.r-project.org/web/packages/iglu/index.html), [cgmquantify v0.5](https://github.com/brinnaebent/cgmquantify), [EasyGV Excel workbook (3/11/2021)](https://www.phc.ox.ac.uk/research/technology-outputs/easygv), and [cgmanalysis v2.7.2](https://cran.r-project.org/web/packages/cgmanalysis/index.html)
4. Functions used to generate the publication-quality graphics

## How to Access CGM Data Sets
We used the data sets Hall (2018), Tsalikian (2005), Dubosson (2018), and JHU originally found on [Awesome-CGM](https://github.com/irinagain/Awesome-CGM). The pre-processed data is included in this repository in the `graphics_scripts/data/` folder.

By using this data, you consent to the following User Agreements.
> Use of the T1D Exchange publicly-available data requires that you include the following attribution and disclaimer in any publication, presentation or communication resulting from use of these data:
> 
> The source of the data is the T1D Exchange, but the analyses, content and conclusions presented herein are solely the responsibility of the authors and have not been reviewed or approved by the T1D Exchange.
> 
> In addition, the T1D Exchange should be notified via email (publicdatasetuse@t1dexchange.org) when a manuscript (send title) or abstract (send title and name of meeting) reports T1D Exchange data or analyses of the data. Please provide notification at the time of submission and again at time of acceptance.

## Access 

## How to Reproduce Results & Graphics
1. 
**General Use:** Open the file `/graphics_scripts/graphics.R` in R Studio and run it. All the necessary R files and functions will be sourced automatically, and plots will be generated. To view a specific plot, please source the entire `graphics.R` file first, then run the function to create the desired plot (e.g. `plot_heatmap` or `plot_boxplot`).

Only the data with the final results of the different algorithms is included due to privacy concerns - follow the instructions below to start with the initial data and run every function on your own.

**Specific Instructions**
1. Obtain the following publicly available data sets from [Awesome-CGM](https://github.com/irinagain/Awesome-CGM) and run their respective preprocessor scripts (which can be found with the data sets). Put the resulting csv files in the `/graphics_scripts/data/` folder **with the names given below**:
	

2. Run the `/graphics_scripts/load_data.R` file to properly extract the needed data.

3. Run the `/graphics_scripts/helpers.R` file which contains the following functions
	- **single_error_iglu**: calculates the error for V1 and V2 of the iglu MAGE algorithm on a given sample compared to the manual calculation
	- **pod_error_iglu**: calculates the error for V1 and V2 of the iglu MAGE algorithm on a given set of samples (indicated by sample indices) compared to manual calculations
	- **mage_error**: calculates the error for an arbitrary algorithm compared to the manual calculations
	- **create_pem/create_pem2**: Specifically for the V2 iglu MAGE algorithm. Returns a 38x38 matrix of the mean errors of the algorithm from the manual calculations. (PEM = Percent Error Matrix) (Note: this function is very computationally intensive as the iglu V2 MAGE function is run approximately `38*38*46*0.5 = 33212` times.)
5. Run the `/graphics_scripts/ggplot_graphics.R` file which contains the following functions.
	- **plot_heatmap**: plots a ggplot heatmap for the 38x38 matrix returned from the `create_pem` function
	- **plot_boxplot**: plots a ggplot boxplot given a data frame where each column is a different box (e.g. a use case could be each cell is the error for a specific algorithm on a sample)
	- **algorithm_errors**: constructs a data frame of errors for a given algorithm (?)
6. Run the `/graphics_scripts/external algorithms/save_df_as_csv.R` file. This will automatically save each data frame of cgm data in `cgm_dataset_df` to a separate csv file in the `/graphics_scripts/external algorithms/data/files` folder.
7. Follow these instructions to generate the manual calculations for each of the following algorithms
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
