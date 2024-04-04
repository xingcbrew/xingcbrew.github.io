### This is the code to generate the plots for the Economic Wellbeing thematic page in the YouthREX Data Hub. 

library(tidyr)
library(plotly)
library(ggplot2)
library(dplyr)
library(htmlwidgets)


############## LICO ##############
lico_data <- read.csv("lico.csv", check.names = F)

lico <- lico_data %>%
  pivot_longer(cols = c(`2006`, `2011`, `2016`, `2021`), 
                names_to = "Year", 
                values_to = "Value") %>%
  group_by(Year) %>%
  mutate(Total = sum(Value),
         Percentage = round((Value / Total * 100), 1)) %>%
  ungroup()

lico_fig <- plot_ly(data = lico, x = ~Year, y = ~Value, 
                   color = ~category, colors = c('Not low income (LICO after tax)' = '#81AC40',
                                                 'Low income (LICO after tax)' = '#2693A6'),
               type = 'bar',
               hoverinfo = 'text',
               text = ~paste(Value, '(',Percentage,"%)")) %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Ontario Youth Aged 15-29 Who are LICO After Tax', y = 0.95),
         margin = list(t = 50),
         xaxis = list(title = ''),
         yaxis = list(title = 'Population'),
         barmode = 'stack',
         legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1))

saveWidget(lico_fig, file = "lico_fig.html")

############ Labour Force Status ###############
lab_data <- read.csv("labourforce.csv", check.names = F)

emp2021 <- lab_data %>%
  filter(category %in% c("Employed", "Unemployed")) %>%
  filter(year == '2021') %>% 
   pivot_longer(cols = `Age 15-19`:`Age 25-29`, names_to = "AgeGroup", values_to = "Count") %>%
  group_by(AgeGroup) %>%
  mutate(Total = sum(Count),
         Percentage = round((Count / Total) * 100, 1)) %>%
  ungroup()

emp2021_fig <- plot_ly(data = emp2021, x = ~AgeGroup, y = ~Count, color = ~category, 
                      colors = c('Employed' = '#FFC000', 
                                 'Unemployed' = '#2693A6'),
                      type = 'bar',
                      hoverinfo = 'text',
                      text = ~paste(Count, '(',Percentage,'%)'),
                      textposition = 'inside') %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         barmode = 'stack',
         title = list(text = 'Employment Status by Age', y = 0.95),
         margin = list(t = 60),
         xaxis = list(title = ''),
         yaxis = list(title = 'Population'),
         legend = list(orientation = 'h',
                       x = 0.5, 
                       xanchor = 'center', 
                       y = -0.1,
                       font = list(size = 14)))

emp2016 <- lab_data %>%
  filter(category %in% c("Employed", "Unemployed")) %>%
  filter(year == '2016') %>% 
   pivot_longer(cols = `Age 15-19`:`Age 25-29`, names_to = "AgeGroup", values_to = "Count") %>%
  group_by(AgeGroup) %>%
  mutate(Total = sum(Count),
         Percentage = round((Count / Total) * 100, 1)) %>%
  ungroup()

emp2016_fig <- plot_ly(data = emp2016, x = ~AgeGroup, y = ~Count, color = ~category, 
                      colors = c('Employed' = '#FFC000', 
                                 'Unemployed' = '#2693A6'),
                      type = 'bar',
                      hoverinfo = 'text',
                      text = ~paste(Count, '(',Percentage,'%)'),
                      textposition = 'inside',
                      showlegend = F) %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         barmode = 'stack',
         title = list(text = 'Employment Status by Age', y = 0.95),
         margin = list(t = 60),
         xaxis = list(title = ''),
         yaxis = list(title = 'Population'),
         legend = list(orientation = 'h',
                       x = 0.5, 
                       xanchor = 'center', 
                       y = -0.1,
                       font = list(size = 14)))

emp2011 <- lab_data %>%
  filter(category %in% c("Employed", "Unemployed")) %>%
  filter(year == '2011') %>% 
   pivot_longer(cols = `Age 15-19`:`Age 25-29`, names_to = "AgeGroup", values_to = "Count") %>%
  group_by(AgeGroup) %>%
  mutate(Total = sum(Count),
         Percentage = round((Count / Total) * 100, 1)) %>%
  ungroup()

emp2011_fig <- plot_ly(data = emp2011, x = ~AgeGroup, y = ~Count, color = ~category, 
                      colors = c('Employed' = '#FFC000', 
                                 'Unemployed' = '#2693A6'),
                      type = 'bar',
                      hoverinfo = 'text',
                      text = ~paste(Count, '(',Percentage,'%)'),
                      textposition = 'inside',
                      showlegend = F) %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         barmode = 'stack',
         title = list(text = 'Employment Status by Age', y = 0.95),
         margin = list(t = 60),
         xaxis = list(title = ''),
         yaxis = list(title = 'Population'),
         legend = list(orientation = 'h',
                       x = 0.5, 
                       xanchor = 'center', 
                       y = -0.1,
                       font = list(size = 14)))

emp_fig <- subplot(emp2011_fig, emp2016_fig, emp2021_fig, shareY = TRUE, titleX = TRUE) %>%
  layout(title = 'Employment Status of Youth in the Labour Force',
          annotations = list(
            list(text = "2011", 
                x = 0.15, xref = "paper", y = 1.00, yref = "paper", 
                showarrow = FALSE, font = list(size = 12)),
           list(text = "2016", 
                x = 0.5, xref = "paper", y = 1.00, yref = "paper", 
                showarrow = FALSE, font = list(size = 12)),
           list(text = "2021", 
                x = 0.85, xref = "paper", y = 1.0, yref = "paper", 
                showarrow = FALSE, font = list(size = 12))
         ),
         legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1))

saveWidget(emp_fig, file = "emp_fig.html")

## Unemployment ##

ur <- lab_data %>%
  filter(category == "Unemployment rate %") %>%
   pivot_longer(cols = `Age 15-19`:`Age 25-29`, names_to = "AgeGroup", values_to = "Value")

ur$year <- as.factor(ur$year)

ur_fig <- plot_ly(data = ur, x = ~year, y = ~Value, color = ~AgeGroup, 
               colors = c('Age 15-19' = '#2693A6', 
                          'Age 20-24' = '#81AC40',
                          'Age 25-29' = '#F0592B'),
               type = 'scatter', mode = 'lines+markers',
               marker = list(size = 8, line = list(width = 4)),
               hoverinfo = 'text',
               text = ~paste(Value,'% in', year)) %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Unemployment Rate % of Ontario Youth', y = 0.95),
         margin = list(t = 50),
         xaxis = list(title = ''),
         yaxis = list(title = 'Percent Unemployed'),
         legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1))

saveWidget(ur_fig, file = "ur_fig.html")

## Pariticpation ##

part <- lab_data %>% 
  filter(category == "Participation rate %") %>%
  pivot_longer(cols = `Age 15-19`:`Age 25-29`, names_to = "AgeGroup", values_to = "Value") 
part$year <- as.factor(part$year)

part_fig <- plot_ly(data = part, x = ~year, y = ~Value, color = ~AgeGroup, 
              colors = c('Age 15-19' = '#2693A6', 
                          'Age 20-24' = '#81AC40',
                          'Age 25-29' = '#F0592B'),
               type = 'scatter', mode = 'lines+markers',
               marker = list(size = 8, line = list(width = 4)),
               hoverinfo = 'text',
               text = ~paste(Value,'%)')) %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Participation Rate of Ontario Youth', y = 0.95),
         margin = list(t = 50),
         xaxis = list(title = ''),
         yaxis = list(title = 'Population'),
         legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1))
  
saveWidget(part_fig, file = "part_fig.html")

########## Class of Worker 2021 ##########

worker_data <- read.csv("workers2021.csv", check.names = F)
 
worker <- worker_data %>%
  filter(category %in% c("Working for wages, salary, tips or commission / Employee", "Self employed incorporated", "Self employed unincorporated", "Unpaid family workers")) %>%
   pivot_longer(cols = `Age 15-19`:`Age 25-29`, names_to = "AgeGroup", values_to = "Value") %>%
  group_by(AgeGroup) %>%
  mutate(Total = sum(Value),
         Percentage = round((Value/ Total) * 100, 1)) %>%
  ungroup()

worker_figs <- worker %>% 
  split(.$category) %>% 
  lapply(function(data) {
    plot_ly(data = data, x = ~AgeGroup, y = ~Value, type = 'bar',
            color = ~category,
            colors = c('Working for wages, salary, tips or commission / Employee' = '#2693A6', 
                          'Self employed incorporated' = '#81AC40',
                          'Self employed unincorporated' = '#F0592B',
                       'Unpaid family workers' = '#FFC000'),
            hoverinfo = 'text',
            text = ~paste(Value, '(',Percentage,'% of',AgeGroup,'workers)'),
            textposition = 'inside',
            name = unique(data$category)) %>%
      layout(yaxis = list(title = 'Population'), barmode = 'group',  
             xaxis = list(title = ''))
  })

worker_fig <- subplot(worker_figs, nrows = 2, shareX = TRUE, titleX = TRUE) %>%
  layout(title = list(text = 'Type of Worker of Ontario Youth in 2021', y = 0.95),
         margin = list(t = 50),
         legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1),
         paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF')

saveWidget(worker_fig, file = "worker_fig.html")

########## Self Employment ##########

se_data <- read.csv("selfemp.csv", check.names = F)

se <- se_data %>% 
  filter(category == "Percent Self Employed") %>%
   pivot_longer(cols = c(`2006`, `2011`, `2016`, `2021`), 
                names_to = "Year", 
                values_to = "Value")

se_fig <- plot_ly(data = se, x = ~Year, y = ~Value, color = ~age, 
               colors = c('Age 15-19' = '#2693A6', 
                          'Age 20-24' = '#81AC40',
                          'Age 25-29' = '#F0592B'),
               type = 'scatter', mode = 'lines+markers',
               marker = list(size = 8, line = list(width = 4)),
               hoverinfo = 'text',
               text = ~paste(Value,'% in', Year)) %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Percent of Classed Workers who are Self-Employed', y = 0.95),
         margin = list(t = 50),
         xaxis = list(title = ''),
         yaxis = list(title = 'Percent'),
         legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1))

saveWidget(se_fig, file = "se_fig.html")

##### Special Characteristics by Immigration Status ####

# Load and Prepare Data by Immigration Status
byimm_data <- read.csv("byimm2021.csv", check.names = F)
byimm_data$category <- byimm_data$category <- trimws(byimm_data$category, which = "left") 
byimm_data$immigration <- byimm_data$immigration <- trimws(byimm_data$immigration, which = "left") 

## Unemployment by immigration status

unimm <- byimm_data %>%
  filter(category == "Unemployment rate %") %>%
  filter(immigration %in% c("Immigrants", "Non-immigrants")) %>%
  pivot_longer(cols = `Age 15-19`:`Age 25-29`, names_to = "AgeGroup", values_to = "Value") 

unimm_fig <- plot_ly(data = unimm, x = ~AgeGroup, y = ~Value, color = ~immigration, 
                      colors = c('Immigrants' = '#FFC000', 
                                 'Non-immigrants' = '#2693A6'),
                      type = 'bar',
                      hoverinfo = 'text',
                      text = ~paste(Value,'%'),
                      textposition = 'inside') %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Unemployment Rate (%) by Immigration Status', y = 0.95),
         margin = list(t = 60),
         xaxis = list(title = ''),
         yaxis = list(title = 'Percent'),
         legend = list(orientation = 'h',
                       x = 0.5, 
                       xanchor = 'center', 
                       y = -0.1,
                       font = list(size = 14)))

saveWidget(unimm_fig, file = "unimm_fig.html")

unref <- byimm_data %>%
  filter(category == "Unemployment rate %") %>%
  filter(immigration %in% c("Refugees", "Economic immigrants", "Immigrants sponsored by family", "Non-permanent residents", "Other immigrants")) %>%
  pivot_longer(cols = `Age 20-24`:`Age 25-29`, names_to = "AgeGroup", values_to = "Value") 

unref_fig <- plot_ly(data = unref, x = ~AgeGroup, y = ~Value, color = ~immigration, 
                      colors = c('Refugees' = '#25384F', 
                                 'Economic immigrants' = '#2693A6',
                                 'Immigrants sponsored by family' = '#F0592B',
                                 'Non-permanent residents' = '#81AC40',
                                 'Other immigrants' = '#FFC000'
                                 ),
                      type = 'bar',
                      hoverinfo = 'text',
                      text = ~paste(Value,'%'),
                      textposition = 'inside') %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Unemployment Rate (%) by Type of Immigrant', y = 0.95),
         margin = list(t = 60),
         xaxis = list(title = ''),
         yaxis = list(title = 'Percent'),
         legend = list(orientation = 'h',
                       x = 0.5, 
                       xanchor = 'center', 
                       y = -0.1,
                       font = list(size = 14)))

saveWidget(unref_fig, file = "unref_fig.html")

## Participation Rate by Immigration 
partimm <- byimm_data %>%
  filter(category == "Participation rate %") %>%
  filter(immigration %in% c("Immigrants", "Non-immigrants")) %>%
  pivot_longer(cols = `Age 15-19`:`Age 25-29`, names_to = "AgeGroup", values_to = "Value") 

partimm_fig <- plot_ly(data = partimm, x = ~AgeGroup, y = ~Value, color = ~immigration, 
                      colors = c('Immigrants' = '#FFC000', 
                                 'Non-immigrants' = '#2693A6'),
                      type = 'bar',
                      hoverinfo = 'text',
                      text = ~paste(Value,'%'),
                      textposition = 'inside') %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Participation Rate (%) by Immigration Status', y = 0.95),
         margin = list(t = 60),
         xaxis = list(title = ''),
         yaxis = list(title = 'Percent'),
         legend = list(orientation = 'h',
                       x = 0.5, 
                       xanchor = 'center', 
                       y = -0.1,
                       font = list(size = 14)))

saveWidget(partimm_fig, file = "partimm_fig.html")

## NEET Ontario
neet_data <- read.csv("neet.csv", check.names = F)

neet <- neet_data %>%
  pivot_longer(cols = c(`2019`, `2020`, `2021`, `2022`, `2023`), 
                names_to = "Year", 
                values_to = "Value")
neet_fig <- plot_ly(data = neet, x = ~Year, y = ~Value, color = ~AgeGroup, 
               colors = c('Age 15-19' = '#2693A6', 
                          'Age 20-24' = '#81AC40',
                          'Age 25-29' = '#F0592B',
                          'Age 15-29' = '#FFC000'),
               type = 'scatter', mode = 'lines+markers',
               marker = list(size = 8, line = list(width = 4)),
               hoverinfo = 'text',
               text = ~paste(Value,'% in', Year)) %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Percent of Ontario Youth Who Are NEET', y = 0.95),
         margin = list(t = 50),
         xaxis = list(title = ''),
         yaxis = list(title = 'Percent'),
         legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1))

saveWidget(neet_fig, file = "neet.html")
