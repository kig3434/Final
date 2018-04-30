ui <- fluidPage(
  
  titlePanel("Predicting Iris Species"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("Sepal.Length", label = "Sepal.Length:", value = 5.8, min = 4.3, max = 7.9, step = .1),
      
      sliderInput("Sepal.Width", label = "Sepal.Width:", value = 3.0, min = 2.0, max = 4.4, step = .1),
      
      sliderInput("Petal.Length", label = "Petal.Length:", value = 3.75, min = 1.0, max = 6.9, step = .1),
      
      sliderInput("Petal.Width", label = "Petal.Width:", value = 1.2, min = 0, max = 2.5, step = .1)
      
      
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Data Table", p("See global.R"), DT::dataTableOutput("predtable")),
                  tabPanel("Scatter Plot", plotOutput("splot")),
                  tabPanel("Density Plots", plotOutput("dplot"))
                  )
      
    
    )
  )
)

