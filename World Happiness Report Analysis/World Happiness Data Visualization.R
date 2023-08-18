#Install necessary packages
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("maps")

#Load packages
library("tidyverse")
library("ggplot2")
library("maps")

#Import data
world_happiness_data = read.csv("C:\\Users\\elang\\OneDrive\\Desktop\\R projects\\2017.csv")

#Filter data with only required data
filtered_data = world_happiness_data %>%
                    select(Country, Happiness.Rank, Happiness.Score, Economy..GDP.per.Capita., Health..Life.Expectancy.)

#View first few lines of the data 
#head(filtered_data)

#Pull default map data from package and rename column to match filtered data 
mapdata <- map_data("world") %>% 
      rename("Country" = "region") 

#Join data sets based on the country column
mapdata <- left_join(mapdata, filtered_data, by="Country")


#Filter out NA values in the data set
mapdata <- mapdata %>% 
  filter(!is.na(mapdata$Happiness.Rank))

#Plot the map with the appropriate gradient colors, legend, title and labels
map <- ggplot(mapdata, aes(x = long, y = lat, group=group)) + geom_polygon(aes(fill = Happiness.Score), color = "black") + 
  scale_fill_gradient(name = "Happiness score", low = "dodgerblue4", high = "lightblue1") + ggtitle("Happiness Scores by Regions") +
  xlab("Longtitude") + ylab("Latitude")
map

#Make rows unique
no_dupe_data <- mapdata[!duplicated(mapdata$Country),]

#Draw the scatter plot with proper labels, title and colors
no_dupe_data %>% ggplot(aes(x=Health..Life.Expectancy.,y=Happiness.Score)) + geom_point(aes(color="red")) + ggtitle("Happiness Scores vs. Health") +
  xlab("Health") + ylab("Happiness Score")

#Draw the line graph with proper labels, title and colors
no_dupe_data %>% ggplot(aes(x=Economy..GDP.per.Capita.,y=Happiness.Score)) + geom_point() + geom_line(color="red") + geom_smooth(color="blue") +ggtitle("Happiness Scores vs. Economic Wealth") +
  xlab("GDP") + ylab("Happiness Score") 
