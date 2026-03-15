# Medicare Specialty Crosswalk Footnotes

Medicare Specialty Crosswalk Footnotes

## Usage

``` r
crosswalk_footnotes(taxonomy_code = NULL, specialty_code = NULL)
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
crosswalk_footnotes(taxonomy_code = "251E00000X")
#> # A tibble: 2 × 3
#>   taxonomy_code specialty_code footnote                                         
#>   <chr>         <chr>          <glue>                                           
#> 1 251E00000X    A4             (11) Medicare specialty code designation is for …
#> 2 251E00000X    A4             (11) Medicare specialty code designation is for …

crosswalk_footnotes(specialty_code = "A0")
#> # A tibble: 22 × 3
#>    taxonomy_code specialty_code footnote                                        
#>    <chr>         <chr>          <glue>                                          
#>  1 282N00000X    A0             (7) Medicare specialty code designation is for …
#>  2 282N00000X    A0             (7) Medicare specialty code designation is for …
#>  3 282NC2000X    A0             (7) Medicare specialty code designation is for …
#>  4 282E00000X    A0             (7) Medicare specialty code designation is for …
#>  5 283Q00000X    A0             (7) Medicare specialty code designation is for …
#>  6 283X00000X    A0             (7) Medicare specialty code designation is for …
#>  7 282N00000X    A0             (7) Medicare specialty code designation is for …
#>  8 273100000X    A0             (7) Medicare specialty code designation is for …
#>  9 276400000X    A0             (7) Medicare specialty code designation is for …
#> 10 281P00000X    A0             (7) Medicare specialty code designation is for …
#> # ℹ 12 more rows
```
