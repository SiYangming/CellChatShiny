# CellChatShiny
This is CellChat's Shiny app docker container or standalone shiny app for our [Cell-Cell Communication Atlas Explorer](http://www.cellchat.org), which allows interactive exploration of the cell-cell communication that are analyzed by our [CellChat R-package](https://github.com/sqjin/CellChat).


## Running CellChat Shiny docker container:
Please install [docker](https://www.docker.com/) if not on your system, and save your CellChat object from R/Rstudio as 'cellchat.rds' using `saveRDS()`. Then run the following three commands in the **Terminal**. 

* Download the prebuilt container to your system via 

`docker pull sqjin/cellchatshiny:beta`

* Run the cellchatshiny docker container using the example command below

`docker run --name cellchatshiny -p 3838:3838 -d --restart unless-stopped -v /PATH_to_File/cellchat.rds:/srv/shiny-server/Cellchat/cellchat.rds ucigenomics/cellchatshiny:beta`

**NB**: You MUST specify the absolute path to the cellchat.rds file you saved by modifying the part `/PATH_to_File/cellchat.rds` in the above command.  

* Access the CellChat app by typing the command below in your terminal 

`http://localhost:3838/Cellchat`


## Running CellChat standalone shiny app:
Currently this standalone shiny app can be only used in Linux system. 

* Setup your [shiny server](https://rstudio.com/products/shiny/shiny-server/) and create a Cellchat subdirectory under '.../shiny-server/' and then copy global.R, server.R, and ui.R from this repository to the '.../shiny-server/Cellchat' directory. 
* Generate your Cellchat object from R/Rstudio and save the object as 'cellchat.rds' file and copy this rds file to the same '.../shiny-server/Cellchat' directory
* Run the shiny server and open the Cellchat app from the Cellchat sublocation of the server url. e.g. 'http://localhost:3838/Cellchat'

