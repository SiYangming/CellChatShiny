library(shiny)
library(shinyjs)
library(shinycssloaders)
library(shinyWidgets)
library(shinythemes)
library(CellChat)
library(dplyr)
library(ggplot2)
library(ggalluvial)
options(stringsAsFactors = FALSE)

##### read into env #####
cellchatObject <- readRDS(file = "cellchat.rds")
choices = cellchatObject@netP$pathways


selected=sample(choices,1)


ui <- fluidPage(
  
  
  HTML('<meta name="viewport" content="width=1024">'),
  
  
  theme = shinytheme("united"),
  
  fluidRow(style = "padding-top:5px;",
           column(4,
                  style='padding:1x;',
                  offset = 0,
                  align="center",
                  #imageOutput("Logo", height="10vh")
                  tags$a(img(src='http://www.cellchat.org/wound/CellChat_Logo.png', style="height: 80px"), href="http://www.cellchat.org/")    
           ),
           column(4,
                  style='padding:0px;',
                  offset = 0,
                  
                  align="center",
                  
                  wellPanel(align="left",
                            
                            fixedRow(style='padding-left: 5px; padding-right: 5px; padding-top: 0px; padding-bottom: 0px;',
                                     column(10,
                                            style='padding-left: 5px; padding-right: 0px; padding-top: 0px; padding-bottom: 0px;',
                                            offset = 0,
                                            
                                            align="left",
                                            
                                            #          		selectizeInput('pathwayNames', "Select up to 3 genes",
                                            #               			choices=NULL, selected=sample(top100,3), multiple=TRUE, options = list(placeholder ='Start typing gene name', maxItems = 3, plugins=list("remove_button")))
                                            selectizeInput('pathwayNames', "Select pathway to explore its communication network in the dataset",
                                                           choices=NULL, multiple=FALSE, selected=NULL, options = list(maxItems = 1, plugins=list("remove_button")))
                                     ),
                                     column(2,
                                            style='margin-top: 22px; padding-right:5px; padding-left: 0px; padding-top: 0px; padding-bottom: 0px;',
                                            offset = 0,
                                            
                                            align="center",
                                            
                                            actionButton(
                                              inputId = "submit_loc",
                                              label = "Go",
                                              width = "90%"
                                            )
                                     )
                            ),
                            
                            style="padding-left: 2%; padding-right: 2%; padding-top: 0px; padding-bottom: 0px; width: 80%, height: 100%"
                  )
                  
           ),
           column(4,
                  style='padding:0px;',
                  offset = 0,
                  
                  align="center"
           )
  ),
  fluidRow(style='padding:0px;',
           tags$hr(),
           column(7, style='padding:0px;', offset = 0, align="center",
                  tabsetPanel(id = "mainTab",
                              tabPanel("Hierarchy plot", plotOutput('aggregatePlot',height="500px") %>% withSpinner(color="#ff65ab")),
                              tabPanel("Circle plot", plotOutput("circlePlot",height="500px") %>% withSpinner(color="#21b700")),
                              tabPanel("Chord plot", plotOutput("chordPlot",height="500px") %>% withSpinner(color="#21b700"))
                  )
           ),
           column(5,
                  style='padding:0px;',
                  offset = 0,
                  align="center",
                  tabsetPanel(id = "AnalysisTab",
                              tabPanel("Key signaling roles", plotOutput("rolePlot",height = "500px") %>% withSpinner(color="#21b700")),
                              tabPanel("Contribution of each L-R",br(), plotOutput("contributionPlot",height = "400px", width = "80%") %>% withSpinner(color="#cc66cc"))
                  )
           )
  ),
  fluidRow(style='padding:0px',
           tags$hr(),
           column(12,
                  style='padding:0px:',
                  align="center",
                  tabsetPanel(id = "Tab",
                              tabPanel("Signaling patterns in river plot", plotOutput("RiverOut", height = "500px") %>% withSpinner(color="#21b700")),
                              tabPanel("Signaling patterns in dot plot", plotOutput("DotOut", height = "500px") %>% withSpinner(color="red")),
                              tabPanel("Functional classification", plotOutput("EmbedFunctional", height = "500px") %>% withSpinner(color="cyan")),
                              tabPanel("Structural classification", plotOutput("EmbedStructural", height = "500px") %>% withSpinner(color="orange"))
                  )
           )
           
           
           #  ),
           
           
           #fluidRow(
           #   column(1,
           
           #             dropdownButton(
           #    tags$h3("Plot Options"),
           #         wellPanel(
           #           radioButtons(inputId = "pt1Type", label="Reduction for Plot 1", choices = reductionChoices, selected = reductionChoices[[2]]),
           #           radioButtons(inputId = "labelBoolean", label="Display labels?", choices = c("TRUE","FALSE"), selected="FALSE"),
           #           tags$hr(),
           #           sliderInput(inputId = "dotSize", label = "Set point size", value=0.1, min=0.01, max=10),
           #           sliderInput(inputId = "labelSize", label = "Set label size", value=6, min=0.5, max=10)
           #         ),
           #    circle = FALSE, status = "info", icon = icon("gear"), width = "300px",
           #    circle = FALSE, status = "default", icon = NULL, width = "0px",
           #    tooltip = tooltipOptions(title = "Click to see Options!"), inputId = "dropBottom"
           #  )
           
           # )
           ,
           tags$script('
        $(document).on("keydown", function (e) {
        if (e.keyCode == "13") {
  		$("#submit_loc").click();
  	}
        });



  ')
  
  )
)

server <- function(input, output, session) {
  
  output$Draw <- renderPlot({staticImage})
  output$Logo <- renderPlot({logoImage})
  vertex.receiver = seq(1,10)
  groupSize <- as.numeric(table(cellchatObject@idents)) # number of cells in each cell group
  
  updateSelectizeInput(session, 'pathwayNames', choices = sort(choices), server = TRUE)
  
  select_pathway <- reactiveValues(
    path = sample(choices, 1)
  )
  
  observeEvent(input$submit_loc, {
    
    if (is.null(input$pathwayNames)) {
      updateSelectizeInput(session, 'pathwayNames', choices = choices, server = TRUE)
      select_pathway$path <- input$pathwayNames
    }
    select_pathway$path <- input$pathwayNames
    
  })
  
  
  agPlot <- eventReactive(select_pathway$path, {
    pathways.show <- select_pathway$path
    netVisual_aggregate(cellchatObject, signaling = pathways.show,  vertex.receiver = vertex.receiver, vertex.size = groupSize, pt.title = 14, title.space = 4, vertex.label.cex = 0.8)
  })
  
  cPlot <- eventReactive(select_pathway$path, {
    pathways.show <- select_pathway$path
    netVisual_aggregate(cellchatObject, signaling = pathways.show, layout = "circle", vertex.receiver = vertex.receiver, vertex.size = groupSize, pt.title = 14, title.space = 4)
  })
  
  contPlot <- eventReactive(select_pathway$path, {
    pathways.show <- select_pathway$path
    netAnalysis_contribution(cellchatObject, signaling = pathways.show, font.size = 12, font.size.title = 14)
  })
  
  rPlot <- eventReactive(select_pathway$path, {
    pathways.show <- select_pathway$path
    plotWidth = (session$clientData$output_rolePlot_width/1920)*15*3
    netAnalysis_signalingRole_network(cellchatObject, signaling = pathways.show, width = plotWidth, height = 10, font.size=12, font.size.title = 14)
  })
  chPlot <- eventReactive(select_pathway$path, {
    pathways.show <- select_pathway$path
    plotWidth = (session$clientData$output_rolePlot_width/1920)*15*3
    netVisual_chord_cell(cellchatObject, signaling = pathways.show)
  })
  
  
  output$aggregatePlot <- renderPlot(agPlot())
  output$circlePlot <- renderPlot(cPlot())
  output$contributionPlot <- renderPlot(contPlot())
  output$rolePlot <- renderPlot(rPlot())
  output$chordPlot <- renderPlot(chPlot())
  
  output$RiverOut <- renderPlot({
    river1 <- netAnalysis_river(cellchatObject, pattern = "outgoing", font.size = 4, font.size.title = 14)
    river2 <- netAnalysis_river(cellchatObject, pattern = "incoming", font.size = 4, font.size.title = 14)
    cowplot::plot_grid(river1, river2, ncol=2)
  })
  
  output$DotOut <- renderPlot({
    dot1 <- netAnalysis_dot(cellchatObject, pattern = "outgoing", font.size = 12, font.size.title = 14)
    dot2 <- netAnalysis_dot(cellchatObject, pattern = "incoming", font.size = 12, font.size.title = 14)
    cowplot::plot_grid(dot1, dot2, ncol=2)
  })
  
  #  output$EmbedFunctional <- renderPlot({
  #	func1 <- netVisual_embedding(cellchatObject, type = "functional", title = "Functional classification of signaling networks", label.size = 4, pathway.remove.show = F)
  #	func1Zoom <- netVisual_embeddingZoomIn(cellchatObject, type = "functional", label.size = 5, nCol = 2)
  #	cowplot::plot_grid(func1$gg, func1Zoom, ncol=2)
  #  })
  output$EmbedFunctional <- renderPlot({
    func1 <- netVisual_embedding(cellchatObject, type = "functional", label.size = 4, title = "Functiional classification of signaling networks")
    func1Zoom <- netVisual_embeddingZoomIn(cellchatObject, type = "functional", label.size = 5, nCol = 2)
    cowplot::plot_grid(func1$gg, func1Zoom, ncol=2)
  })
  
  output$EmbedStructural <- renderPlot({
    struct1 <- netVisual_embedding(cellchatObject, type = "structural", label.size = 4, title = "Structural classification of signaling networks")
    struct1Zoom <- netVisual_embeddingZoomIn(cellchatObject, type = "structural", label.size = 5, nCol = 2)
    cowplot::plot_grid(struct1$gg, struct1Zoom, ncol=2)
  })
  
  
}

shinyApp(ui, server)