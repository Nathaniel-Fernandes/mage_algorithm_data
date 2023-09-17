# MAGE
The goal of our work is to design an open-source algorithm that calculates MAGE more accurately than existing algorithms and enables easy exploration of the data through a visual display. This repository holds the intuition, implementation, and code to reproduce graphics and results in the associated paper: [Mean Amplitude of Glycemic Excursions, a Measure of Diabetic Instability](https://diabetesjournals.org/diabetes/article/19/9/644/3599/Mean-Amplitude-of-Glycemic-Excursions-a-Measure-of).  

More specifically, you can find:

1. 4 CGM data sets:  Hall (2018), Tsalikian (2005), Dubosson (2018), and Broll et al. (2021)

2. 51 manual MAGE calculations. We only used 45 manual calculations for final accuracy evaluations since 6 were excluded due to either being too short or having large periods of NA.

3. Functions used to evaluate and analyze the MAGE algorithms: iglu_ma (proposed), [iglu_naive](https://cran.r-project.org/web/packages/iglu/index.html), [cgmquantify v0.5](https://github.com/brinnaebent/cgmquantify), [EasyGV Excel workbook (3/11/2021)](https://www.phc.ox.ac.uk/research/technology-outputs/easygv), and [cgmanalysis v2.7.2](https://cran.r-project.org/web/packages/cgmanalysis/index.html)

4. Functions used to generate the figures

## 1. How to Access CGM Data Sets
We used the data sets Hall (2018), Tsalikian (2005), Dubosson (2018) originally found on [Awesome-CGM](https://github.com/irinagain/Awesome-CGM). Additional, we used the example dataset available within R package iglu by Broll et al. (2021).

| Dataset      | Diabetes Type | Age group | Subject ID | Number of days used (CGM traces)
| ----------- | ----------- | ----------- | ----------- | ----------- |
| [Hall et al. (2018)](https://doi.org/10.1371/journal.pbio.2005143)    | None       | Adults (> 18) | 1636-69-001 | 5|
|    |      |  | 1636-69-026 | 6|
| [Tsalikian et al. (2005)](https://doi.org/10.1016/j.jpeds.2005.04.065)   | Type 1       | Children (10 - 18) | 2 | 1|
|    |      |  | 7| 2|
|    |      |  | 8| 1|
|    |      |  | 11| 2|
|    |      |  | 15| 1|
|    |      |  | 43| 1|
|    |      |  | 44| 1|
| [Dubosson et al. (2005)](https://doi.org/10.1016/j.imu.2018.09.003)   | Type 1       | Adults (> 18)  | 1 | 5|
|    |      |  | 2| 2|
| [Broll et al. (2021)](https://doi.org/10.1371/journal.pone.0248560)   | Type 2       | Adults (> 18)  | Subject 1 | 1|
|    |      |  | Subject 2| 5|
|    |      |  | Subject 3| 1|
|    |      |  | Subject 4| 5|
|    |      |  | Subject 5| 6|

The pre-processed data is included in this repository in the `data/` folder.

By using this data, you consent to the following User Agreements.

> Use of the T1D Exchange publicly-available data requires that you include the following attribution and disclaimer in any publication, presentation or communication resulting from use of these data:
> 
> The source of the data is the T1D Exchange, but the analyses, content and conclusions presented herein are solely the responsibility of the authors and have not been reviewed or approved by the T1D Exchange.
> 
> In addition, the T1D Exchange should be notified via email (publicdatasetuse@t1dexchange.org) when a manuscript (send title) or abstract (send title and name of meeting) reports T1D Exchange data or analyses of the data. Please provide notification at the time of submission and again at time of acceptance.

## 2. Manual MAGE Calculations
We selected 51 days from the above data sets and manually calculated MAGE. We had to exclude 6 samples due to large gaps (5) or insufficient data (1).

The plots representing CGM traces for the 45 manual calculations (and the code to generate them) are in the `plot_scripts` folder.

You can find the calculated manual MAGE value along with other information about each sample in the `data/manual calculations.xlsx` file. **DO NOT MODIFY** this file since the analysis scripts below require the information to be accurate and in a certain order.

## 3. Data Analysis # TODO:
All of the analyses done can be found in the `graphics_scripts/tests` folder.

- test1.R: In this file, we perform 5-fold cross validation to estimate the accuracy of the proposed algorithm & find the best short & long moving average pair over ALL the data

- test2.R: Same as above but splitting the samples into 2 groups, finding the optimal short/long MA lengths on one data set and then using those parameters to calculate the error on the other data set

- test3.R: These results investigate the effects of NA gaps on the calculation [not reported]

- test4.R: In this file, we compare the difference between MAGE+ and MAGE-. We expect the correlation to be moderate as Baghurst asserts that MAGE+ and MAGE- often do not correlate well

- test5.R: This file calculates the average time of each CGM sample

## 4. Functions used to create the plots # TODO:
The functions used to create the plots can be found in the `graphics_scripts/tests/figures.R` file. The plots include a  
  a) CGM trace with moving averages displayed, 
  b) CGM trace with gaps highlighted, 
  c) heatmap with the % error of the proposed algorithm based on different combos of short/long MAs, 
  d) boxplot comparing the % errors of the different algorithmse
  e) scatter plot comparing MAGE+ with MAGE-
  
For a) and b), the proposed function `iglu::mage()` can return a ggplot with the cgm trace with short/long MAs displayed and gaps highlighted. See the [iglu documentation](https://github.com/irinagain/iglu/blob/master/man/mage_ma_single.Rd) for more info.

Part c) uses the `plot_heatmap()` function found in `graphics_scripts/ggplot_graphics.R` file. This function takes in a matrix where each element is a number, representing the % error. Optionally, the color scale can be adjusted with the `low` and `high` parameters.

Part d) uses `plot_boxplot()` and `make_boxplot_df()` found in `graphics_scripts/ggplot_graphics.R` and the `errors_df` found in `graphics_scripts/tests/test1.R`. The `make_boxplot_df()` function returns a data frame where each column is the % error of a different algorithm on the manual calculation cgm traces.

e) This isn't included in the paper, but supports the hypothesis that MAGE+ and MAGE- are moderately correlated.

## R Packages Needed
- [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html)
- [iglu](https://cran.r-project.org/web/packages/iglu/index.html)
- [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html)
