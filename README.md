<!--
*** Thanks for checking out this README Template. If you have a suggestion that would
*** make this better, please fork the repo and create a pull request or simply open
*** an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
-->





<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

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
## About The Project

The code in this repository allows for repeat and independent analysis of the one described in the paper "Inferring the effects of social distancing across the world during the COVID-19 pandemic", by Felix Wong, Meitong Li, and James J. Collins. The code requires MATLAB 2019b or later to run. 

<!-- GETTING STARTED -->
## Running the code


### What the code contains

To run the data analysis, you will need to load the COVID-19 incidence data and mobility data. These datasets have been preprocessed as MATLAB variables, where each row of the incidence data represents one locale and each column represents one date, from January 22, 2020 to May 14, 2020. In particular, the variables are in the following files:

* countries_cases_0514
This file loads all timeseries for cases into two variables, dat and dates. dat is a 216x114 matrix where each row is a <b>country</b>, in sequence from Data S1 of the paper (Afganistan, Albania,..., Zambia). dates is a 216x1 matrix representing the number of days since January 22, 2020 that social distancing policies were implemented. 

* UScounties_cases_0514
Same as countries_cases_0514, but for 3195 U.S. counties. 

* x_deaths_0514
Same as x_cases_0514, but for death timeseries.

* x_mobility_0514
Google mobility data for countries or U.S. counties. The cell variable this script defines, MO, is indexed from 1,..., 216 in the case of countries and 1,..., 3195 in the case of U.S. counties, corresponding to each row of the relevant timeseries. Each entry represents the change, in percent, of activity with respect to a baseline value earlier in the year. Locales with no data are not specified (so that MO{i} is not set, where i is the locale).

* apple_mobility_0514
Same as the Google mobility data, but for Apple mobility, and for countries only.


We remind the reader to refer to Data S1 and S2 of the paper for the mapping between locales in the rows and their names. 
<p>

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

To filter out locales with less than a number of cases or deaths, adjust line 12 of covid19final to
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


### Modeling

The model develops a modified SIR model for modeling the effects of decreased mobility on the transmission dynamics of COVID-19. The model is run by a script, SIR.m. To run it, simply execute
```sh
SIR
```
in MATLAB. You may change the model parameters directly in the script. A modified SEIR model can be built, and has been implemented, with minimal changes to SIR.m.


<!-- CONTACT -->
## Contact

For questions or comments about this code, please reach out to felix j wong at gmail (no spaces, add domain name). 



