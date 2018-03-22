#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tm)
library(wordcloud)
library(twitteR)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    setup_twitter_oauth(consumer_key = "94PqLCmFU8kdgyZBkTRtvOXgv", consumer_secret = "a9fclQgZYMv2jgQl1JSkUW0P3w2Ya1K462CKjqYtT6dvFj9z9y",access_token= "17401995-4ITOMZvM8BcqKGj5tKswiARrjCO0ioe8wYj972IAs",access_secret="O4sJHrKckN5JyW1VrkICMtoLJpHxz1TT7ll6Upk9Xvh6i") 
    output$currentTime <- renderText({invalidateLater(1000, session) #Here I will show the current time
        paste("Current time is: ",Sys.time())})
    observe({
        invalidateLater(60000,session)
        count_positive = 0
        count_negative = 0
        count_neutral = 0
        positive_text <- vector()
        negative_text <- vector()
        neutral_text <- vector()
        vector_users <- vector()
        vector_sentiments <- vector()
        tweets_result = ""
        t1 <- c("bueno", "gracias", "bien","excelente","puntual","honesto","confiable","rapido","seguro","buen servicio","puntualidad",
                "amable","calidad","buena atencion", "disponible", "fiesta","prestame","efectivo","puedes","disfruta")
        t2 <- c("malo", "pesimo", "mal","terrible","inpuntual","deshonesto","terrible","lento","inseguro","largas","colas","corrupto","dictadura",
                "regimen","hambre", "escazes","corrupcion","abuso","presos","protestas","robaron","protestar","justicia",
                "comer basura","renuncia","saqueo","dictador","renuncia","sanciones","tirano","hiperinflacion")
        tweets_result = searchTwitter(input$search1,n=100,resultType="popular",lang = "es")
        for (tweet in tweets_result){
            print(paste(tweet$screenName, ":", tweet$text))
            vector_users <- c(vector_users, as.character(tweet$screenName));
            if (grepl(paste(t1, collapse = "|"), tweet$text, ignore.case = FALSE, perl = TRUE) == TRUE ){
                count_positive = count_positive + 1
                print("positivo")
                vector_sentiments <- c(vector_sentiments, "Positive")
                positive_text <- c(positive_text, as.character(tweet$text))
            } else if (grepl(paste(t2, collapse = "|"), tweet$text, ignore.case = FALSE,perl = TRUE)) { 
                count_negative = count_negative + 1
                print("negativo")
                vector_sentiments <- c(vector_sentiments, "Negative")
                negative_text <- c(negative_text, as.character(tweet$text))
            } else {
                count_neutral = count_neutral + 1
                print("neutral")
                vector_sentiments <- c(vector_sentiments, "Neutral")
                neutral_text <- c(neutral_text, as.character(tweet$text))
            }
        }
        df_users_sentiment <- data.frame(vector_users, vector_sentiments)
        output$tweets_table = renderDataTable({
            df_users_sentiment
        })
        
        output$distPlot <- renderPlot({
            results = data.frame(tweets = c("Positive", "Negative", "Neutral"), numbers = c(count_positive,count_negative,count_neutral))
            barplot(results$numbers, names = results$tweets, xlab = "Sentiment", ylab = "Counts", col = c("Green","Red","Blue"))
            if (length(positive_text) > 0){
                output$positive_wordcloud <- renderPlot({ wordcloud(paste(positive_text, collapse=" "), min.freq = 0, random.color=TRUE, max.words=100 ,colors=brewer.pal(8, "Dark2"),fixed.asp=TRUE)  })
            }
            if (length(negative_text) > 0) {
                output$negative_wordcloud <- renderPlot({ wordcloud(paste(negative_text, collapse=" "), random.color=TRUE,  min.freq = 0, max.words=100 ,colors=brewer.pal(8,"Set3"),fixed.asp=TRUE)  })
            }
            if (length(neutral_text) > 0){
                output$neutral_wordcloud <- renderPlot({ wordcloud(paste(neutral_text, collapse=" "), min.freq = 0, random.color=TRUE , max.words=50 ,colors=brewer.pal(8, "Dark2"),fixed.asp=TRUE)  })
            }
        })
    })
})