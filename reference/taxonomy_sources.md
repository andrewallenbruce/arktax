# Taxonomy Sources

Taxonomy Sources

## Usage

``` r
taxonomy_sources(taxonomy_code = NULL)
```

## Arguments

- taxonomy_code:

  `<chr>` Health Care Provider Taxonomy code, a unique alphanumeric
  code, ten characters in length

## Value

`<tibble>` of search results

## Examples

``` r
taxonomy_sources(taxonomy_code = "101Y00000X")
#> # A tibble: 1 × 3
#>   code       source  text                                                       
#>   <chr>      <ord>   <chr>                                                      
#> 1 101Y00000X primary Abridged from definitions provided by the National Board o…

taxonomy_sources(taxonomy_code = "103TA0400X")
#> # A tibble: 2 × 3
#>   code       source     text                                           
#>   <chr>      <ord>      <chr>                                          
#> 1 103TA0400X primary    American Psychological Association, www.apa.org
#> 2 103TA0400X additional The APA proficiency is Addiction Psychology.   
```
