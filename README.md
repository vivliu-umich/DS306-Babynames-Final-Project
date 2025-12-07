# DS306-Babynames-Final-Project

# Gender-Neutral Babynames Web Application
This Shiny web app explores the distribution and trends of gender-neutral names over time across the United States. Users can select a state to view trends, top names, and summary statistics of gender neutrality.

## Features
- Trend visualization of the Gender Neutrality Index (GNI) for each US state
- View top names with the highest GNI
- Summary statistics for GNI in the selected state
- Neatly organized and interactive Shiny web application

## How to Run
1. Install and load the required R packages (shiny, dplyr, tidyr, ggplot2, readr)
2. Run `app.R` in RStudio
3. The Shiny app will open in a web browser or RStudio viewer

## Data
The baby name data is sourced from the United States Social Security Administration (SSA) state-level baby names dataset.

The Gender Neutrality Index (GNI) is calculated as:

GNI = 1 - |prop_male - prop_female|

- **GNI = 1:** perfectly gender-neutral  
- **GNI = 0:** fully gender-specific  

## Contributors
Vivian Liu, Claire Damiano


