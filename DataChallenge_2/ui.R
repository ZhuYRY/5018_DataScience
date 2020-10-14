#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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


## Rename categorical name for UI design
dx_name = c("no condition", "have condition")
sex_name = c("male","female")

## Start UI function
shinyUI(fluidPage(
  ## Main title
  titlePanel("Data Challenge 2_Yanruyu Zhu"),
  ## Left Sidebar 
  sidebarLayout(
      sidebarPanel(
        ## Plot 1##################################################################
        ## Note text for Plot 1
        helpText("Histogram"),
        ## Slider for BMI range
        sliderInput(inputId = "BMIrange", 
                    label = "BMI range", 
                    min = 0, 
                    max = 100, 
                    value = c(20, 50)),
        ## Check box for Diabetic condition
        checkboxGroupInput(inputId = "dx", 
                           label = "Diabetic Condition",
                           sort(unique(dx_name)),
                           selected = c("no condition", "have condition")),
            
        ## Plot 2##################################################################
        ## Note text for Plot2
        helpText("Bar plot"),  
        ## Select box for Race/Ethnicity
        selectInput(inputId = "select1",
                    label = "Choose a Race/Ethnicity group to display",
                    choices = c("Mexican American","Non-Hispanic Black",
                                "Non-Hispanic White","Other Hispanic",
                                "Other Race Including Multi-Racial"),
                    selected = "Mexican American",
                    multiple = FALSE),
                        
        ## Plot 3##################################################################
        ## Note text for plpt 3
        helpText("Scatter plot"), 
        ## Select box for Physical Measurements
        selectInput(inputId = "select2", 
                    label = "Choose a Physical Measurement to display",
                    choices = c("Weight/kg", 
                                "Height/cm",
                                "Arm Circumference/cm", 
                                "Waist/cm"),
                    selected = "Weight/kg",
                    multiple = FALSE)
        ),
      ## Right Main design
      mainPanel(
        tabsetPanel(
          ## 1. Description
          ####  title
          tabPanel(title = "Description", 
          ####  text
          h4("NHGH is a dataset coming from National Health and Nutrition Examination Survey in the year of 2019. It includes body size, BMI, and demographics of 6795 observations. 
              We will use a histogram, a bar plot, and a scatterplot to explore the relationship between Body Mass Index (BMI) and other factors."),
          h4("First we will use a histogram to show the general distribution of BMI for individuals with diabetic condition and no diabetic condition.  you can use the slider to choose the range of BMI to display."),
          h4("The second graph is a barplot which shows the BMI categories distribution in different sex. You can choose specific race/ethnicity group."),
          h4("The third visualization is a scatterplot which shows the relationship between BMI and different physical measurements. We might not infer direct causal relationship, but the pattern can be interesting.")),
          ## 2. Histogram
          ####  title
          tabPanel(title = "Histogram", 
          ####  make the plot
                   plotlyOutput("plot1"),
          ####  figure description
                   h5("This histogram shows the selected BMI range for individuals with different diabetic condition. It is obvious that the the diabetic individuals' BMI graph is relatively more spread out and diabetic individuals tend to have slightly higher BMI.")),
          ## 3. Barplot
          ####  title
          tabPanel(title = "Bar plot", 
          ####  make the plot
                   plotlyOutput("plot2"),
          ####  figure description
                   h5("Note: we classify BMI <= 25 as normall, 25 < BMI <= 30 as overweight, BMI > 30 as obese.")),
          ## 4. Scatterplot
          ####  title
          tabPanel(title = "Scatter plot", 
          ####  make the plot
                   plotlyOutput("plot3"),
          ####  figure description
                   h5("It seems that for body measurements of weight, waist, and arm circumference, there exist a positive relationship with BMI, but not for height. This does not mean any causal relationship, but the reason behind such pattern can be worth studying. "))
          )
        )
      )
  ))



