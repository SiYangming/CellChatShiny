library(shiny)
library(shinyWidgets)
library(shinythemes)
library(CellChat)
library(ggplot2)
library(ggalluvial)
options(stringsAsFactors = FALSE)


cellchatObject <- readRDS(file="cellchat.rds")
choices = cellchatObject@netP$pathways
