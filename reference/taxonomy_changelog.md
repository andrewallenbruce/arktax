# Taxonomy Change Log

Taxonomy Change Log

## Usage

``` r
taxonomy_changelog(taxonomy_code = NULL)
```

## Arguments

- taxonomy_code:

  `<chr>` Health Care Provider Taxonomy code, a unique alphanumeric
  code, ten characters in length

## Value

`<tibble>` of search results

## Examples

``` r
taxonomy_changelog(taxonomy_code = "103GC0700X")
#> # A tibble: 1 × 4
#>   code       date       change      details       
#>   <chr>      <date>     <ord>       <chr>         
#> 1 103GC0700X 2007-01-01 deactivated use 103G00000X

taxonomy_changelog(taxonomy_code = "103G00000X")
#> # A tibble: 2 × 4
#>   code       date       change   details   
#>   <chr>      <date>     <ord>    <chr>     
#> 1 103G00000X 2007-01-01 modified title     
#> 2 103G00000X 2019-01-01 modified definition
```
