# InteractiveWordcloud
A free open, interactive word cloud functions (linking R with Google Forms) useful for quick audience participation experiences.

InteractiveWordcloud is a small R package that delivers a free open, interactive word cloud (links R with Google Forms) useful for quick audience participation experiences.

It defines the functions `generate_wordcloud()` and `interactive_wordcloud()`; these are wrappers around downloading the data using `googledrive::drive_download()`, processing using the `tm` package, and plotting a wordcloud using `wordcloud2::wordcloud()`.

Participants can input words into a Google form with a long-answer question. When they submit their answer it gets entered into the linked Google sheet. Note, this must be set up prior in an Google Drive you have access to.

Then, this script automates download of the Google sheet, cleans and prepares the data, and plots to a wordcloud. This can be run iteratively to provide an interactive audience participation experience.

For this example I pretend it is linked to a Google Form (i.e. a survey) which has the name "Interactive wordcloud", contains one long-answer question ("What is your favourite colour?"), and is actively linked to the Google Sheet "Interactive wordcloud (Responses)". Users are referred to Google Docs for setting this up.

To run this script, you will need to:

* Have access to a Google Drive
* The Google Drive must contain a survey as a Google Form, where the responses are actively linked to a google sheet (or, for a less interactive experience, just the google sheet is required to generate a single wordcloud
* I recommend to initiate the sheet with a response that includes your key words (in my example, I might set it up with the response: "blue blue red")
* You will need to allow the Tidyverse API to access your Google Drive account, using the automatic popup initially, and then when prompted. This will occur on the call to "drive_find()" - so set this up first, before applying the function.
* You will need to change the pattern, .file_name, .file_path, .column_name to match your Google Documents and survey question.

# Installing
Hosted on github, this package can be installed by:
```{r installing, echo = TRUE, eval = FALSE}
devtools::install_github("lizlaw", "InteractiveWordcloud")
```

# Setup 
Load libraries
```{r setup, echo = TRUE, eval = FALSE}
library(InteractiveWordcloud)
library(googledrive)  
```

Initiate link with googledrive. 
If this is the first time you use googledrive, this call will open a popup window asking you to give access to your Google Drive. Else you will need to select the drive you wish to connect with, as prompted.
This call will show you a list of the files in your google drive, for which the name contains "Interactive wordcloud".
```{r setup link to googledrive, echo = TRUE, eval = FALSE}
googledrive::drive_find(pattern = "Interactive wordcloud")
```

Now we are connected, we can generate a single wordcloud. This can be used, for example, to test or after all entries from the audience have been submitted.
```{r generate wordcloud, echo = TRUE, eval = FALSE}
generate_wordcloud(.file_name = "Interactive wordcloud (Responses)",
                   .file_path = "temp_wordcloud_responses.csv",
                   .column_name = "What is your favourite colour?")
```

Or, if your audience is currently submitting the entries, it can be fun to see the word cloud change over time, so we can iterate this function (here for 1 minute, updating every 5 seconds)

```{r interactive_wordcloud, echo = TRUE, eval = FALSE}
interactive_wordcloud(.minutes = 1, 
                  .freqsec = 5, 
                  .file_name = "Interactive wordcloud (Responses)",
                  .file_path = "temp_wordcloud_responses.csv",
                  .column_name = "What is your favourite colour?")
```

# What does the generate_wordcloud function do, and what options do I have? 

First, the function downloads the google sheet from your google drive. This uses the package `googledrive`.

Second, it uses the package `tm` (a text mining package) to prepare and format the data (coming in as a .csv file of responses) into a word frequency table. Specifically, in cleaning the data, we 1) convert all to lowercase, 2) remove numbers, 3) remove punctuation, 4) remove 'stopwords' (i.e. commonly used words that we should ignore, such as “the”, “a”, etc.), and 5) remove excess whitespace. I've only allowed easy access to change the stopword options (see function helpfile). Feel free to copy and modify the function if you want other options! 

Third, it plots the frequency table as a wordcloud, using the package `wordcloud2`. Users are refered to this package for plotting options, which can be passed into `generate_wordcloud()`.

Wishing you a fun, interactive time! 

# Troubleshooting

The 'pattern' call in `googledrive::drive_find()` cannot recognise brackets, so will output an empty tibble if you try and use `pattern = "* (Responses)"`. However, the download does recognise this name and will get the correct file. 

If the file is not in the right format it may still output an error, for example if there are missing entries, etc. such as when the google sheet has been edited directly. If this happens, you may need to re-create the linked google sheet. Refer to the Google Document documentation for more information on how these files are linked and how they update.

If words do not appear in the viewer window, it is possible they can't fit, include: `size = 0.5` (or something between 0 < 1)
You can also check the frequency output by changing call to: `.return = "data"`
