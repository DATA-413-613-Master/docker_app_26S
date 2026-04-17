# Use the rocker/shinyverse container with the Ubuntu AMD64 architecture
FROM rocker/shiny-verse:latest

# Set working directory for the container
WORKDIR /srv/shiny-server

# Add in any other folders you need to run the code
# Copy shiny app, data, and R folders into your container as needed
COPY app.R /srv/shiny-server/
#COPY data /srv/shiny-server/data
#COPY R /srv/shiny-server/R

# Install the renv package
RUN R -e "install.packages('renv', repos = 'https://cloud.r-project.org/', verbose = TRUE)"

# Copy renv.lock (ensure it exists)
COPY renv.lock /srv/shiny-server

# Restore renv environment to install all the packages and dependencies
# into the container
RUN R -e "renv::restore()"

# Expose port for Shiny app
EXPOSE 3838

# Create the command to run the Shiny app based on where you put the app.R file.
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/', port = 3838, host = '0.0.0.0')"]
