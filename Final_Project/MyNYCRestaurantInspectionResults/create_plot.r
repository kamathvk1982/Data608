# Function for barplot
createHistPlot <- function(  boroughInp , cuisineInp){

data.nyc %>%
  filter(BORO == (if(grepl(name.All,boroughInp))  BORO else  boroughInp) & CUISINE_DESCRIPTION == (if(grepl(name.All,cuisineInp)) CUISINE_DESCRIPTION else  cuisineInp)) %>%
  group_by(BORO, CUISINE_DESCRIPTION ) %>%
  summarise(tot = n())  %>%
  ggplot(aes(BORO, tot,  fill = BORO)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~CUISINE_DESCRIPTION, ncol = 3) +
  labs(y = "Contribution to VIOLATIONS",
       x = NULL) +
  coord_flip()

}


# Function for wordcloud
createWordCloud <- function(  boroughInp , cuisineInp){
  data.nyc %>%
    filter(BORO == (if(grepl(name.All,boroughInp))  BORO else  boroughInp) & CUISINE_DESCRIPTION == (if(grepl(name.All,cuisineInp)) CUISINE_DESCRIPTION else  cuisineInp)) %>%
    #inner_join(nrc.sentiments) %>%
    count(VIOLATION_DESCRIPTION) %>%
    with(wordcloud(VIOLATION_DESCRIPTION, n, max.words = 35 , random.order=FALSE , colors=brewer.pal(8, "Dark2")  ))
}

# Function for barplot for 2019 vs 2020
createHistPlotYears <- function(  boroughInp , cuisineInp){
  
data.nyc %>%
    filter(BORO == (if(grepl(name.All,boroughInp))  BORO else  boroughInp) & CUISINE_DESCRIPTION == (if(grepl(name.All,cuisineInp)) CUISINE_DESCRIPTION else  cuisineInp)) %>%
    group_by(CUISINE_DESCRIPTION, INSPECTION_YEAR ) %>%
    summarise(tot = n())  %>%
    ggplot(aes(CUISINE_DESCRIPTION, tot, fill = CUISINE_DESCRIPTION)) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~INSPECTION_YEAR, scales = "free_y") +
    labs(y = paste( "Contribution to VIOLATIONS in 2018 vs 2019 vs 2020 for Borough"  ,boroughInp, sep= " "  ),
         x = NULL) +
    coord_flip()
  
}


# Function for violoation by borough 
createChartBorough <- function( violationInp ){

    data.nyc %>%
    filter(VIOLATION_CODE == (if(grepl(name.All,violationInp))  VIOLATION_CODE else  violationInp) ) %>%
    group_by(BORO ) %>%
    summarise(tot = n())  %>%
    ggplot(aes(BORO, tot, fill = BORO)) +
    geom_col(show.legend = FALSE) +
    labs(y = paste( "Contribution by Borough for Violations"  ,violationInp, sep= " "  ),
         x = NULL) +
    coord_flip()
  
}  


# Function for violoation by Cuisine 
createChartCuisine <- function( violationInp ){
  
  data.nyc %>%
    filter(VIOLATION_CODE == (if(grepl(name.All,violationInp))  VIOLATION_CODE else  violationInp) ) %>%
    group_by(CUISINE_DESCRIPTION ) %>%
    summarise(tot = n())  %>%
    ggplot(aes(CUISINE_DESCRIPTION, tot, fill = CUISINE_DESCRIPTION)) +
    geom_col(show.legend = FALSE) +
    labs(y = paste( "Contribution by Cuisines for Violations"  ,violationInp, sep= " "  ),
         x = NULL) +
    coord_flip()
  
} 

# Function for violoation by Cuisine 
createMap <- function( businessInp ){
  
  mapnyc <-   data.nyc %>%
    filter(CAMIS == (if(grepl(name.All,businessInp))  CAMIS else  businessInp) ) %>%
    select(Latitude, Longitude)

  leaflet() %>%
    addTiles() %>%
    addMarkers(data = mapnyc, popup="Here")
  

} 

# Function for barplot
createGrpHistPlot <- function(  businessInp ){
  
  p <-   data.nyc %>%
    filter(CAMIS == (if(grepl(name.All,businessInp))  CAMIS else  businessInp) ) %>%
    group_by(VIOLATION_CODE, VIOLATION_DESCRIPTION ) %>%
    summarise(tot = n(),  .groups ='keep')  %>%
    ggplot(aes(VIOLATION_CODE, tot,  fill = VIOLATION_CODE, text = paste(VIOLATION_CODE, " : ", VIOLATION_DESCRIPTION))) +
    geom_col(show.legend = FALSE) +
    labs(y = "Contribution to VIOLATIONS",
         x = NULL) +
    coord_flip()
  ggplotly(p, tooltip = "text")
  
}
