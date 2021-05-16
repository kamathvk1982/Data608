
#loading CSV from Git for the city

data.nyc.full <- read_csv("./data/DOHMH_New_York_City_Restaurant_Inspection_Results201820192020.csv",  col_names = TRUE , na = c("", "NA"), quoted_na = TRUE)



