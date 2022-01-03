library(shiny)
library(shinyjs)
library(Seurat)
library(plotly)
library(htmlwidgets)
library(tidyverse)
library(shinycssloaders)

ui <- fluidPage(
    useShinyjs(),  # Set up shinyjs
    titlePanel("Interactive 3D UMAP"),
    sidebarLayout(
        sidebarPanel(
            fileInput("file", "Upload data (.csv)"),
            fileInput("markers", "Upload list of marker genes (.tsv)"),
            radioButtons("graphType", "Graph Type",
                         choices = c("Cell Clusters", "Gene Expression")),
              selectInput("gene", "Marker Gene",
                        choices = NULL),
        ),
        mainPanel(
            plotlyOutput("graph") %>% withSpinner(type = 4, size = 0.5)      
            )
    )
)

server <- function(input, output, session) {
    # set max file upload size to 30 Mb (default is 5 Mb)
    options(shiny.maxRequestSize=10000*1024^2) 
    
    # read in the umap data 
    data <- reactive({
        if (is.null(input$file)) {
            d = read_csv("plot_data.csv")
        }
        else {
            if(input$file$type %in% c('text/csv','text/comma-separated-values', '.csv')) {
                d = read_csv(input$file$datapath)
            }
            else {
                stop("Please upload a .csv file")
            }
        }
        return(d)
    })
    
    # read in marker genes
    markers = reactive({
        if (is.null(input$markers)) {
            d <- read_tsv("filt_ob_markergenes.tsv", col_names = F)
        } else {
            d <- read_tsv(input$markers$datapath, col_names = F)
        }
        return(d)
    })
    
    # update marker gene dropdown when user uploads a tsv file
    observe({
        updateSelectInput(session,
                          "gene", 
                          label = "Marker Gene (Feature Plots)",
                          choices = as.list(unstack(rev(markers())))
                          )
    })
    
    # get appropriate data depending on type of graph user wants to view (clusters or gene exp plots)
    graphType <- reactive({
        if(input$graphType == "Gene Expression") {
            #show("gene")
            return(get(input$gene, data()))
        }
        else {
            #hide("gene")
            return(get("Identity", data()))
        }
    })
    
    # get graph colors depending on type of graph
    gradColors <- reactive({
        if(input$graphType == "Cell Clusters") {
            return(RColorBrewer::brewer.pal(n=12,name="Set3"))
        }
        else {
            return(c("white", "blue"))
        }
    })
    
    # update the plotly graph
    output$graph <- renderPlotly({
        plot_ly(data = data(), 
                x = ~UMAP_1, y = ~UMAP_2, z = ~UMAP_3, 
                color = graphType(),
                colors = gradColors(),
                type = "scatter3d", 
                mode = "markers", 
                marker = list(size = 2), 
                text=~Identity,
                hoverinfo="text",
                height = 500)  %>%
            layout(legend = list(itemsizing = 'constant'),
                   scene = list(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, title = ''),
                                yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, title = ''),
                                zaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, title = ''),
                                camera = list(eye = list(x = 1.2, y = 1.2, z = 0),
                                              center = list(x = 0, y = 0, z = 0)),
                                annotations = list()
                   )) %>% 
            onRender("
      function(el, x)
      {
        var id = el.getAttribute('id');
        var gd = document.getElementById(id);
        Plotly.update(id).then(attach);
        
        function attach() 
        {
  
          function run() 
          {
            rotate('scene', Math.PI / 180);
            requestAnimationFrame(run);
          }
          
          run();
    
          function rotate(id, angle) 
          {
            var eye0 = gd.layout[id].camera.eye;
            var rtz = xyz2rtz(eye0);
            rtz.t += angle;
            var eye1 = rtz2xyz(rtz);
            Plotly.relayout(gd, id + '.camera.eye', eye1)
          }
          
          function xyz2rtz(xyz) 
          {
            return {
              r: Math.sqrt(xyz.x * xyz.x + xyz.y * xyz.y),
              t: Math.atan2(xyz.y, xyz.x),
              z: xyz.z
            };
          }
          
          function rtz2xyz(rtz) 
          {
            return {
              x: rtz.r * Math.cos(rtz.t),
              y: rtz.r * Math.sin(rtz.t),
              z: rtz.z
            };
          }
        };
      }
    ")
    })
}

shinyApp(ui, server)
