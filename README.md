# CellChat Shiny App
This is CellChat's Shiny app docker container or standalone shiny app for our [Cell-Cell Communication Atlas Explorer](http://www.cellchat.org), which allows interactive exploration of the cell-cell communication that are analyzed by our [CellChat R-package](https://github.com/sqjin/CellChat).


## Running CellChat Shiny docker container:
* Step I: Please install [docker](https://www.docker.com/) if not on your system, and save your CellChat object from R/Rstudio as `cellchat.rds` using `saveRDS()`.

* Step II: Download the prebuilt container to your system by running the command below in the terminal
```
docker pull ucigenomics/cellchatshiny:beta
```

* Step III: Run the cellchatshiny docker container by running the example command below in the terminal
```
docker run --name cellchatshiny -p 2020:3838 -d --restart unless-stopped -v /PATH_to_File/cellchat.rds:/srv/shiny-server/Cellchat/cellchat.rds ucigenomics/cellchatshiny:beta
```

* Step IV: Access the CellChat app by simply clicking the url or pasting the url into your browser: http://localhost:2020/Cellchat

**NB**: In Step III, you MUST specify the absolute path to the `cellchat.rds` file you saved by modifying the part `/PATH_to_File/cellchat.rds` in the above command.  

### Running multiple CellChat Shiny apps 
To open two apps for simultaneously exploring cell-cell communication from two datasets, you would need to open a new instance of docker run, and assign a different container name (--name) and also host port (-p XXXX:3838). For example, here we create two apps for two CellChat objects `cellchat_humanSkin_NL.rds` and `cellchat_humanSkin_LS.rds` by running the command below in the terminal

```
docker pull ucigenomics/cellchatshiny:beta

docker run --name cellchatshiny_NL -p 2020:3838 -d --restart unless-stopped -v /Users/suoqinjin/Documents/CellChat/tutorial/cellchat_humanSkin_NL.rds:/srv/shiny-server/Cellchat/cellchat.rds ucigenomics/cellchatshiny:beta

docker run --name cellchatshiny_LS -p 2021:3838 -d --restart unless-stopped -v /Users/suoqinjin/Documents/CellChat/tutorial/cellchat_humanSkin_LS.rds:/srv/shiny-server/Cellchat/cellchat.rds ucigenomics/cellchatshiny:beta
```

We then can access the two CellChat apps using the two urls: http://localhost:2020/Cellchat and http://localhost:2021/Cellchat


## Running CellChat standalone shiny app:
Currently this standalone shiny app can be only used in Linux system. 

* Setup your [shiny server](https://rstudio.com/products/shiny/shiny-server/) and create a Cellchat subdirectory under '.../shiny-server/' and then copy global.R, server.R, and ui.R from this repository to the '.../shiny-server/Cellchat' directory. 
* Generate your Cellchat object from R/Rstudio and save the object as 'cellchat.rds' file and copy this rds file to the same '.../shiny-server/Cellchat' directory
* Run the shiny server and open the Cellchat app from the Cellchat sublocation of the server url. e.g. 'http://localhost:3838/Cellchat'


## Help or Suggestion
If you have any question, comment or suggestion, please post it in the 'Issues' section or contact cellchat.package@gmail.com.


