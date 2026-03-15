# Taxonomy Display Names

Taxonomy Display Names

## Usage

``` r
taxonomy_display(taxonomy_code = NULL)
```

## Arguments

- taxonomy_code:

  `<chr>` Health Care Provider Taxonomy code, a unique alphanumeric
  code, ten characters in length

## Value

`<tibble>` of search results

## Examples

``` r
taxonomy_display(taxonomy_code = "101Y00000X")
#> # A tibble: 1 × 2
#>   taxonomy_code taxonomy_display
#>   <chr>         <chr>           
#> 1 101Y00000X    Counselor       

taxonomy_display(taxonomy_code = "103TA0400X")
#> # A tibble: 1 × 2
#>   taxonomy_code taxonomy_display                               
#>   <chr>         <chr>                                          
#> 1 103TA0400X    Addiction (Substance Use Disorder) Psychologist
```
