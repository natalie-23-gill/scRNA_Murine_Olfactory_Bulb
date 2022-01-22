library(shiny)
library(shinyjs)
library(Seurat)
library(plotly)
library(htmlwidgets)
library(tidyverse)
library(shinycssloaders)
library(shinyBS)

set.seed(123)

ui <- fluidPage(
    useShinyjs(),  # Set up shinyjs
    titlePanel("Interactive 3D UMAP"),
    
    sidebarLayout(
        sidebarPanel(
          tags$div(
            id="file1",
            title="File should include columns: UMAP_1, UMAP_2, UMAP_3, Identity, Gene1, Gene2, etc", 
            fileInput("file", "Upload data (.csv)"),
            bsTooltip(id = "file1", title = "My hover text", placement = "right", trigger = "hover")
          ),
          tags$div(
            id="file2",
            title="File should include columns: Cell_Type, Gene_Name", 
            fileInput("markers", "Upload list of marker genes (.tsv)"),
            bsTooltip(id = "file2", title = "My hover text", placement = "right", trigger = "hover")
          ),
            radioButtons("graphType", "Graph Type",
                         choices = c("Cell Clusters", "Gene Expression")),
              selectInput("gene", "Marker Gene",
                        choices = NULL),
        ),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("Interneurons", plotlyOutput("inter") %>% withSpinner(type = 4, size = 0.5) ),
                      tabPanel("All Cells", plotlyOutput("graph") %>% withSpinner(type = 4, size = 0.5) )
                      
          )
     
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
            d$Identity[which(!is.na(as.numeric(d$Identity)))] = "Unknown"
            d$Identity[which(d$Identity == "Early promodial")] = "Early Primodial"
            d$Identity = factor(d$Identity, levels = c("Interneurons", "Mitral", "Progenitor", "Astrocytes", "Oligodendrocyte", "LP", "Early Primodial", "Unknown"))
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
    
    # read in the umap data 
    data_int <- reactive({
        d = read_csv("plot_data_int.csv")
        d$Identity = factor(d$Identity, levels = c("E14", "E18", "P0", "P3", "P5", "P7", "P10", "P14", "P21", "Adult"))
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
      tryCatch({
        updateSelectInput(session,
                          "gene", 
                          label = "Marker Gene (Feature Plots)",
                          choices = as.list(unstack(rev(markers())))
                          )
      },
      error = function(e) {message('Invalid File', e)
        showModal(modalDialog(div("Please upload a tsv file with the following columns: (1) Cell_Type (2) Gene_Name"), easyClose = TRUE))
        return(NULL)
      })
    })
    
    # get appropriate data depending on type of graph user wants to view (clusters or gene exp plots)
    graphType_all <- reactive({
        if(input$graphType == "Gene Expression") {
            #show("gene")
            return(get(input$gene, data()))
        }
        else {
            #hide("gene")
            return(get("Identity", data()))
        }
    })
    
    graphType_int <- reactive({
      if(input$graphType == "Gene Expression") {
        #show("gene")
        return(get(input$gene, data_int()))
      }
      else {
        #hide("gene")
        return(get("Identity", data_int()))
      }
    })
    
    
    # get graph colors depending on type of graph
    gradColors_all <- reactive({
        if(input$graphType == "Cell Clusters") {
            return(c(sample(RColorBrewer::brewer.pal(n=7,name="Paired")), rep("#f0f0f0", 1)))
        }
        else {
            return(c("#f0f0f0", "red"))
        }
    })
    
    # get graph colors depending on type of graph
    gradColors_int <- reactive({
      if(input$graphType == "Cell Clusters") {
          return(c("#2400FF","#0069FF","#00B9FF","#00F9FF","#00FFA3","#8BFF00","#F8FF00","#FFBD00","#FF8800","#FF0B00"))
      }
      else {
        return(c("#f0f0f0", "red"))
      }
    })
    
    graph_plotly = function(umap_data, graphtype, graphcolors) {
      return(renderPlotly({
        plot_ly(data = umap_data, 
                x = ~UMAP_1, y = ~UMAP_2, z = ~UMAP_3, 
                color = graphtype,
                colors = graphcolors,
                type = "scatter3d", 
                mode = "markers", 
                marker = list(size = 2), 
                text=~Identity,
                hoverinfo="text",
                height = 500)  %>%
          layout(legend = list(bgcolor = 'rgba(0,0,0,0)', itemsizing = 'constant', orientation = 'h'),
                 scene = list(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, title = ''),
                              yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, title = ''),
                              zaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, title = ''),
                              camera = list(eye = list(x = 1, y = 1, z = 0),
                                            center = list(x = 0, y = 0, z = 0))
                 )) %>% hide_colorbar() %>%
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
            rotate('scene', Math.PI / 360);
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
    )}
    
    output$graph <- graph_plotly(data(), graphType_all(), gradColors_all())
    output$inter <- graph_plotly(data_int(), graphType_int(), gradColors_int())
    

}

shinyApp(ui, server)
