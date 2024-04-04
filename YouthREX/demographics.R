### This is the code to generate the plots for the Demographic thematic page in the YouthREX Data Hub. 

library(tidyr)
library(plotly)
library(ggplot2)
library(dplyr)
library(htmlwidgets)


############## Population by Age ##############
pba_data <- read.csv("population_by_age.csv", check.names = F)

pba <- pba_data %>%
  filter(category %in% c("Age 15-19", "Age 20-24", "Age 25-29")) %>%
  pivot_longer(cols = c(`2006`, `2011`, `2016`, `2021`), 
                names_to = "Year", 
                values_to = "Value")

custom_colors <- c("Age 15-19" = "#2693A6", "Age 20-24" = "#81AC40", "Age 25-29" = "#F0592B")

pba_fig <- plot_ly(data = pba, x = ~Year, y = ~Value, color = ~category, 
               colors = custom_colors,
               type = 'scatter', mode = 'lines+markers',
               marker = list(size = 8, line = list(width = 4)),
               hoverinfo = 'text',
               text = ~paste(category, ':', Value, 'in', Year)) %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Population Change Over Time by Age Group', y = 0.95),
         margin = list(t = 50),
         xaxis = list(title = 'Year'),
         yaxis = list(title = 'Population'),
         legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.2))

saveWidget(pba_fig, file = "pba_fig.html")

########### Youth as proportion of Ontario population ############
prop_data <- read.csv("prop.csv", check.names = FALSE)
prop <- prop_data %>%
  pivot_longer(cols = c(`2006`, `2011`, `2016`, `2021`), names_to = "Year", values_to = "Value") %>% 
  group_by(Year) %>%
  mutate(Total = sum(Value),
         Percentage = round((Value / Total * 100), 1)) %>%
  ungroup()

prop_colors <- c("Youth Aged 15-29" = "#2693A6", "Non-Youth" = "#81AC40")

prop_fig <- plot_ly(data = prop, x = ~Year, y = ~Value, 
                    type = 'bar', 
                    color = ~category,
                    colors = prop_colors,
                    hoverinfo = 'text',
                    text = ~paste(Value, '<br>(',Percentage,'%)'),
                    textposition = 'inside',
                    showlegend = F
                    ) %>%
          layout(paper_bgcolor = '#F5F5EF',
                 plot_bgcolor = '#F5F5EF',
                 yaxis = list(title = 'Population'), 
                 barmode = 'stack',
                 title = list(text = 'Youth Aged 15-29 as Proportion of the Ontario Population', y = 0.95),
                 margin = list(t = 50),
                 legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.2, font = list(size = 14)),
                 xaxis = list(titlefont = list(size = 14), tickfont = list(size = 14)),
                 yaxis = list(title = 'Population', titlefont = list(size = 14), tickfont = list(size = 14)))


########### Youth as proportion of Canadian population ############
can_data <- read.csv("canada_youth.csv", check.names = FALSE)
can <- can_data %>%
  filter(category %in% c("Youth Aged 15-29", "Non-Youth" )) %>%
  pivot_longer(cols = c(`2006`, `2011`, `2016`, `2021`), names_to = "Year", values_to = "Value") %>% 
  group_by(Year) %>%
  mutate(Total = sum(Value),
         Percentage = round((Value / Total * 100), 1)) %>%
  ungroup()

can_colors <- c("Youth Aged 15-29" = "#2693A6", "Non-Youth" = "#81AC40")

can_fig <- plot_ly(data = can, x = ~Year, y = ~Value, 
                    type = 'bar', 
                    color = ~category,
                    colors = can_colors,
                    hoverinfo = 'text',
                    text = ~paste(Value, '<br>(',Percentage,'%)'),
                    textposition = 'inside'
                    ) %>%
          layout(paper_bgcolor = '#F5F5EF',
                 plot_bgcolor = '#F5F5EF',
                 yaxis = list(title = 'Population'), 
                 barmode = 'stack',
                 title = list(text = 'Youth Aged 15-29 as Proportion of the Canadian Population', y = 0.95),
                 margin = list(t = 50),
                 legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.2, font = list(size = 14)),
                 xaxis = list(titlefont = list(size = 14), tickfont = list(size = 14)),
                 yaxis = list(title = 'Population', titlefont = list(size = 14), tickfont = list(size = 14)))


co_fig <- subplot(can_fig, prop_fig, shareX = TRUE, shareY = FALSE, titleX = TRUE, margin = 0.05) %>%
  layout(title = 'Youth 15-29 as a Proportion of the Overall Population',
          annotations = list(
           list(text = "Canada", 
                x = 0.2, xref = "paper", y = 1.00, yref = "paper", 
                showarrow = FALSE, font = list(size = 12)),
           list(text = "Ontario", 
                x = 0.8, xref = "paper", y = 1.0, yref = "paper", 
                showarrow = FALSE, font = list(size = 12))
         ),
         legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1))

saveWidget(co_fig, file = "co_fig.html")

################ Age by Gender ########################
abg_data <- read.csv("age_by_gender.csv", check.names = F)

# abg <- abg_data %>%
#   pivot_longer(cols = c(`2006`, `2011`, `2016`, `2021`), 
#                 names_to = "Year", 
#                 values_to = "Value")
# 
# m <- abg %>% filter(gender == 'Male') 
# 
# m_fig <- plot_ly(data = m, x = ~Year, y = ~Value, 
#                    type = 'bar', 
#                    name = ~age_group,
#                    color = ~age_group, colors = c('Age 15-19' = '#2693A6', 
#                                                   'Age 20-24' = '#81AC40',
#                                                   'Age 25-29' = '#F0592B'),
#                    hoverinfo = 'text',
#                    text = ~paste(age_group,':', Value),
#                    marker = list(line = list(color = 'rgba(255,255,255,0)', width = 0.7))) %>%
#             layout(paper_bgcolor = '#F5F5EF',
#                    plot_bgcolor = '#F5F5EF',
#                    yaxis = list(title = 'Population'),
#                    xaxis = list(title = ''),
#                    title = list(text = 'Male Population', y = 0.96),
#                    legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.2, font = list(size = 14)))
# 
# f <- abg %>% filter(gender == 'Female') 
# 
# f_fig <- plot_ly(data = f, x = ~Year, y = ~Value, 
#                    type = 'bar', 
#                    name = ~age_group,
#                    color = ~age_group, colors = c('Age 15-19' = '#2693A6', 
#                                                   'Age 20-24' = '#81AC40',
#                                                   'Age 25-29' = '#F0592B'),
#                    hoverinfo = 'text',
#                    text = ~paste(age_group,':', Value),
#                    marker = list(line = list(color = 'rgba(255,255,255,0)', width = 0.7)),
#                    showlegend = F) %>%
#             layout(paper_bgcolor = '#F5F5EF',
#                    plot_bgcolor = '#F5F5EF',
#                    yaxis = list(title = 'Population'),
#                    xaxis = list(title = ''),
#                    title = list(text = 'Female Population', y = 0.96),
#                    legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.2, font = list(size = 14)))
# 
# abg_fig <- subplot(m_fig, f_fig, shareY = TRUE, titleX = TRUE) %>%
#   layout(title = 'Ontario Youth Age 15-29 Gender',
#           annotations = list(
#            list(text = "Male", 
#                 x = 0.2, xref = "paper", y = 1.00, yref = "paper", 
#                 showarrow = FALSE, font = list(size = 12)),
#            list(text = "Female", 
#                 x = 0.8, xref = "paper", y = 1.0, yref = "paper", 
#                 showarrow = FALSE, font = list(size = 12))
#          ),
#          legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1))

## Gender as line charts

m_line <- plot_ly(data = m, x = ~Year, y = ~Value, 
                   type = 'scatter', mode = 'lines+markers',
                   marker = list(size = 8, line = list(width = 3)),
                   name = ~age_group,
                   color = ~age_group, colors = c('Age 15-19' = '#2693A6', 
                                                  'Age 20-24' = '#81AC40',
                                                  'Age 25-29' = '#F0592B'),
                   hoverinfo = 'text',
                   text = ~paste(age_group,':', Value)) %>%
            layout(paper_bgcolor = '#F5F5EF',
                   plot_bgcolor = '#F5F5EF',
                   yaxis = list(title = 'Population'),
                   xaxis = list(title = ''),
                   title = list(text = 'Male Population', y = 0.96),
                   margin = list(t = 50),
                   legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.2, font = list(size = 14)))

f_line <- plot_ly(data = f, x = ~Year, y = ~Value, 
                   type = 'scatter', mode = 'lines+markers',
                   marker = list(size = 8, line = list(width = 3)),
                   showlegend = F,
                   name = ~age_group,
                   color = ~age_group, colors = c('Age 15-19' = '#2693A6', 
                                                  'Age 20-24' = '#81AC40',
                                                  'Age 25-29' = '#F0592B'),
                   hoverinfo = 'text',
                   text = ~paste(age_group,':', Value)) %>%
            layout(paper_bgcolor = '#F5F5EF',
                   plot_bgcolor = '#F5F5EF',
                   yaxis = list(title = 'Population'),
                   xaxis = list(title = ''),
                   title = list(text = 'Female Population', y = 0.96),
                   margin = list(t = 50),
                   legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.2, font = list(size = 14)))

abg_line <- subplot(m_line, f_line, shareY = TRUE, titleX = TRUE) %>%
  layout(title = 'Ontario Youth Age 15-29 Gender',
          annotations = list(
           list(text = "Male", 
                x = 0.2, xref = "paper", y = 1.00, yref = "paper", 
                showarrow = FALSE, font = list(size = 12)),
           list(text = "Female", 
                x = 0.8, xref = "paper", y = 1.0, yref = "paper", 
                showarrow = FALSE, font = list(size = 12))
         ),
         legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1))


saveWidget(abg_line, file = "abg_line.html")

############### Place of birth #######################

pob_data <- read.csv("place_of_birth.csv", check.names = F) %>%
  filter(category %in% c("Born in Canada", "Born outside of Canada"))

pob <- pob_data %>% pivot_longer(cols = c(`2006`, `2011`, `2016`, `2021`), 
                names_to = "Year", 
                values_to = "Value") %>% 
  group_by(Year) %>%
  mutate(Total = sum(Value),
         Percentage = round((Value / Total * 100), 1)) %>%
  ungroup()

pob_fig <- plot_ly(data = pob, x = ~Year, y = ~Value, 
                   type = 'bar', 
                   name = ~category,
                   color = ~category, colors = c('Born in Canada' = '#FFC000', 
                                                  'Born outside of Canada' = '#81AC40'),
                   hoverinfo = 'text',
                   text = ~paste(category,':', Value, ' (',Percentage,'%)'),
                   marker = list(line = list(color = 'rgba(255,255,255,0)', width = 0.7))) %>%
          layout(paper_bgcolor = '#F5F5EF',
                 plot_bgcolor = '#F5F5EF',
                 yaxis = list(title = 'Place of Birth'), 
                 xaxis = list(title = ''),
                 title = list(text = 'Place of Birth of Ontario Youth', y = 0.95),
                 margin = list(t = 50),
                 legend = list(orientation = 'h', 
                               x = 0.5, 
                               xanchor = 'center', 
                               y = -0.1,
                               font = list(size = 14)))

saveWidget(pob_fig, file = "pob_fig.html")

# Percent of youth born outside Canada by age group 
boc_data <- read.csv("born_outside_per.csv", check.names = F)
boc <- boc_data %>%
  pivot_longer(cols = c(`2006`, `2011`, `2016`, `2021`), 
                names_to = "Year", 
                values_to = "Value")

boc_colors <- c("Age 15-19" = "#2693A6", "Age 20-24" = "#81AC40", "Age 25-29" = "#F0592B")

boc_fig <- plot_ly(data = boc, x = ~Year, y = ~Value, color = ~category, 
               type = 'scatter', mode = 'lines+markers',
               marker = list(size = 8, line = list(width = 4)),
               colors = boc_colors,
               hoverinfo = 'text',
               text = ~paste(category, ':', Value,'%')) %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Percent of Youth Born Outside Canada', y = 0.95),
         margin = list(t = 50),
         xaxis = list(title = ''),
         yaxis = list(title = 'Percent'),
         legend = list(orientation = 'h', 
                               x = 0.5, 
                               xanchor = 'center', 
                               y = -0.2,
                               font = list(size = 14)))

saveWidget(boc_fig, file = "boc.html")

############### Visible minority ###################
vm_data <- read.csv("vismin.csv", check.names = F)
vm <- vm_data %>%
  pivot_longer(cols = c(`2006`, `2011`, `2016`, `2021`), 
                names_to = "Year", 
                values_to = "Value") %>%
  group_by(Year) %>%
   mutate(Total = sum(Value),
         Percentage = round((Value / Total * 100), 1)) %>%
  ungroup()

vm_fig <-
  plot_ly(data = vm, x = ~Year, y = ~Value, 
          type = 'bar', 
          name = ~category,
          color = ~category, 
          colors = c('Non-Visible Minority' = '#FFC000', 
                     'Visible Minority' = '#81AC40'),
          hoverinfo = 'text',
          text = ~paste(category,':', Value, ' (',Percentage,'%)'),
          marker = list(line = list(color = 'rgba(255,255,255,0)', width = 0.7))) %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         yaxis = list(title = 'Population'), 
         barmode = 'stack',
         title = list(text = 'Visible Minority as Proportion of All Youth Aged 15-29', y = 0.95),
         margin = list(t = 50),
         legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.2, font = list(size = 14)))

## Visible Minority as part of 100 Percent
vm_100 <- plot_ly(data = vm, x = ~Year, y = ~Percentage, type = 'bar', 
                  color = ~category, 
                  colors = c('Non-Visible Minority' = '#FFC000', 
                     'Visible Minority' = '#81AC40'),
                  hoverinfo = 'text',
                  text = ~paste(category,':', Value, '(',Percentage,'%)')) %>%
  layout(yaxis = list(title = 'Percentage', tickformat = ',.2r', range = c(0, 100)),
         barmode = 'stack',
         paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         yaxis = list(title = 'Population'), 
         barmode = 'stack',
         title = list(text = 'Visible Minority as Proportion of All Youth Aged 15-29', y = 0.95),
         margin = list(t = 50),
         legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.2, font = list(size = 14)))

saveWidget(vm_fig, file = "vismin.html")
saveWidget(vm_100, file = "vismin100.html")

## Visible Minority Categories Breakdown
vmc_data <- read.csv("vismin_breakdown.csv", check.names = F)

vmc <- vmc_data %>%
  pivot_longer(cols = c(`2016`, `2021`), 
                names_to = "Year", 
                values_to = "Value") 

vmc_fig <- vmc %>%
  plot_ly(x = ~Year, y = ~Value, 
          type = 'bar',
          name = ~category,
          color = ~category, colors = c('Arab' = '#25384F', 
                                        'Chinese' = '#2693A6',
                                        'Japanese' = '#FFC000',
                                        'Latin American' = '#81AC40',
                                        'South Asian' = '#F0592B',
                                        'Black' = '#2B2F73',
                                        'Filipino' = '#005F6E',
                                        'Korean' = '#8B4513',
                                        'Multiple visible minorities' = '#B71E41',
                                        'Southeast Asian' = '#046307',
                                        'West Asian' = '#3a3b3c',
                                        'Visible minority, n.i.e.' = '#708090'),
          hoverinfo = 'text',
          text = ~paste(category,':', Value),
          textposition = 'inside') %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         yaxis = list(title = 'Population'), 
         title = list(text = 'Youth Aged 15-29 by Visible Minority Identity', y = 0.95),
         legend = list(orientation = 'h', 
                       x = 0.5, xanchor = 'center', 
                       y = -0.2))

saveWidget(vmc_fig, file = "vmc.html")

################### Aboriginal #####################
ab_data <- read.csv("aboriginal.csv", check.names = F)
ab <- ab_data %>% filter(category == "Aboriginal identity") %>% pivot_longer(cols = c(`2006`, `2011`, `2016`, `2021`), 
                names_to = "Year", 
                values_to = "Value")

ab_fig <- plot_ly(data = ab, x = ~Year, y = ~Value,
               type = 'scatter', mode = 'lines+markers',
               hoverinfo = 'text',
               text = ~paste(Value, ' in ', Year)) %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Aboriginal Youth', y = 0.95),
         margin = list(t = 50),
         xaxis = list(title = 'Year'),
         yaxis = list(title = 'Population'),
         legend = list(orientation = 'h', 
                       x = 0.5, xanchor = 'center', 
                       y = -0.2))

saveWidget(ab_fig, file = "aboriginal.html")

nonab <- ab_data %>% filter(category == "Non-Aboriginal identity") %>% pivot_longer(cols = c(`2006`, `2011`, `2016`, `2021`), 
                names_to = "Year", 
                values_to = "Value")

nonab_fig <- plot_ly(data = nonab, x = ~Year, y = ~Value,
               type = 'scatter', mode = 'lines+markers',
               marker = list(size = 8, line = list(width = 4)),
               hoverinfo = 'text',
               text = ~paste(Value, ' in ', Year)) %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Non-Aboriginal Youth', y = 0.95),
         margin = list(t = 50),
         xaxis = list(title = ''),
         yaxis = list(title = 'Population'),
         legend = list(orientation = 'h', 
                       x = 0.5, xanchor = 'center', 
                       y = -0.2))

################# Official Languages ####################
lang_data <- read.csv("language.csv", check.names = F)

lang <- lang_data %>% pivot_longer(cols = c(`2006`, `2011`, `2016`, `2021`), 
                               names_to = "Year", values_to = "Value") %>%
  group_by(Year) %>%
  mutate(Total = sum(Value),
         Percentage = round((Value / Total) * 100, 1)) %>%
  ungroup()

lang_figs <- lang %>% 
  split(.$category) %>% 
  lapply(function(data) {
    plot_ly(data = data, x = ~Year, y = ~Value, type = 'bar',
            color = ~category, colors = c('Both English and French' = '#25384F', 
                                        'English only' = '#2693A6',
                                        'French only' = '#FFC000',
                                        'Neither English nor French' = '#81AC40'),
            hoverinfo = 'text',
            text = ~paste(Value, '(',Percentage,'%)'),
            name = unique(data$category)) %>%
      layout(yaxis = list(title = 'Population'), barmode = 'group',  
             xaxis = list(title = ''))
  })

lang_fig <- subplot(lang_figs, nrows = 4, shareX = TRUE, titleX = TRUE) %>%
  layout(title = list(text = 'Ontario Youth Age 15-29 Knowledge of Official Languages', y = 0.95),
         margin = list(t = 50),
         legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1))

saveWidget(lang_fig, file = "lang.html")

#################### Place of Residence 5 Years Ago ##########################
movers_data <- read.csv("movers.csv", check.names = F)

movers <- movers_data %>%
  pivot_longer(cols = c(`2006`, `2011`, `2016`, `2021`), 
               names_to = "Year", 
               values_to = "Value") %>%
  group_by(Year) %>%
   mutate(Total = sum(Value),
         Percentage = round((Value / Total * 100), 1)) %>%
  ungroup()


movers_fig <- plot_ly(data = movers, x = ~Year, y = ~Value, color = ~category, 
                      colors = c('External migrants' = '#FFC000', 
                                 'Internal migrants' = '#2693A6',
                                 'Non-migrants' = '#81AC40'),
                      type = 'scatter', mode = 'lines+markers',
                      marker = list(size = 8, line = list(width = 4)),
                      hoverinfo = 'text',
                      text = ~paste(category, ': (',Percentage,'%)')) %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Breakdown of Movers by Migration Status', y = 0.95),
         margin = list(t = 50),
         xaxis = list(title = ''),
         yaxis = list(title = 'Population'),
         legend = list(orientation = 'h', 
                       x = 0.5, 
                       xanchor = 'center', 
                       y = -0.2,
                       font = list(size = 14)))

saveWidget(movers_fig, file = "movers.html")

############### Immigration ######################
imm_data <- read.csv("imm.csv", check.names = F)

imm <- imm_data %>%  pivot_longer(cols = c(`2016`, `2021`), 
                names_to = "Year", 
                values_to = "Value") %>%
group_by(Year) %>%
  mutate(Total = sum(Value),
         Percentage = round((Value / Total) * 100, 1)) %>%
  ungroup()

imm_fig <- plot_ly(data = imm, x = ~Year, y = ~Value, color = ~category, 
                      colors = c('Non-permanent residents' = '#FFC000', 
                                 'Non-immigrants' = '#81AC40',
                                 'Immigrants' = '#2693A6'),
                      type = 'bar',
                      hoverinfo = 'text',
                      text = ~paste(category, ':', Value, '(',Percentage,'%)'),
                      textposition = 'inside') %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         barmode = 'stack',
         title = list(text = 'Immigration Status of Ontario Youth Aged 15-29', y = 0.95),
         margin = list(t = 50),
         xaxis = list(title = ''),
         yaxis = list(title = 'Population'),
         legend = list(orientation = 'h', 
                       x = 0.5, 
                       xanchor = 'center', 
                       y = -0.2,
                       font = list(size = 14)))

saveWidget(imm_fig, file = "immigrants.html")

########## Immigrant make up in 2016 and 2021 #############
imm2_data <- read.csv("imm2.csv", check.names = F)

imm2 <- imm2_data %>%  
  filter(category %in% c("Economic immigrants", "Immigrants sponsored by family", "Refugees", "Other immigrants")) %>%
  filter(year == '2021') %>%
  pivot_longer(cols = `Age 15-19`:`Age 25-29`, names_to = "AgeGroup", values_to = "Count") %>%
  group_by(AgeGroup) %>%
  mutate(Total = sum(Count),
         Percentage = round((Count / Total) * 100, 1)) %>%
  ungroup()
imm2_fig <- plot_ly(data = imm2, x = ~AgeGroup, y = ~Count, color = ~category, 
                      colors = c('Economic immigrants' = '#FFC000', 
                                 'Immigrants sponsored by family' = '#81AC40',
                                 'Refugees' = '#2693A6',
                                 'Other immigrants' = '#F0592B'),
                      type = 'bar',
                      hoverinfo = 'text',
                      text = ~paste(category, ':', Count, '(',Percentage, '%)'),
                      textposition = 'inside') %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         barmode = 'stack',
         title = list(text = 'Immigrant Type of Ontario Youth by Age Group in 2021', y = 0.95),
         margin = list(t = 60),
         xaxis = list(title = 'Age Group'),
         yaxis = list(title = 'Population'),
         legend = list(orientation = 'h',
                       x = 0.5, 
                       xanchor = 'center', 
                       y = -0.1,
                       font = list(size = 14)))

saveWidget(imm2_fig, file = "imm2.html")

############# POB by Visible Minority #############

pobvis <- read.csv("pob_vismin.csv", check.names = F)

## VM total
pobvis$vismin <- trimws(pobvis$vismin, which = "left") 
pobvis$pob <- trimws(pobvis$pob, which = "left") 

pobvis$total <- pobvis$`Age 15-19` + pobvis$`Age 20-24` + pobvis$`Age 25-29`

onlyvm <- pobvis %>% 
  filter(vismin == "Total visible minority population") %>%
  pivot_longer(cols = c(`Age 15-19`, `Age 20-24`, `Age 25-29`), 
                        names_to = "Age_Group", values_to = "Value") %>%
  group_by(Age_Group) %>%
  mutate(Total = sum(Value),
         Percentage = round((Value / Total) * 100, 1)) %>%
  ungroup()

onlyvm_fig <- plot_ly(data = onlyvm, x = ~Age_Group, y = ~Value, color = ~pob, 
               type = 'bar',
               colors = c('Born outside Canada' = '#FFC000', 
                          'Born inside Canada' = '#81AC40'),
               hoverinfo = 'text',
               text = ~paste(Value, "(",Percentage,"%)"),
               textposition = 'inside') %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Place of Birth of Visible Minority Youth in Ontario 2021', y = 0.95),
         margin = list(t = 50),
         xaxis = list(title = ''),
         yaxis = list(title = 'Population'),
         legend = list(orientation = 'h', 
                               x = 0.5, 
                               xanchor = 'center', 
                               y = -0.1,
                               font = list(size = 14)))

saveWidget(onlyvm_fig, file = "onlyvm.html")

## VM Breakdown

vmb <- pobvis %>% filter(vismin %in% c("South Asian", "Chinese", "Black", "Filipino", "Arab", "Latin American", "Southeast Asian", "West Asian", "Korean", "Japanese", "Visible minority, n.i.e.", "Multiple visible minorities")) %>% 
  select("pob", "vismin", "total") %>%
  group_by(vismin) %>%
  mutate(Totalvm = sum(total),
         Percentage = round((total / Totalvm) * 100, 1)) %>%
  ungroup()

vmb_fig <- plot_ly(data = vmb, x = ~vismin, y = ~total, color = ~pob, 
               type = 'bar', 
               colors = c('Born outside Canada' = '#FFC000', 
                          'Born inside Canada' = '#81AC40'),
               hoverinfo = 'text',
               text = ~paste(total, "(",Percentage,"%)"),
               textposition = 'inside') %>%
  layout(paper_bgcolor = '#F5F5EF',
         plot_bgcolor = '#F5F5EF',
         title = list(text = 'Place of Birth of Visible Minority Youth in Ontario 2021', y = 0.95),
         margin = list(t = 50),
         xaxis = list(title = 'Visible Minority Identity'),
         yaxis = list(title = 'Population'))

saveWidget(vmb_fig, file = "vmb.html")

#### Print out all figs #### 

pba_fig
prop_fig
co_fig
abg_line
pob_fig
boc_fig
vm_100fig
vmc_fig
ab_fig
lang_fig
movers_fig
imm_fig
imm2_fig
onlyvm_fig
vmb_fig


############# Map #############
# census <- read.csv("census2021.csv")
# 
# cd <- st_read("cd_map/cd.shp")


