# MAGE
The goal of our work is to “Design an open-source algorithm that calculates MAGE more accurately than existing algorithms and enables easy exploration of the data through a visual display”. This repository holds the intuition, implementation, and code to reproduce graphics and results in the associated paper: [Link to be added].  

More specifically, you can find:

1. 4 CGM data sets:  Hall (2018), Tsalikian (2005), Dubosson (2018), and Broll et al. (2021)

2. 51 manual MAGE calculations (6 were excluded from analyses due to either being too short or having large periods of NA)

3. Functions used to evaluate and analyze the MAGE algorithms: iglu_ma (proposed), [iglu_naive](https://cran.r-project.org/web/packages/iglu/index.html), [cgmquantify v0.5](https://github.com/brinnaebent/cgmquantify), [EasyGV Excel workbook (3/11/2021)](https://www.phc.ox.ac.uk/research/technology-outputs/easygv), and [cgmanalysis v2.7.2](https://cran.r-project.org/web/packages/cgmanalysis/index.html)

4. Functions used to generate the figures

## How to Access CGM Data Sets
We used the data sets Hall (2018), Tsalikian (2005), Dubosson (2018), and JHU originally found on [Awesome-CGM](https://github.com/irinagain/Awesome-CGM). The pre-processed data is included in this repository in the `data/` folder.

By using this data, you consent to the following User Agreements.

> Use of the T1D Exchange publicly-available data requires that you include the following attribution and disclaimer in any publication, presentation or communication resulting from use of these data:
> 
> The source of the data is the T1D Exchange, but the analyses, content and conclusions presented herein are solely the responsibility of the authors and have not been reviewed or approved by the T1D Exchange.
> 
> In addition, the T1D Exchange should be notified via email (publicdatasetuse@t1dexchange.org) when a manuscript (send title) or abstract (send title and name of meeting) reports T1D Exchange data or analyses of the data. Please provide notification at the time of submission and again at time of acceptance.

## Manual MAGE Calculations
We selected 51 days from the above data sets and manually calculated MAGE. We had to exclude 6 samples due to large gaps (5) or insufficient data (1).

The plots representing CGM traces for the 45 manual calculations (and the code to generate them) are in the `plot_scripts` folder.

You can find the calculated MAGE value along with other information about each sample in the `data/manual calculations.xlsx` file. **DO NOT MODIFY** this file since the analysis scripts below require the information to be accurate and in a certain order.

### How to Reproduce Manual Calculations
**General Use:** To reproduce the manual calculations and plots, use the files in the `plot_scripts` folder. There is a pdf of CGM trace plot corresponding to each of the calculations. 

**Specific Instructions:**
First obtain the raw data via [Awesome-CGM](https://github.com/irinagain/Awesome-CGM) as explained within each script. Once the raw data has been properly processed, each `plot_scripts` R script may be sourced to reproduce the plots showing the manual calculations. Within each script, the exact rows of data are subsetted as was done for the manual calculations. The outputs of the scripts may also be found directly under the `plot_scripts/plots` folder. The manual calculation for each dataset is shown in the title of the plot.


## Data Analysis
1. Generating the MAGE calculations for the 5 Algorithms
We compare the proposed algorithm against three other MAGE algorithms: [EasyGV Excel workbook (3/11/2021)](https://www.phc.ox.ac.uk/research/technology-outputs/easygv), [cgmquantify v0.5](https://github.com/brinnaebent/cgmquantify) and [cgmanalysis v2.7.2](https://cran.r-project.org/web/packages/cgmanalysis/index.html). We ran each of these algorithms on the CGM data corresponding to the manual calculations and placed the results in the `/graphics_scripts/external algorithms/` folder.

2. Results

The code to produce the results are in the `graphics_scripts/tests` folder. There are 5 "tests" that are explained below:

- test1.R: In this file, we perform 5-fold cross validation to estimate the accuracy of the proposed algorithm & find the best short & long moving average pair over ALL the data

- test2.R: Same as above but splitting the samples into 2 groups, finding the optimal short/long MA lengths on one data set and then using those parameters to calculate the error on the other data set

- test3.R: These results investigate the effects of NA gaps on the calculation [not reported]

- test4.R: In this file, we compare the difference between MAGE+ and MAGE-. We expect the correlation to be moderate as Baghurst asserts that MAGE+ and MAGE- often do not correlate well

- test5.R: This file calculates the average time of each CGM sample

3. Graphics
The `graphics_scripts/ggplot_graphics.R` has helper functions that will generate the figures. The `graphics_scripts/tests/Figures/figures.R` file will automatically generate and save the figures.



## R Packages Needed
- [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html)
- [iglu](https://cran.r-project.org/web/packages/iglu/index.html)
- [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html)
