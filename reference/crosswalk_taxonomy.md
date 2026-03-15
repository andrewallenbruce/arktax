# Taxonomy - Medicare Specialty Crosswalk

Taxonomy - Medicare Specialty Crosswalk

## Usage

``` r
crosswalk_taxonomy(taxonomy_code = NULL, specialty_code = NULL)
```

## Arguments

- taxonomy_code:

  `<chr>` Health Care Provider Taxonomy code, a unique alphanumeric
  code, ten characters in length

- specialty_code:

  `<chr>` Medicare Specialty Code, an alphanumeric code, two characters
  in length

## Value

`<tibble>` of search results

## Examples

``` r
crosswalk_taxonomy(taxonomy_code = "103T00000X")
#> # A tibble: 1 × 4
#>   taxonomy_code taxonomy_description        specialty_code specialty_description
#>   <chr>         <chr>                       <chr>          <chr>                
#> 1 103T00000X    Behavioral Health & Social… 62             Psychologist, Clinic…

crosswalk_taxonomy(taxonomy_code = c("101YM0800X", "101YP2500X"))
#> # A tibble: 2 × 4
#>   taxonomy_code taxonomy_description specialty_code specialty_description       
#>   <chr>         <chr>                <chr>          <chr>                       
#> 1 101YM0800X    NA                   E2             Mental Health Counselor     
#> 2 101YP2500X    NA                   E2             Licensed Professional Couns…
```
