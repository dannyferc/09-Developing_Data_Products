library(shiny)

#data processing libraries
library(XLConnect)

#load olympic dataframe
df <- readWorksheetFromFile("data/OlympicAthletes_0.xlsx",sheet=1)
summerdf <- subset(df, Year %in% c(2000,2004,2008,2012))

#convert some columns to factor
summerdf$Country <- as.factor(summerdf$Country)

#aggregate data by medals
aggdataGOLD <-aggregate(Gold.Medals ~ Country + Year + Sport, summerdf, FUN = sum)
aggdataSILVER <-aggregate(Silver.Medals ~ Country + Year + Sport, summerdf, FUN = sum)
aggdataBRONZE <-aggregate(Bronze.Medals ~ Country + Year + Sport, summerdf, FUN = sum)
aggdataTOTAL <-aggregate(Total.Medals ~ Country + Year + Sport, summerdf, FUN = sum)

#create a data frame for all type of medals
medals <- merge(aggdataGOLD, aggdataSILVER, by = c("Country","Year","Sport"))
medals <- merge(medals, aggdataBRONZE, by = c("Country","Year","Sport"))
medals <- merge(medals, aggdataTOTAL, by = c("Country","Year","Sport"))

discipline <- sort(unique(medals$Sport))


shinyServer(
  function(input, output) {
  
	#Define and initialize reactive values
  values <- reactiveValues()
	values$discipline <- discipline
	
	#Create a checkbox for disciplines
	output$disciplineControls <- renderUI({
    checkboxGroupInput('discipline', 'Choose olympic discipline', discipline)
  })
  
  #Create a barplot, reative to input$olympic & input$discipline
  output$mytable1 <- renderDataTable({
    library(ggplot2)
    if (input$medalCategory2 == "gold") {
      medals[medals$Year==input$olympic & medals$Sport %in% input$discipline & medals$Gold.Medals != 0,c(1,2,3,4)]
    } else {
      if (input$medalCategory2 == "silver") {
        medals[medals$Year==input$olympic & medals$Sport %in% input$discipline & medals$Silver.Medals != 0,c(1,2,3,5)]
      } else {
        if (input$medalCategory2 == "bronze") {
          medals[medals$Year==input$olympic & medals$Sport %in% input$discipline & medals$Bronze.Medals != 0,c(1,2,3,6)]
        } else {
          if (input$medalCategory2 == "total") {
            medals[medals$Year==input$olympic & medals$Sport %in% input$discipline & medals$Total.Medals != 0,c(1,2,3,7)]
          }
        }      
      }
    }
  })
  
	#Create a large table, reative to input$olympic & input$discipline
	output$myplot1 <- renderPlot({
	  library(ggplot2)
    if (input$medalCategory1 == "gold") {
      medals1 <- medals[medals$Year==input$olympic & medals$Sport %in% input$discipline & medals$Gold.Medals != 0,c(1,2,3,4)]
      print(ggplot(medals1, aes(x = Country, y = Gold.Medals, fill = Sport)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = -45, hjust = 0)))
    } else {
	    if (input$medalCategory1 == "silver") {
	      medals1 <- medals[medals$Year==input$olympic & medals$Sport %in% input$discipline & medals$Silver.Medals != 0,c(1,2,3,5)]
	      print(ggplot(medals1, aes(x = Country, y = Silver.Medals, fill = Sport)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = -45, hjust = 0)))
	    } else {
        if (input$medalCategory1 == "bronze") {
          medals1 <- medals[medals$Year==input$olympic & medals$Sport %in% input$discipline & medals$Bronze.Medals != 0,c(1,2,3,6)]
          print(ggplot(medals1, aes(x = Country, y = Bronze.Medals, fill = Sport)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = -45, hjust = 0)) )
        } else {
          if (input$medalCategory1 == "total") {
            medals1 <- medals[medals$Year==input$olympic & medals$Sport %in% input$discipline & medals$Total.Medals != 0,c(1,2,3,7)]
            print(ggplot(medals1, aes(x = Country, y = Total.Medals, fill = Sport)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = -45, hjust = 0)))
          }
        }      
	    }
	  }
	})
  
  }
)



