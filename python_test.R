library(reticulate)

use_virtualenv("/Users/georgekouretas/opt/anaconda3/lib/python3.8")

code = "US-AL"
level = "State"
  
source_python("google_scraper.py")
google_data <- scrape(list(code), list("cough", "sore throat", "flu", "tamiflu"), 'en', 'today 5-y')

source_python("google_scraper.py")
dates <- get_date("today 5-y")

source_python("case_scraper.py")
cdcwho(level)

case_data <- read.csv("ILINet.csv", skip = 1)

area = "Alabama"
out <- c()
wk <- c()
yr <- c()

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

# print(google_data)
# print(case_data)