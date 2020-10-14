#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

## load in the required libraries 
library(foreign)
library(readr)
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
library(rsconnect)
library(tidyverse)
library(plyr)

## load in data
nhgh = read.dta("nhgh.dta")

## rename categorical variable
### Diabetic condition
nhgh$dx = mapvalues(nhgh$dx, 
                    from = c(0,1), 
                    to = c("no condition", "have condition"))
#### BMI
nhgh$BMI = nhgh$bmi


## Start Server function
shinyServer(function(input, output) {
    ## Plot 1##################################################################
    output$plot1 <- renderPlotly({
      ## Filter dataset
      ds <- nhgh %>%
        filter(BMI >= input$BMIrange[1],    ## Slider lower bound
               BMI <= input$BMIrange[2],    ## Slider upper bound
               dx %in% input$dx)            ## Diabetic condition
      ## Make the plot
      plot1 <- ggplot(data = ds,            
                      aes(x=BMI, 
                          fill=dx)) +
        geom_histogram(alpha = 0.3, 
                       position = "identity") +
        labs(x = "BMI",
             y = "Count",
             title = "Histogram of BMI",
             fill = "Diabetic condition")
      ## ggplotly for hoover
      ggplotly(plot1, 
               tooltip = c("y","x"))
    })
    
    
    ## Plot 2##################################################################
    output$plot2 <- renderPlotly({
      if(is.null(input$select1)){return()}
      race = input$select1
      # process data
      ## Create 'bmicat' to define BMI categories
      nhgh$BMIcategory[nhgh$BMI <= 25] <- "normal"
      nhgh$BMIcategory[nhgh$BMI > 25 & nhgh$BMI <= 30] <- "overweight"
      nhgh$BMIcategory[nhgh$BMI > 30] <- "obese"
      nhgh$BMIcategory <- as.factor(nhgh$BMIcategory)
      ## Filter on selected race group
      nhgh_race <- subset(nhgh, re == race)
      ## Title of the plot
      title2 = paste("Bar-plot of BMI categories by sex for", race)
    
      detach("package:plyr",unload = TRUE)
      ## Filter the dataset
      ds <- nhgh_race %>%
        count(BMIcategory, sex) %>%
        group_by(sex) %>%
        mutate(Proportion = n / sum(n)) %>%    ## Calculate the proportion
        ungroup()
      
      library(dplyr)
      library(plyr)
      ## Make the plot
      plot2 <- ggplot(data = ds,
                      mapping = aes(x=sex,
                                    y=Proportion,
                                    fill = BMIcategory,
                                    ## Hoover text part
                                    text = paste('<br>BMI category:', BMIcategory,
                                                 '<br>Proportion:', round(Proportion,3)))) +
        geom_bar(alpha = 0.5,
                 stat = "identity",
                 position = "dodge") +
        labs(x="Sex",
             y="Proportion",
             fill="BMI category",
             title = title2)
      ## ggplotly for hoover
      ggplotly(plot2,tooltip ="text")
    })
    
    ## Plot 3##################################################################
    output$plot3 <- renderPlotly({
      ## save the new input
      attri = input$select2
      ## rename the variable name
      nhgh$'Weight/kg' = nhgh$wt
      nhgh$'Height/cm' = nhgh$ht
      nhgh$'Arm Circumference/cm' = nhgh$armc
      nhgh$'Waist/cm' = nhgh$waist
      nhgh$para = nhgh[[attri]]
      ## update dataset
      ds <- nhgh 
      ## Title for the plot
      title3 = paste("Scatterplot of BMI vs", attri)
      ## Make the plot
      plot3 <- ggplot(data = ds, aes(x=para, 
                                     y=BMI,
                                     color = sex,
                                     ## Hoover text part
                                     text = paste(attri, para,
                                                  '<br>BMI:', round(BMI,1),
                                                  '<br>sex:', sex)
                                     )
                      ) +
        geom_point() +
        labs(x = toString(input$select2),
             y="BMI", 
             title = title3)
      ## ggplotly for hoover
      ggplotly(plot3,tooltip ="text")
    })
})


