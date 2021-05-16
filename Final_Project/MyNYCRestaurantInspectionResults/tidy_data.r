
gc()  # garbage collection

# filtering invalid data with Borough as O
data.nyc <- data.nyc.full %>%
  filter(BORO != '0' )

# Creating a new column as Year of the Inspection for analysis purposes. 
data.nyc <- data.nyc %>%
  mutate(INSPECTION_YEAR = format(as.Date(INSPECTION_DATE,format = "%m/%d/%Y"),"%Y"))


gc() # garbage collection

# function to translate string to have first letter as upper case and rest as lower case.
InitCap=function(x) paste0(toupper(substr(x, 1, 1)), tolower(substring(x, 2)))


# default name handling
name.Manhattan <- 'Manhattan'
name.Brooklyn <- 'Brooklyn'
name.Queens <- 'Queens'
name.Bronx <- 'Bronx'
name.StatenIsland <- 'Staten Island'
name.All <- 'ALL'  


gc() # garbage collection

#getting unique list of cuisines in a new data tibble
list.cuisine <- data.nyc %>%
  select(CUISINE_DESCRIPTION) %>%
  unique() %>%
  arrange(CUISINE_DESCRIPTION)

list.cuisine <- rbind(name.All, list.cuisine)    

gc() # garbage collection

#getting unique list of violations in a new data tibble
list.violation <- data.nyc %>%
  select(VIOLATION_CODE) %>%
  unique() %>%
  arrange(VIOLATION_CODE)

list.violation <- rbind(name.All, list.violation)      


gc() # garbage collection

#getting unique data  of violations , desc and critical flag in a new data tibble
data.violation <- data.nyc %>%
  select(VIOLATION_CODE, VIOLATION_DESCRIPTION, CRITICAL_FLAG) %>%
  unique() %>%
  arrange(VIOLATION_CODE)


gc() # garbage collection

#getting unique list of violations in a new data tibble
list.business <- data.nyc %>%
  select(CAMIS) %>%
  unique() %>%
  arrange(CAMIS)

list.business <- rbind(name.All, list.business)    

gc() # garbage collection

#getting unique business information in a new data tibble
data.business <- data.nyc %>%
  select(CAMIS,DBA,BORO,BUILDING,STREET,ZIPCODE,PHONE,CUISINE_DESCRIPTION,Latitude, Longitude) %>%
  unique() %>%
  arrange(CAMIS)

gc() # garbage collection

#getting business inspection reports in a new data tibble
data.citations <- data.nyc %>%
  select(CAMIS,DBA,BORO,CUISINE_DESCRIPTION,INSPECTION_DATE, ACTION, VIOLATION_CODE, VIOLATION_DESCRIPTION
         , SCORE, GRADE, GRADE_DATE, INSPECTION_TYPE) %>%
  unique() %>%
  arrange(desc(INSPECTION_DATE))

gc() # garbage collection
