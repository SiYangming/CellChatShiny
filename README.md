# CellChatShiny
Standalone shiny app or shiny app container for viewing [CellChat](https://github.com/sqjin/CellChat) objects

## Running CellChat Shiny app:

* Setup your [shiny server](https://rstudio.com/products/shiny/shiny-server/) and create a Cellchat subdirectory under '.../shiny-server/' and then copy global.R, server.R, and ui.R from this repository to the '.../shiny-server/Cellchat' directory. 
* Generate your Cellchat object from R/Rstudio and save the object as 'cellchat.rds' file and copy this rds file to the same '.../shiny-server/Cellchat' directory
* Run the shiny server and open the Cellchat app from the Cellchat sublocation of the server url. e.g. 'http://localhost:3838/Cellchat'

## Running CellChat Shiny docker container:

* Install [docker](https://www.docker.com/) if not on your system
* Use 'docker pull ucigenomics/cellchatshiny:beta' to download the prebuilt container to your system
* Prepare your Cellchat object from R/Rstudio and save the object as 'cellchat.rds' file
* Run the cellchatshiny docker container with the binding to the cellchat.rds file using the example command:
  'docker run --name cellchatshiny -p 3838:3838 -d --restart unless-stopped -v /{absolute_path}/cellchat.rds:/srv/shiny-server/Cellchat/cellchat.rds ucigenomics/cellchatshiny:beta' where 'absolute_path' you must specify the absolute path to the cellchat.rds file on your system
* Access the Cellchat app from the url 'http://localhost:3838/Cellchat'
