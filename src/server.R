# load libraries and setting up virtual environment

library(shiny)
library(shinyWidgets)
library(tensorflow)
library(keras)

# reticulate::virtualenv_create("python_env", python = "python3")
# # reticulate::virtualenv_install("python_env", packages = c("pandas", "pytrends", "selenium"))
# reticulate::virtualenv_install("python_env", packages = c("pandas", "pytrends"))
# reticulate::use_virtualenv("python_env", required = TRUE)
# # install_tensorflow()

library(Metrics)
# library(reticulate)

function(input, output, session) {
  
  # iliRes <- results$iliRes
  # iliAct <- results$iliAct
  # err <- rmse(iliAct, iliRes)
  
  observeEvent(input$main, {
    if(input$level == "National") {
      choices = list("North America")
    } else {
      choices = list("United States of America")
    }
    updateSelectInput(session,
                      inputId = "location",
                      choices = choices
    )  
  })
  
  
  observeEvent(input$level, {
    if(input$level == "National") {
      choices = list("United States of America")
    } else {
      state_data <- read.csv(file = "data.csv")
      states <- state_data$Name
      choices = states
    }
    updateSelectInput(session,
                      inputId = "location",
                      choices = choices
    )  
  })
  
  observeEvent(input$test, {
    # showModal(modalDialog("Predictions unavailable at this time, website integration still in progress. Come back soon for full functionality."))
    showModal(modalDialog("Making prediction", footer=NULL))
    res <- evision_predict(input$location, as.numeric(input$weeks), input$level, input$keywords) # will pass predict ahead and other values
    iliRes <- res$iliRes
    iliAct <- res$iliAct
    err <- rmse(iliAct, iliRes)
    output$graph <- renderPlot({
    graph <- plot_data(iliRes, iliAct, err)
    })
    output$confidence <- renderText({
     error <- error_calc(iliRes, iliAct)
     confidence <- toString((1 - error) * 100)
    })
    output$parameters <- renderText({
     out <- paste("Area Predicted: ", input$main, ", Model: LSTM, Keyword(s): ", input$keywords, ", Epochs: ", input$ep, ", Case Data Source: CDC", sep="")
     parameters <- toString(out)
    })
    removeModal()
  })
  
  observeEvent(input$disease_button, {
    message = "This input is where you select the disease that you would like to make a prediction for. The only option we currently have is influenza, but more diseases can be easily added to this framework if you would like to expand the scope of these predictions."
    showModal(modalDialog(message))
  })
  
  observeEvent(input$weeks_button, {
    message = "This input allows you to dictate how many weeks ahead you would like to predict cases for. Generally, the higher amount of weeks you select, the less accurate your predictions become."
    showModal(modalDialog(message))
  })
  
  observeEvent(input$level_button, {
    message = "This input allows you to select the level of the area you would like to predict. The options in this case are national and state, since these are the two levels that the WHO and CDC are able to provide us with. There has been work done by our team to add the ability to predict for cities since we have the Google data available for it, but there is no case data out there for us to reference for predictions."
    showModal(modalDialog(message))
  })
  
  observeEvent(input$main_button, {
    message = "This input allows you to select the primary area that your desired location resides in. For example, if you want to make a prediction for a country, it will provide you with the continent that said country resides in. This allows to sort the options so the interface does not provide you with 1000+ different locations to sort through to find the one you want."
    showModal(modalDialog(message))
  })
  
  observeEvent(input$location_button, {
    message = "This input will provide all the locations within the level that was previously specified. This is where you select the area that you want to make a prediction for."
    showModal(modalDialog(message))
  })
  
  observeEvent(input$ep_button, {
    message = "This input is where you specify the number of epochs that you want to the machine learning model to use. Epochs are the number of iterations that a machine learning model goes through in its training. So, naturally, the higher you make this the more iterations it will go through, which improves the prediction. However, the higher number of iterations you do also increases the amount of time it will take the model to finish training."
    showModal(modalDialog(message))
  })
  
  observeEvent(input$keywords_button, {
    message = "This is where you type in the keywords you would like us to extract from Google Trends. Be sure to separate your keywords with commas. Also, don't use made-up words because that cause an error with the Google Trends if they have no data for it."
    showModal(modalDialog(message))
  })
  
  evision_predict <- function(area, PredictAheadBy, level, keywords) {
    
    # data preparation
    
    # setwd('~/Desktop/Jobs/eVision/R\ Project/UI') # lines 1-4 just loading sample results from MATLAB
    
    if(level == "National") {
      code <- "US"
    } else {
      code <- get_code(area)
    }
    
    terms <- as.list(strsplit(keywords, ", ")[[1]])
   
    debug(get_data) 
    data <- get_data(area, code, level, terms)
    # data_csv <- read.csv(file = 'dataMatrix.csv', header=FALSE)
    
    data <- list(data)
    data <- data[[1]]
    data <- strtoi(c(data))
    data <- matrix(data, nrow = length(data) / 5, ncol = 5)
    
    # PredictAheadBy=3 
    data[is.na(data)]<-0 
    numFeatures<-ncol(data)
    
    m_data <- mean(data[,1])
    sd_data <- sd(data[,1]) 
    data<-as.matrix(data)
    z_data <- (data - mean(data))/sd(data)
    
    # split data into test and train
    
    set.seed(123)
    N = nrow(z_data)
    n = round(N *0.75, digits = 0) 
    train = z_data[1:n, ]
    test = z_data[(n+1):N, ] 
    end<-nrow(train)
    
    XTrain<-train[1:(end-PredictAheadBy),] 
    YTrain<-train[(PredictAheadBy+1):end,1]
    
    end_test<-nrow(test) 
    XTest<-test[1:(end_test-PredictAheadBy),] 
    YTest<-test[(PredictAheadBy+1):end_test,1]
    
    # reshaping into to 3D
    
    dim(XTrain) <- c(dim(XTrain)[1], dim(XTrain)[2], 1) 
    dim(XTest) <- c(dim(XTest)[1], dim(XTest)[2], 1) 
    X_shape2 = dim(XTrain)[2]
    X_shape3 = dim(XTrain)[3]
    batch_size = 1
    
    # create model
    
    set.seed(123) 
    model<-keras_model_sequential() 
    model%>%
      layer_lstm(units = 327, batch_input_shape = c(batch_size, X_shape2, X_shape3)) %>% 
      layer_dropout(rate=0.1) %>%
      layer_dense(units = 1)
    model %>% compile(loss='mse', optimizer='adam') 
    summary(model)
    
    # fit the model
    
    # model %>% fit(XTrain, YTrain, epochs=200, batch_size=batch_size, verbose=1, shuffle=FALSE)
    model %>% fit(XTrain, YTrain, epochs=input$ep, batch_size=batch_size, verbose=1, shuffle=FALSE) # less epochs for faster runtime while testing
    
    # prediction for test data
    
    L = nrow(XTest) 
    predictions = numeric(L)
    for(i in 1:L){
      X = XTest[i,,]
      dim(X) = c(1, numFeatures, 1)
      yhat = model %>% predict(X, batch_size=batch_size) 
      Res_Y = (yhat * sd_data) + m_data
      predictions[i] <- Res_Y
    }
    
    # plotting actual and predicted
    
    Actual_Y <- (YTest * sd_data) + m_data 
    iliAct <- Actual_Y
    iliRes <- predictions
    
    results = data.frame(cbind(iliRes, iliAct))
    # err <- rmse(iliAct, iliRes)
    # 
  }
  
  get_code <- function(area) {
    state_data <- read.csv(file = "data.csv")
    state_names <- state_data$Name
    state_codes <- state_data$Code
    
    count <- 0
    
    for (state in state_names) {
      if(state == area) {
        code = state_codes[count]
        break
      } else {
        count = count + 1
      }
    }
    
  }
  
  get_data <- function(area, code, level, terms) {
    
    # reticulate::virtualenv_create("python_env", python = "python3")
    # reticulate::virtualenv_install("python_env", packages = c("pandas", "pytrends", "selenium", "webdriver-manager"))
    # reticulate::use_virtualenv("python_env", required = TRUE)
    # install_tensorflow()
    # readRenviron(".env")
    # PYTHON_ENV = Sys.get("PYTHON_ENV_DIR")
    PYTHON_ENV <- "./.python_env"

    library(reticulate)
    
    source_python("google_scraper.py")
    
    google_data <- scrape(list(code), terms, 'en', 'today 5-y')
    
    # source_python("google_scraper.py")
    # dates <- get_date("today 5-y")
    system(paste(". ", PYTHON_ENV, "/bin/activate; python3 google_scraper.py --function get_date --get_date_time 'today 5-y'", sep=""))
    dates = read.csv("dates.csv")$dates
    
    
    # source_python("case_scraper.py")
    # cdcwho(level)
    system(paste(". ", PYTHON_ENV, "/bin/activate; python3 case_scraper.py --function cdcwho --level ", level, sep=""), timeout=15)
    case_data <- read.csv("ILINet.csv", skip = 1)
    
    out <- c()
    wk <- c()
    yr <- c()
    
    if(level == "State") {
      for (i in 1:52) { 
        if(area == case_data$REGION[i]) {
          pos = i
          break
        }
      }
      
      iter = 52
      
      while(pos < nrow(case_data)) {
        if(area == case_data$REGION[pos]) {
          out <- c(out, case_data$ILITOTAL[pos])
          wk <- c(wk, case_data$WEEK[pos])
          yr <- c(yr, case_data$YEAR[pos])
          pos = pos + iter
        } else {
          pos = pos + 1
          iter = iter + 1
        }
      }
    } else {
      out <- case_data$ILITOTAL
      wk <- case_data$WEEK
      yr <- case_data$YEAR
    }
    
    start_week = strtoi(strftime(dates[1], format = "%V"))
    current_year = strtoi(strftime(dates[length(dates)], format = "%Y"))
    
    for(i in length(out):1) {
      if(yr[i] == current_year - 5) {
        cut = i - wk[i] + start_week
        break
      }
    }
    
    wk = wk[cut:length(wk)]
    out = out[cut:length(out)]
    
    data = cbind(out, google_data[[1]])
    
    return(data)
  }
  
  plot_data <- function(iliRes, iliAct, err) {
    plot(iliAct,
         main = "Influenza Prediction", xlab = "Weeks",
         ylab = "ILI Cases",
         ylim = c(0, max(max(iliRes), max(iliAct)) + err + 100),
         col="blue",
         type="l")
    lines(iliRes, col="red")
    lines(iliRes + err, col="red", lty=2)
    lines(iliRes - err, col="red", lty=2)
    legend("topleft",
           c("Actual", "Predicted", "Confidence Intervals"),
           lty = c("solid", "solid", "dashed"),
           col = c("blue", "red", "red")
    )
    
  }
  
  error_calc <- function(iliRes, iliAct) {  
    
    # calculating SMAPE
    
    mapeSum = 0
    sum2 = 0
    for (i in 1:length(iliRes)) {
      mapeSum = mapeSum + abs(iliRes[i] - iliAct[i]) 
      sum2 = sum2 + (iliRes[i] + iliAct[i])
    }
    error <- mapeSum / sum2 
    
  }
}
