FROM rocker/r-ver:4.3.1 as base1
RUN apt-get update
RUN apt-get install -y libcurl4-openssl-dev 
RUN apt-get install -y libz-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libsodium-dev

RUN R -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"
WORKDIR /project
# using approach 2 above
RUN mkdir -p renv
COPY . .

# change default location of cache to project folder
RUN mkdir renv/.cache
ENV RENV_PATHS_CACHE renv/.cache

# restore 
RUN R -e "renv::restore()"

FROM base1

CMD cd /project
CMD R -e 'plumber::pr("./backend/api.R") |>plumber::pr_run(host = "0.0.0.0", port = 8000)'

EXPOSE 8000
