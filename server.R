server <-function(input, output) {
  

  datasetInput <- reactive({generatepreds(
 Sepal.Length = input$Sepal.Length, 
 Sepal.Width = input$Sepal.Width,
 Petal.Length = input$Petal.Length,
 Petal.Width = input$Petal.Width
 )
    
})

  output$predtable <- DT::renderDataTable((datasetInput())%>%
           datatable() %>%
           formatPercentage(columns = 'preds', digits = 2))
  
##############  

  # yy <- data.frame(generatepreds(
  #   Sepal.Length = input$Sepal.Length,
  #   Sepal.Width = input$Sepal.Width,
  #   Petal.Length = input$Petal.Length,
  #   Petal.Width = input$Petal.Width))
  # 
  # datasetInput1 <- reactive({return(yy
  # )
  # 
  # })
  # 
  # output$predtable1 <- DT::renderDataTable((yy)%>%
  #                     datatable() %>%
  #                      formatPercentage(columns = 'preds', digits = 2))

############

  
##########scatterplot
   plot1 <- ggplot(data=iris, aes(x = Sepal.Length, y = Sepal.Width)) +
     geom_point(aes(color=Species)) +
     xlab("Sepal Length") +  
     ylab("Sepal Width") +
     ggtitle("Sepal Length-Width") + 
     theme_bw() +
     theme_update(plot.title = element_text(hjust = 4)) +
     geom_point(aes(x=input$Sepal.Length, y=input$Sepal.Width), alpha = .01, shape = 21, colour = "red", fill = "white", size = 5, stroke = 2)
   
   output$splot <- renderPlot({plot1
     
   })
   
  
 ###################density plots 
 plot2 <- ggplot(data=iris, aes(x = Petal.Length)) +
   geom_density(aes(fill=Species), alpha = 0.5) +
   xlab("Petal Length") +  
   ggtitle("Petal Length")

  plot3 <- ggplot(data=iris, aes(x = Petal.Width)) +
    geom_density(aes(fill=Species), alpha = 0.5) +
    xlab("Petal Width") +  
    ggtitle("Petal Width")
  
  plot4 <- ggplot(data=iris, aes(x = Sepal.Width)) +
    geom_density(aes(fill=Species), alpha = 0.5) +
    xlab("Sepal Width") +  
    ggtitle("Sepal Width")
  
  plot5 <- ggplot(data=iris, aes(x = Sepal.Length)) +
    geom_density(aes(fill=Species), alpha = 0.5) +
    xlab("Sepal Length") +  
    ggtitle("Sepal Length")
  
  output$dplot <- renderPlot({
    ggarrange(plot5 +  geom_vline(xintercept =  input$Sepal.Length), plot4 + geom_vline(xintercept =  input$Sepal.Width),plot2 +  geom_vline(xintercept =  input$Petal.Length), plot3 +geom_vline(xintercept =  input$Petal.Width), ncol=2, nrow=2, common.legend = TRUE, legend="bottom")
                      
  })
  }

######

#  datasetInput <- reactive({wine %>% filter(variety %in% input$type) %>% #filter(country == input$word) %>% select (-description)
#  })
#  


#output$predtable <- renderTable({head(datasetInput())})