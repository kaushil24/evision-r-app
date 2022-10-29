Installation steps (pasted from what I sent to SFHS students from when I put this initially put this app together)

1. Download Python and Anaconda (if you haven’t already, link to Anaconda is here)
 

2. Run pip install -r requirements.txt in a Terminal/Command Window to install the necessary dependencies that the Python scripts use
You will need to run this in the directory of the folder that I send because that is where the requirements.txt
This step may be optional, but do it just in case.  This will also allow you to run the Python scripts independently of the interface if you want to test them for yourself.
 

3. Download chromedriver (link to their website is here)
- When downloading, check to see your version of Google Chrome by opening Chrome and pressing on the three vertical dots in the upper right corner of the window and going to Help -> About Chrome.  This will redirect you to a page that will display your Google Chrome version.  Either update to the newest version, or find the chromedriver version that will work.
 

4. Go to line 148 of the case_scraper.py file and change the PATH variable to the path that you put your chromedriver on.
 

5. Open the eVisionApp.R file in RStudio and change the following lines:
- Line 142 should be edited to have the path to the directory that you are running the eVisionApp.R file in [setwd(“your directory”)].  Most of you told me last meeting that you were able to not have any trouble with this, but if you do let me know.
- Line 248 should be changed to reflect the path to your virtual environment.  This can be found by typing “python” into your Terminal/Command Prompt and typing in the following code:
 

import sys

for path in sys.path: print(path)

# press enter

 

Use one of the outputs printed and paste it as a string into the use_virtualenv(“PATH”)

 

Run the file “setup.R” which will install the R dependencies for you.  If you get a popup when running the install.packages() lines that says you already have the dependency, you can press cancel.
This is the one step I’m a little unsure about so let me know if it doesn’t work
 

Go to the eVisionApp.R, press “Run App” button in the top right corner, and make some predictions
There’s a glitch where the app screen goes black without an error message in the command prompt.  If this happens, close the window and try running the app again. 
