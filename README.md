# Corona Charts

Yet another site displaying data for the spread of Sars Covid 2.

You can see an automatically updated live example at:

   https://corona.cantanea.com/

## State

Not yet ready but basically working.

## Motivation

I am mostly interested in the number of new cases per day and that number is
never displayed in the other visualizations I know.  But this is exactly the
curve that can be flattened, and so I want it to be displayed prominently.

Furthermore, I want to be able to browse by country.  This feature is still
missing but will be implemented soon.

## Setup

### COVID-19 Data

This module uses a submodule.  You have to initialize it.

```bash
$ git submodule init
Submodule 'COVID-19' (https://github.com/CSSEGISandData/COVID-19.git) registered for path 'COVID-19'
$ git pull --recurse-submodules=yes
Already up to date.
Cloning into '/var/www/corona.cantanea.com/COVID-19'...
Submodule path 'COVID-19': checked out '63649e417fc6750faaec10a8a3826644aefc9fb6'
```

This submodule contains the numbers from the Johns Hopkins University.

### Qgoda

The HTML files are generated using the static site generate
[Qgoda](http://www.qgoda.net/).  If you don't want to install it on your
machine, 
