# Raw Crosswalk File

Raw Crosswalk File

## Usage

``` r
crosswalk_raw(taxonomy_code = NULL)
```

## Arguments

- taxonomy_code:

  `<chr>` Health Care Provider Taxonomy code, a unique alphanumeric
  code, ten characters in length

## Value

`<tibble>` of search results

## Examples

``` r
crosswalk_raw(taxonomy_code = "103T00000X")
#> # A tibble: 1 × 6
#>   taxonomy_code taxonomy_description        specialty_code specialty_description
#>   <chr>         <chr>                       <chr>          <chr>                
#> 1 103T00000X    Behavioral Health & Social… 62             Psychologist, Clinic…
#> # ℹ 2 more variables: footnote <chr>, footnote_description <chr>

head(crosswalk_raw(), 10)
#> # A tibble: 10 × 6
#>    taxonomy_code taxonomy_description       specialty_code specialty_description
#>    <chr>         <chr>                      <chr>          <chr>                
#>  1 101YM0800X    NA                         E2             Mental Health Counse…
#>  2 101YP2500X    NA                         E2             Licensed Professiona…
#>  3 103T00000X    Behavioral Health & Socia… 62             Psychologist, Clinic…
#>  4 103TA0400X    Behavioral Health & Socia… 62             Psychologist, Clinic…
#>  5 103TA0700X    Behavioral Health & Socia… 62             Psychologist, Clinic…
#>  6 103TB0200X    Behavioral Health & Socia… 62             Psychologist, Clinic…
#>  7 103TC0700X    Behavioral Health & Socia… 62             Psychologist, Clinic…
#>  8 103TC0700X    Behavioral Health & Socia… 68             Psychologist, Clinic…
#>  9 103TC1900X    Behavioral Health & Socia… 62             Psychologist, Clinic…
#> 10 103TC2200X    Behavioral Health & Socia… 62             Psychologist, Clinic…
#> # ℹ 2 more variables: footnote <chr>, footnote_description <chr>
```
