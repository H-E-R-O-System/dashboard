# RStudio Setup

## Download and install R and RStudio

## Associate with Git account

From the top bar, select Tools -\> Global Options Select Git/SVM

If you have an existing SSH Key associated, this should show here. If not follow the next steps.

Click Create SSH Key. Add an optional pass phrase (password) Note the path of the file for storing the SSH Key (should look like /Users/benhoskings/.ssh/id_ed25519.pub )

Click Create

Navigate to SSH Key file and copy text.

Now go to GitHub. Click on your account icon on the left and select settings On the left is SSH and GPG Keys. Click New SSH Key Title the key Rstudio and paste the key into the text area. click add SSH Key

Now in RStudio create new project -\> version control -\> git

add [git\@github.com](mailto:git@github.com){.email}:H-E-R-O-System/dashboard.git as the link name your local directory and click create.

# Setting up virtual environment

## Creating the R environment.
In the console, run the following commands. 
```{r}
renv::init()
renv::update()
renv::snapshot()
renv::activate()
```

Now Restart R

Session -\> Restart R
