# STAGE 1: renv-related code
FROM rocker/r-ver:latest AS base

RUN apt update -qq \
&& apt install -y pkg-config libpq5 libpq-dev unixodbc-dev libcurl4-openssl-dev libz-dev libssl-dev libsodium-dev \
r-cran-rpostgresql \
r-cran-plumber
RUN apt -f install

RUN R -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"
WORKDIR /project
# using approach 2 above
RUN mkdir -p renv
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R

# change default location of cache to project folder
RUN mkdir renv/.cache
ENV RENV_PATHS_CACHE renv/.cache

# restore 
RUN R -e "renv::restore()"
FROM rocker/r-ver:latest

WORKDIR /project
COPY --from=base /project .
#COPY .Renviron .Renviron
COPY backend/ ./backend
COPY frontend/ ./frontend
COPY db_setup/ ./db_setup
COPY renv.lock renv.lock

RUN apt-get update
RUN apt install -y pkg-config 
RUN apt install -y libpq5 
RUN apt install -y libpq-dev 
RUN apt install -y libsodium-dev

ENV LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}"

CMD R -e 'library(dbplyr);library(dplyr);library(plumber);lapply(system("ls /project/backend/functions/*.R", intern = TRUE), source); pr("/project/backend/api.R") |> pr_run(host = "0.0.0.0", port = 8000)'

EXPOSE 8000
