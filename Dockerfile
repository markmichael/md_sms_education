# STAGE 1: renv-related code
FROM rocker/r-base:latest AS base

RUN apt-get update
RUN apt-get install -y libcurl4-openssl-dev 
RUN apt-get install -y libz-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libsodium-dev

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

FROM rocker/r-base:latest

WORKDIR /project
COPY --from=base /project .

CMD R -e 'lapply(system("ls ./backend/functions/*.R", intern = TRUE), source); plumber::pr("./backend/api.R") |>plumber::pr_run(host = "0.0.0.0", port = 8000)'

EXPOSE 8000
