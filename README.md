# Corona Charts

Yet another site displaying data for the spread of Sars Covid 2.

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

You have to create a submodule in the top-level directory:

```bash
$ git submodule add https://github.com/CSSEGISandData/COVID-19.git
```

This submodule contains the numbers from the Johns Hopkins University.

Note that as of March 24th 2020 the number of recovered persons is no longer
counted.

### Qgoda

The HTML files are generated using the static site generate
[Qgoda](http://www.qgoda.net/).  If you don't want to install it on your
machine, 
