<!--
*** Thanks for checking out this README Template. If you have a suggestion that would
*** make this better, please fork the repo and create a pull request or simply open
*** an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
-->




<!-- PROJECT LOGO -->
<br />
<p align="center">

  <h3 align="center">Inferring the effects of social distancing across the world during the COVID-19 pandemic</h3>

  <p align="center">
    Supporting code for the paper
  </p>
</p>



<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Code](#about-the-project)
* [Running the code](#running-the-code)
  * [What the code contains](#what-the-code-contains)
  * [Prerequisites](#prerequisites)
  * [Usage](#usage)
  * [Modeling](#modeling)
* [Contact](#contact)



<!-- ABOUT THE PROJECT -->
## About the Code

The code in this repository allows for repeat and independent analysis of the one described in the paper "Inferring the effects of social distancing across the world during the COVID-19 pandemic", by Felix Wong and Meitong Li. The code requires MATLAB 2019b or later to run. 

<!-- GETTING STARTED -->
## Running the code


### What the code contains

To run the data analysis, you will need to load the COVID-19 incidence data and mobility data. These datasets have been preprocessed as MATLAB variables, where each row of the incidence data represents one locale and each column represents one date, from January 22, 2020 to May 14, 2020. In particular, the variables are in the following files:

* countries_cases_0514
<p>
This file loads all timeseries for cases into two variables, dat and dates. dat is a 216x114 matrix where each row is a <b>country</b>, in sequence from Supplementary Dataset 1 of the paper (Afganistan, Albania,..., Zambia). dates is a 216x1 matrix representing the number of days since January 22, 2020 that social distancing policies were implemented. 
</p>

* UScounties_cases_0514
<p>
Same as countries_cases_0514, but for 3195 U.S. counties. 
</p>

* x_deaths_0514
<p>
Same as x_cases_0514, but for death timeseries ('x' can be 'countries' or 'UScounties').
</p>

* x_mobility_0514
<p>
Google mobility data for countries or U.S. counties ('x' can be 'countries' or 'UScounties'). The cell variable this script defines, MO, is indexed from 1,..., 216 in the case of countries and 1,..., 3195 in the case of U.S. counties, corresponding to each row of the relevant timeseries. Each entry is a matrix which represents the change, in percent, of activity with respect to a baseline value earlier in the year. The matrix contains six columns corresponding in order to each mobility category (retail and recreation, grocery and pharmacy, parks, transit stations, workplaces, and residential). Locales with no data are not specified, so that, in these cases, MO{i} is not set, where i is the locale.
</p>

* apple_mobility_0514
<p>
Same as the Google mobility data, but for Apple mobility, and for countries only.
</p>

<p>
<b>Please note:</b> We remind the reader to refer to Supplementary Dataset 1 of the paper for the mapping between locales in the rows and their names. 
</p>

### Prerequisites

* Loading the data container
```sh
countries_cases_0514
countries_mobility_0514
```

or

```sh
countries_deaths_0514
countries_mobility_0514
```

or

```sh
UScounties_cases_0514
UScounties_mobility_0514
```

or

```sh
UScounties_deaths_0514
UScounties_mobility_0514
```



### Usage

To filter out locales with less than a specified number of cases or deaths, adjust line 12 of covid19final.m to
```sh
if (max(this_dat) > 50) && (min(diff(this_dat))>=0)
```
for cases or 
```sh
if (max(this_dat) > 10) && (min(diff(this_dat))>=0)
```
for deaths. Then run
```sh
covid19final
```
All analysis results should appear. 
<p></p>

Note that there are three auxillary scripts related to the analysis. They are described as follows:
<p></p>

* moving_average
<p>
Auxillary script for calculating the moving average of a timeseries. This script is run by covid19final.m.
</p>


* fit_covid_magnitudes
<p>
Auxillary script for calculating the best fit lines (Supplementary Fig. 11) and orthogonal distances (Supplementary Fig. 15) of a dip magnitude-spike magnitude plot. The slope of the best fit line is <i>&lambda;</i>. This script can be run after the analysis by simply executing
</p>

```sh
fit_covid_magnitudes
```

* unnormalized_analysis
<p>
Auxillary script for running an unnormalized analysis based on the incidence per person (IPP), as detailed in the <i>Methods</i> and shown as Supplementary Figs. 16 and 17. The script contains the population of each locale (when available), calculates the IPP, and runs the downsteam analyses. Depending on whether you are working with countries and provinces or U.S. counties, set the <b>is_counties</b> flag to <b>0</b> or <b>1</b>. Then, run the script after the analysis by simply executing
</p>

```sh
unnormalized_analysis
```



### Modeling

We developed a modified SIR/SEIR model for modeling the effects of decreased mobility on the transmission dynamics of COVID-19. The model is simulated by a script, SIR.m. To run it, simply execute
```sh
SIR
```
in MATLAB. You may change the model parameters, including <i>&alpha;</i> and <i>&alpha;</i>\*, directly in the script. To simulate the SEIR model, change the SEIR flag to <b>1</b> before running the script: 
```sh
SEIR = 1
```
As for the SIR model, the SEIR model parameters can be changed directly in the script.

<!-- CONTACT -->
## Contact

For questions or comments about this code, please reach out to felix j wong at gmail (no spaces, add domain name). 



