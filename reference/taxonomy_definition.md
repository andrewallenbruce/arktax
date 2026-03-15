# Taxonomy Definitions

Taxonomy Definitions

## Usage

``` r
taxonomy_definition(taxonomy_code = NULL)
```

## Arguments

- taxonomy_code:

  `<chr>` Health Care Provider Taxonomy code, a unique alphanumeric
  code, ten characters in length

## Value

`<tibble>` of search results

## Examples

``` r
taxonomy_definition(taxonomy_code = "101Y00000X")
#> # A tibble: 1 × 2
#>   taxonomy_code taxonomy_definition                                             
#>   <chr>         <chr>                                                           
#> 1 101Y00000X    A provider who is trained and educated in the performance of be…

taxonomy_definition(taxonomy_code = "103TA0400X")
#> # A tibble: 1 × 2
#>   taxonomy_code taxonomy_definition                                             
#>   <chr>         <chr>                                                           
#> 1 103TA0400X    A psychologist with a proficiency that involves the application…
```
