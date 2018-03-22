#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram

shinyUI(fluidPage( 
    titlePanel("Twitter Sentiment Analysis (beta)"), #Title
    h5("Experimental App to make a Sentiment Analysis about twitter's messages in Spanish"),
    h6("Author: franmarq@gmail.com"),
    div(),br(),
    textOutput("currentTime"),   #Here, I show a real time clock,
    br(),
    h4("Tweets:"),   #Sidebar title
    sidebarLayout(
    sidebarPanel(
        textInput("search1",label="Search Term:",value = "<write here>"),
        h6(em("(examples: venezuela, maduro, empresas+polar,...)")),
        submitButton("Submit"),
        br(),
        h4("Instructions:"),
        p("Write the 'search term', push the 'Submit' button and wait a few seconds the 
results from analysis.You will see a frecuency's plot that shows the term's opinions in three categories: 
positive, negative and neutral. A wordcloud's plot is including for each category.This app is designed to 
          show 'the sentiment' from the most popular 100 opinions related with the 'Search Term' in Spanish."),
        br(" "),
        dataTableOutput('tweets_table') #Here I show the users and the sentiment
        ),
      
        mainPanel(
            plotOutput("distPlot"), #Here I will show the bars graph
            sidebarPanel(
                plotOutput("positive_wordcloud") #Cloud for positive words
            ),
            sidebarPanel(
                plotOutput("negative_wordcloud") #Cloud for negative words
            ),
            sidebarPanel(
                plotOutput("neutral_wordcloud") #Cloud for neutral words
            ))
    )))