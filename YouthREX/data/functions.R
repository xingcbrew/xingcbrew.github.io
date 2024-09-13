# Function to create scatter plot
scatter <- function(data, custom_colors, yaxis, text_content = NULL, showlegend = TRUE) {
  # Precompute the border colors based on categories
  data$bordercolor <- custom_colors[data$category]

  text_to_use <- if (is.null(text_content)) {
    ~paste(format(Value, big.mark = ",", scientific = FALSE), '(', Percentage, '%)')
  } else {
    text_content
  }

  plot_ly(
    data = data, 
    x = ~Year, 
    y = ~Value, 
    color = ~category, 
    colors = custom_colors,
    type = 'scatter', 
    mode = 'lines+markers',
    marker = list(size = 8, line = list(width = 4)),
    showlegend = showlegend,
    hoverinfo = 'text',
    text = text_to_use,  
    hoverlabel = list(
      font = list(family = "HvDTrial Brandon Grotesque Reg", color = "black", size = 15),
      bgcolor = "white",
      bordercolor = ~bordercolor  # Use the precomputed bordercolor column
    )
  ) %>%
    layout(
      xaxis = list(title = ''),
      yaxis = list(title = yaxis),
      legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1)
    )
}



per_label <- ~paste(Value,"%")

## Function to create bar plots
create_bar_plot <- function(data, custom_colors, yaxis_title, showlegend = TRUE, text_content = NULL, orientation = 'v') {
  # Precompute the border colors based on categories
  data$bordercolor <- custom_colors[data$category]
  
  text_to_use <- if (is.null(text_content)) {
    ~paste(format(Value, big.mark = ",", scientific = FALSE), '(', Percentage, '%)')
  } else {
    text_content
  }

  plot_ly(
    data = data, 
    x = ~Year, 
    y = ~Value, 
    type = 'bar', 
    name = ~category,
    color = ~category, 
    colors = custom_colors,
    showlegend = showlegend,
    orientation = orientation,
    hoverinfo = 'text',
    text = text_to_use,
    textposition = 'none',
    marker = list(line = list(color = 'rgba(255,255,255,0)', width = 0.7)),
    hoverlabel = list(
      font = list(family = "HvDTrial Brandon Grotesque Reg", color = "black", size = 15),
      bgcolor = "white",
      bordercolor = ~bordercolor  # Use the precomputed bordercolor column
    )
  ) %>%
    layout(
      paper_bgcolor = '#FFF',
      plot_bgcolor = '#FFF',
      yaxis = list(title = yaxis_title), 
      barmode = 'stack',
      margin = list(t = 30),
      legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1, font = list(size = 15))
    )
}


## Function to prep data by Year
prepare_plot_data <- function(data, categories, year_cols) {
  
  data %>%
    filter(category %in% categories) %>%
    pivot_longer(cols = all_of(year_cols), 
                 names_to = "Year", 
                 values_to = "Value") %>%
    group_by(Year) %>%
    mutate(Total = sum(Value),
           Percentage = round((Value / Total * 100), 1)) %>%
    ungroup()
}

## Function to prep data by Age
prepare_plot_data_age <- function(data, categories, age_cols) {
  
  data %>%
    filter(category %in% categories) %>%
    pivot_longer(cols = all_of(age_categories), 
                 names_to = "AgeGroup", 
                 values_to = "Value") %>%
    group_by(AgeGroup) %>%
    mutate(Total = sum(Value),
           Percentage = round((Value / Total * 100), 1)) %>%
    ungroup()
}

## Function to prep data by Age & Category
prepare_plot_data_age_year <- function(data, categories, age_cols) {
  
  data %>%
    filter(category %in% categories) %>%
    pivot_longer(cols = all_of(age_categories), 
                 names_to = "AgeGroup", 
                 values_to = "Value") %>%
    group_by(year, AgeGroup) %>%
    mutate(Total = sum(Value),
           Percentage = round((Value / Total * 100), 1)) %>%
    ungroup()
}

# Custom function to apply default layout settings (font, etc.)
apply_default_layout <- function(p) {
  p %>% layout(
    font = list(family = "HvDTrial Brandon Grotesque Reg", size = 16),  # Global font for plot
    title = list(font = list(family = "HvDTrial Brandon Grotesque Reg", size = 24)),  # Font for title
    xaxis = list(
      titlefont = list(family = "HvDTrial Brandon Grotesque Reg", size = 18),
      tickfont = list(family = "HvDTrial Brandon Grotesque Reg", size = 16)
    ),
    yaxis = list(
      titlefont = list(family = "HvDTrial Brandon Grotesque Reg", size = 18),
      tickfont = list(family = "HvDTrial Brandon Grotesque Reg", size = 16)
    ),
    legend = list(font = list(family = "HvDTrial Brandon Grotesque Reg", size = 15)),
    paper_bgcolor = '#FFF',
    plot_bgcolor = '#FFF',
    
    # Add annotations for the two lines of the caption
    annotations = list(
      list(
        text = "Source: Canadian Census Data",  
        x = 0,  
        y = -0.25,  
        xref = "paper",  
        yref = "paper",
        showarrow = FALSE,
        xanchor = "left", 
        yanchor = "bottom",
        font = list(family = "HvDTrial Brandon Grotesque Reg", size = 13, color = "black")
      ),
      list(
        text = "Data Hub By YouthREX",  # Second line of the caption
        x = 0, 
        y = -0.28,
        xref = "paper",
        yref = "paper",
        showarrow = FALSE,
        xanchor = "left",  #
        yanchor = "bottom",
        font = list(family = "HvDTrial Brandon Grotesque Reg", size = 13, color = "black")
      )
    ),
    margin = list(t = 30, b = 130)  
  )
}

## Function to create bar plot by specific category
bar_spec <- function(data, custom_colors, xcat, yval, yaxis_title, showlegend = TRUE, text_content = NULL, orientation = 'v') {
  # Precompute the border colors based on categories
  data$bordercolor <- custom_colors[data$category]
  
  text_to_use <- if (is.null(text_content)) {
    ~paste(format(Total, big.mark = ",", scientific = FALSE), '(', Percentage, '%)')
  } else {
    text_content
  }

  plot_ly(
    data = data, 
    x = xcat, 
    y = yval, 
    type = 'bar', 
    name = ~category,
    color = ~category, 
    colors = custom_colors,
    showlegend = showlegend,
    orientation = orientation,
    hoverinfo = 'text',
    text = text_to_use,
    textposition = 'none',
    marker = list(line = list(color = 'rgba(255,255,255,0)', width = 0.7)),
    hoverlabel = list(
      font = list(family = "HvDTrial Brandon Grotesque Reg", color = "black", size = 15),
      bgcolor = "white",
      bordercolor = ~bordercolor  # Use the precomputed bordercolor column
    )
  ) %>%
    layout(
      paper_bgcolor = '#FFF',
      plot_bgcolor = '#FFF',
      yaxis = list(title = yaxis_title), 
      barmode = 'stack',
      margin = list(t = 30),
      legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1, font = list(size = 15))
    )
}
