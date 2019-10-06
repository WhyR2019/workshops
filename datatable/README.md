# data.table introduction & time-series

Authors: [Jan Gorecki](https://github.com/jangorecki), [H2O.ai](https://www.h2o.ai)

### Description

Workshop will be divided in two parts.

- First part will introduce participants to `data.table` query concept, an extension of `data.frame` query expressions. We will cover features useful in most common data processing workflows focusing on how base R concepts translates to `data.table`.

- Second part will be focused on a particular use case of working with time-series data. Full processing workflow will be presented as well as multiple features useful when working with ordered observations datasets.

Participants are kindly requested to prepare their workstations for the workshop by running below code to ensure recent `data.table` version is installed. `curl` package will be used to access online data.
```r
install.packages(c("curl","data.table"))
```

### Materials

[jangorecki/r-talks-whyr2019](https://gitlab.com/jangorecki/r-talks-whyr2019) repo includes:

- `intro.R` - introduction to `data.table`, workshop part 1
- `ts.R` - time-series data, workshop part 2
