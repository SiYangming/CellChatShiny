library(shinyjs)

function(input, output, session) {

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
