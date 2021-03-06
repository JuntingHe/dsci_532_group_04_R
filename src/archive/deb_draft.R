# -*- coding: utf-8 -*-
library(dash)
library(dashHtmlComponents)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(dashCoreComponents)
library(dashBootstrapComponents)
library(plotly)


dataset <- read_csv("data/processed/life_expectancy_data_processed.csv")


app = Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

app$title("Life Expectancy Indicator")

card <- dbcCard(
  children = list(
    dbcCardBody(
      children = list(
        htmlH2("Life", className="display-6"),
        htmlH2("Expectancy", className="display-6"),
        htmlH2("Indicator", className="display-6"),
        htmlHr(),
        htmlBr(),
        dbcLabel("Year Range"),
        dccRangeSlider(
          id = 'widget_g_year',
          min = 2000,
          max = 2015,
          step = 1,
          value = list(2000, 2015),
          marks = setNames(lapply(list(2000, 2003, 2006, 2009, 2012, 2015), 
                                  function(x) paste(x)), 
                           as.character(list(2000, 2003, 2006, 2009, 2012, 2015))),
          tooltip=list('always_visible' = TRUE, 'placement' = 'bottom')
        ) 
      )
    )),style=list("width" = "23rem", 'background-color'='#f8f9fa'))

world_map = dbcCard(
  children = list(
    dbcCardHeader("Life Expectancy Snapshot", className="cursive",style=list('font-weight'='900')),
    dbcCardBody(
      children = list(
        dccGraph(id="map_graph", style=list('border-width'= '0', 'width' = "44.5rem", 'height' = 270))
      )
    )
  ), style = list('margin-left'="1em")
)

widget_style <- list('verticalAlign' = "bottom",'font-weight' = 'bold','font-size' = '12px')

dropdown_style <- list('verticalAlign' = "middle",
                       'shape' = 'circle',
                       'border-radius' = '36px', 
                       'background-color'='#E8E8E8',
                       'display'='inline-block', 
                       'width'="100%",
                       'font-size' = '12px')

continent_widget <- htmlP('Select Continents:', className="card-text", style=widget_style)

continent_dropdown <- dccDropdown(
  id = 'widget_l_continent',
  options = purrr::map(unique(dataset$continent), function(c) list(label = c, value = c)),
  clearable = TRUE,
  searchable = TRUE,
  style = dropdown_style,
  multi = TRUE
)

status_widget <- htmlP('Select Color Axis:', className="card-text", style=widget_style)

status_dropdown <- dccRadioItems(
  id='widget_l_color_axis',
  options = list(list(label = "Continent", value = "continent"),
                 list(label = "Status", value = "status")
  ),
  value = 'continent',
  labelStyle = list('margin-left'="1em", 'font-size' = '12px')
)

trend_card <- dbcCard(
  children = list(
    dbcCardHeader("Year-wise Trend", className="cursive",style=list('font-weight'='900')),
    dbcCardBody(
      children = list(
        dbcRow(children = list(dbcCol(continent_widget), dbcCol(continent_dropdown))),
        htmlBr(),
        dbcRow(children = list(dbcCol(status_widget), dbcCol(status_dropdown))),
        htmlBr(),
        dccGraph(id="widget_o_year_wise_trend", style=list('border-width'= '0', 'width' = '100%', 'height' = '400px'))
      )
    )
  ), style = list("width"="23rem", "height"=640)
)

country_widget <- htmlP('Select a Country:', className="card-text", style=widget_style)

country_dropdown <- dccDropdown(
  id='widget_l_country',
  value='Canada',
  options = purrr::map(unique(dataset$country), function(c) list(label = c, value = c)),
  clearable = FALSE,
  searchable = FALSE,
  style = dropdown_style
)

comparison_card <- dbcCard(
  children = list(
    dbcCardHeader("Country vs Continent vs Worldwide", className="cursive",style=list('font-weight'='900')),
    dbcCardBody(
      children = list(
        dbcRow(list(dbcCol(country_widget), dbcCol(country_dropdown))),
        htmlBr(),
        htmlBr(),
        htmlBr(),
        dccGraph(id="widget_country_comparison", style=list('border-width'= '0', 'width' = '100%', 'height' = '400px'))
      )
    )
  ), style = list("width"="23rem", "height"=640, 'margin-left'="1em")
)

axis_widget <- htmlP('Select X-Axis:', className="card-text", style=widget_style)

axis_dropdown <- dccDropdown(
  id = "widget_l_multi_dim_x_axis",
  options = list(
    list(label = "Adult Mortality", value = "adult_mortality"),
    list(label = "Infant Deaths", value = "infant_deaths"),
    # list(label = "Alcohol Consumption", value = "alcohol"),
    # list(label = "Expenditure (%)", value = "percentage_expenditure"),
    list(label = "Hepatitis B", value = "hepatitis_B"),
    list(label = "Measles", value = "measles"),
    list(label = "BMI", value = "BMI"),
    list(label = "Deaths (below 5 yrs)", value = "under_five_deaths"),
    list(label = "Polio", value = "polio"),
    # list(label = "Total Expenditure", value = "total_expenditure"),
    list(label = "Diphtheria", value = "diphtheria"),
    list(label = "HIV/Aids", value = "hiv_aids"),
    list(label = "GDP", value = "gdp"),
    list(label = "Population", value = "population"),
    list(label = "Schooling", value = "schooling"),
    list(label = "Income Composition", value = "income_composition_of_resources")),
  value = "adult_mortality",
  clearable = FALSE,
  style = dropdown_style
)

color_widget <- htmlP('Select Color Axis:', className="card-text", style=widget_style)

color_dropdown <- dccDropdown(
  id = "widget_l_multi_dim_color_axis",
  options = list(list(label = "Continent", value = "continent"),
                 list(label = "Status", value = "status")),
  value = 'continent',
  clearable = FALSE,
  style = dropdown_style
)

effect_card <- dbcCard(
  children = list(
    dbcCardHeader("Influence of Other Factors", className="cursive",style=list('font-weight'='900')),
    dbcCardBody(
      children = list(
        dbcRow(list(dbcCol(axis_widget), dbcCol(axis_dropdown))),
        htmlBr(),
        dbcRow(list(dbcCol(color_widget), dbcCol(color_dropdown))),
        htmlBr(),
        dccGraph(id="widget_o_multi_dim_analysis", style=list('border-width'= '0', 'width' = '100%', 'height' = '400px')),
        # htmlP(id = "scatter_output", style = list('font-size' = '12px'))
      )
    )
  ), style = list("width"="23rem", "height"=640, 'margin-left'="1em")
)


app$layout(dbcContainer(
  children = list(
    htmlBr(),
    dbcRow(list(card, world_map)),
    htmlBr(),
    dbcRow(list(trend_card, comparison_card, effect_card)),
    htmlBr(),
    htmlHr(),
    dccMarkdown("This app was made by [Debananda Sarkar](https://github.com/debanandasarkar), 
    [Zhanyi Su](https://github.com/YikiSu), 
    [Junting He](https://github.com/JuntingHe), 
    [Joshua Lim](https://github.com/jiajie0225) 
    using [data](https://github.com/UBC-MDS/dsci_532_group_04_R/blob/main/data/processed/life_expectancy_data_processed.csv) 
    compiled from a [Kaggle dataset](https://www.kaggle.com/kumarajarshi/life-expectancy-who).
    The app follows [MIT's license](https://github.com/UBC-MDS/dsci_532_group_04_R/blob/main/LICENSE) and 
    the source code can be found on [GitHub](https://github.com/UBC-MDS/dsci_532_group_04_R)."),
    htmlP(paste0("Data was last updated on ", format(Sys.time(), '%d %B, %Y'), " ."))
  )
))

app$callback(
  output("map_graph","figure"),
  list(input("widget_g_year","value")),
  
  #' Creating Life Expectancy World Map based on the mean of the grouped countries
  #'
  #' @param year_range the selected year range. By default selects year 2000-2015.
  #'
  #' @return a world map displaying the mean of life expectancy for countries within the selected year range
  #'
  #' @examples
  function(year_range){
    
    chosen_starting_year = year_range[1]
    chosen_ending_year = year_range[2]
    
    df <- read.csv('data/raw/2014_world_gdp.csv')
    data<- data.frame(dataset)
    data_mean<- data %>% filter(year>={{chosen_starting_year}}, year<={{chosen_ending_year}}) %>% group_by(country) %>% summarize(avg= mean(life_expectancy,na.rm=TRUE))
    country_tobe_replaced <- c("Bahamas", "Bolivia, Plurinational State of", "Brunei Darussalam", "Congo", "Côte d'Ivoire", "Czechia", "Democratic People's Republic of Korea", 
                               "Democratic Republic of the Congo, Republic of the", "Gambia", "Iran, Islamic Republic of", "Korea, Republic of", "Lao People's Democratic Republic", "Myanmar",
                               "North Macedonia", "Republic of Moldova", "Russian Federation", "Syrian Arab Republic", "United Kingdom of Great Britain and Northern Ireland",
                               "United Republic of Tanzania", "United States of America", "Venezuela, Bolivarian Republic of", "Viet Nam" )
    country_replaced <- c("Bahamas, The", "Bolivia", "Brunei", "Congo, Republic of the", "Cote d'Ivoire", "Czech Republic", "Korea, North", 
                          "Congo, Democratic Republic of the", "Gambia, The", "Iran", "Korea, South", "Laos", "Burma", 
                          "Macedonia", "Moldova", "Russia" , "Syria", "United Kingdom",
                          "Tanzania", "United States", "Venezuela", "Vietnam")
    
    for (i in 1:length(country_tobe_replaced)){
      data_mean$country= gsub(country_tobe_replaced[i], country_replaced[i], data_mean$country)
      data$country= gsub(country_tobe_replaced[i], country_replaced[i], data$country)
    }
    data_mean <- merge(x = data_mean, y = df[,c("COUNTRY","CODE")], by.x = "country", by.y= "COUNTRY" , all.x = TRUE )
    data <- merge(x = data, y = data_mean, by = "country", all.x = TRUE) # Left join country with code
    l <- list(color = toRGB("grey"), width = 0.5)    # light grey boundaries
    g <- list(   # specify map projection/options
      showframe = FALSE,
      showcoastlines = FALSE,
      projection = list(type = 'Mercator')
    )
    fig <- plot_geo(data)
    fig <- fig %>% add_trace(
      z = ~avg, color = ~avg, colors = 'Blues',
      text = ~country, locations = ~CODE, marker = list(line = l)
    )
    m <- list(
      l = 50,
      r = 50,
      b = 0,
      t = 0
    )
    fig <- fig %>% colorbar(title = "")
    fig <- fig %>% layout(
      autosize = F, width = 700, height = 290, margin = m,
      geo = g,
      legend = list(font = list(size = 20)) 
    )
    fig
  }
)


app$callback(
  output("widget_o_year_wise_trend", "figure"),
  list(
    input("widget_g_year", "value"),
    input("widget_l_continent", "value"),
    input("widget_l_color_axis", "value")
  ),
  #' Generates year-wise Average Life Expectancy line plot for selected year range.
  #' The lines are colored by continent or status, based on users' preference
  #' By default, they are colored by continent
  #' The users' can also select specific continents to focus on
  #'
  #' @param year_range the selected year range. By default selects year 2000-2015.
  #' @param in_continent string vector to select one or more continent(s). By default selects all continents.
  #' @param color_axis string to select the color axis. . By default selects continent.
  #'
  #' @return plotly object with year in x-axis, average life expectancy in y-axis and continent or
  #' status in color axis.
  #'
  function(year_range,  in_continent, color_axis) {
    chosen_starting_year = year_range[1]
    chosen_ending_year = year_range[2]
    #color_axis <- enquo(color_axis)
    
    
    if (is_empty(in_continent) || is_null(in_continent[[1]])) {
      in_continent <- unique(dataset$continent)
    }
    
    plot_trend <- dataset %>%
      filter(year>={{chosen_starting_year}}, year<={{chosen_ending_year}}) %>%
      filter(continent %in% in_continent) %>%
      ggplot(aes(x=year, y=life_expectancy, color=!!sym(color_axis))) +
      geom_line(stat = "summary", fun=mean) +
      labs(x="Year", y="Life Expectancy (Mean)", color="") +
      scale_x_continuous(labels = scales::number_format(accuracy = 1)) +
      theme(legend.position="bottom") +
      theme_bw() +
      ggthemes::scale_color_tableau()  
    
    
    ggplotly(plot_trend) %>% 
      layout(autosize = F, width = 320, height = 400,
             legend = list(orientation = "h", x = 0.05, y = -0.2, title = list(font = list(size = 9))),
             xaxis = list(title = list(font = list(size = 12)),
                          tickfont = list(size = 10)),
             yaxis = list(title = list(font = list(size = 12)),
                          tickfont = list(size = 10)))
  }
)

app$callback(
  output("widget_country_comparison", "figure"),
  list(
    input("widget_g_year", "value"),
    input("widget_l_country", "value")
  ),
  #' Generates year-wise Average Life Expectancy line plot for selected year range
  #' of a selected country, it's continent and entire world for comparison
  #'
  #' @param year_range the selected year range. By default selects year 2000-2015.
  #' @param chosen_country string to select a country. Default: Canada
  #'
  #' @return plotly scatterplot object with average life expectancy in y-axis
  #' and selected feature in x-axis
  #'
  function(year_range,  chosen_country) {
    chosen_starting_year = year_range[1]
    chosen_ending_year = year_range[2]
    sel_continent  <- dataset %>%
      filter(country == chosen_country) %>%
      select(continent) %>%
      unique() %>%
      pull()
    
    temp_df <- dataset %>%
      filter(year>={{chosen_starting_year}}, year<={{chosen_ending_year}}) %>%
      filter(country == chosen_country) %>%
      group_by(year) %>%
      summarise(mean_life_exp = mean(life_expectancy)) %>%
      ungroup() %>%
      mutate(label = chosen_country)
    
    temp_df <- dataset %>%
      filter(year>={{chosen_starting_year}}, year<={{chosen_ending_year}}) %>%
      filter(continent == sel_continent) %>%
      group_by(year) %>%
      summarise(mean_life_exp = mean(life_expectancy)) %>%
      ungroup() %>%
      mutate(label = sel_continent) %>%
      bind_rows(temp_df)
    
    temp_df <- dataset %>%
      filter(year>={{chosen_starting_year}}, year<={{chosen_ending_year}}) %>%
      group_by(year) %>%
      summarise(mean_life_exp = mean(life_expectancy)) %>%
      ungroup() %>%
      mutate(label = "Worldwide") %>%
      bind_rows(temp_df)
    
    plot_trend <- temp_df %>%
      ggplot(aes(x=year, y=mean_life_exp, color=label)) +
      geom_line(stat = "summary", fun=mean) +
      labs(x="Year", y="Life Expectancy (Mean)", color="") +
      scale_x_continuous(labels = scales::number_format(accuracy = 1)) +
      theme_bw() +
      ggthemes::scale_color_tableau() +
      theme(legend.position="bottom")
    
    
    ggplotly(plot_trend) %>% 
      layout(autosize = F, width = 330, height = 380,
             legend = list(orientation = "h", x = 0.05, y = -0.2, title = list(font = list(size = 9))),
             xaxis = list(title = list(font = list(size = 12)),
                          tickfont = list(size = 10)),
             yaxis = list(title = list(font = list(size = 12)),
                          tickfont = list(size = 10)))
  }
)

app$callback(
  output("widget_o_multi_dim_analysis", "figure"),
  list(
    input("widget_g_year", "value"),
    input("widget_l_multi_dim_x_axis", "value"),
    input("widget_l_multi_dim_color_axis", "value")
  ),
  #' Generates a scatterplot for any selected feature vs mean life expectancy
  #' The points are colored by continent or status, based on users' preference
  #' By default, they are colored by continent
  #' The users' can multiple features in x-axis
  #'
  #' @param year_range the selected year range. By default selects year 2000-2015.
  #' @param x_axis string vector to select one feature. Default: Adult Mortality.
  #' @param color_axis string to select the color axis. . By default selects continent.
  #'
  #' @return plotly object with year in x-axis, average life expectancy in y-axis and continent or
  #' status in color axis.
  #'
  function(year_range,  x_axis, color_axis) {
    labels = list(
      adult_mortality = "Avg. Adult Mortality (per 1000 population)",
      infant_deaths = "Avg. Infant Deaths (per 1000 population)",
      # alcohol = "Alcohol Consumption (per capita)",
      # percentage_expenditure = "Expenditure (%)",
      hepatitis_B = "Avg. Hepatitis B immunization (%) \n within first year year",
      measles = "Avg. Measles reported (per 1000 population)",
      BMI = "Avg. Body Mass Index",
      under_five_deaths = "Avg. # of Deaths (below 5 yrs)",
      polio = "Avg. % Polio immunization \n within first year year",
      # total_expenditure = "Total Expenditure",
      diphtheria = "Avg. % Diphtheria immunization \n within first year year",
      hiv_aids = "Avg. Deaths per 1000 live births HIV/AIDS \n (0-4 years)",
      gdp = "Avg. GDP per capita (in USD)",
      population = "Avg. Population",
      schooling = "Avg. # of Schooling years",
      income_composition_of_resources = "Avg. Human Development Index (0 to 1)"
    )

    chosen_starting_year = year_range[1]
    chosen_ending_year = year_range[2]
    
    

    
    plot_multi_dim <- dataset %>%
      filter(year >= chosen_starting_year, year <= chosen_ending_year) %>%
      group_by(!!sym(color_axis), country) %>%
      summarise(avg_x_axis = mean(!!sym(x_axis)),
                `Avg. Life Expectancy` = round(mean(life_expectancy), 2)) %>%
      mutate(Country = country) %>%
      ggplot(aes(x=avg_x_axis, y=`Avg. Life Expectancy`, color=!!sym(color_axis), label=Country)) +
      geom_point(size=2) +
      labs(x=labels[[x_axis]], y="Life Expectancy (Mean)", color="") +
      theme_bw() +
      ggthemes::scale_color_tableau() +
      theme(legend.position="bottom")
    
    ggplotly(plot_multi_dim, tooltip=c("label", "y")) %>% 
      layout(autosize = F, width = 330, height = 400,
             legend = list(orientation = "h", x = 0.05, y = -0.4, title = list(font = list(size = 9))),
             xaxis = list(title = list(font = list(size = 12)),
                          tickfont = list(size = 10)),
             yaxis = list(title = list(font = list(size = 12)),
                          tickfont = list(size = 10)),
             title = list(font = list(size = 12)))
  }
  
)

# app$callback(
#   output("scatter_output","children"),
#   list(
#     input("widget_g_year","value"),
#     input("widget_l_multi_dim_x_axis", "value"),
#     input("widget_l_multi_dim_color_axis", "value")
#   ),
#   function(year_range, x_axis, color_axis){
#     chosen_starting_year = year_range[1]
#     chosen_ending_year = year_range[2]
#     return(paste0("* The data shown above is for the year of ", chosen_ending_year, " ."))
#     
#     # na_count <- sum(is.na(dataset %>%
#     #                         filter(year == chosen_ending_year) %>%
#     #                         select(!!sym(x_axis)) %>%
#     #                         pull()))
#     # 
#     # if (na_count >= 1){
#     #   disclaimer1 = paste0("**Data missing for ", na_count," countries")
#     # } else {
#     #   disclaimer1 <- ""
#     # }
#     
#     dataset %>%
#       filter(year >= chosen_starting_year, year <= chosen_ending_year) %>%
#       group_by(!!sym(color_axis), country) %>%
#       summarise(avg_x_axis = mean(!!sym(x_axis)),
#                 `Avg. Life Expectancy` = round(mean(life_expectancy), 2)) %>%
#       select(avg_x_axis) %>%
#       pull()
#     
#   }
# )
# 
app$run_server(host = '0.0.0.0', port = Sys.getenv('PORT', 8050))


