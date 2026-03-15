# Taxonomy Hierarchy

Taxonomy Hierarchy

## Usage

``` r
taxonomy_hierarchy(
  taxonomy_code = NULL,
  taxonomy_level = NULL,
  taxonomy_title = NULL
)
```

## Arguments

- taxonomy_code:

  `<chr>` Health Care Provider Taxonomy code, a unique alphanumeric
  code, ten characters in length

- taxonomy_level:

  `<chr>` Taxonomy level; options are `"I. Section"`, `"II. Grouping"`,
  `"III. Classification"` and `"IV. Specialization"`

- taxonomy_title:

  `<chr>` Taxonomy level title

## Value

`<tibble>` of search results

## Examples

``` r
taxonomy_hierarchy(taxonomy_code = "101Y00000X")
#> # A tibble: 3 × 3
#>   taxonomy_code taxonomy_level      taxonomy_level_title                        
#>   <chr>         <ord>               <chr>                                       
#> 1 101Y00000X    I. Section          Individual                                  
#> 2 101Y00000X    II. Grouping        Behavioral Health & Social Service Providers
#> 3 101Y00000X    III. Classification Counselor                                   

taxonomy_hierarchy(taxonomy_code = "103TA0400X")
#> # A tibble: 4 × 3
#>   taxonomy_code taxonomy_level      taxonomy_level_title                        
#>   <chr>         <ord>               <chr>                                       
#> 1 103TA0400X    I. Section          Individual                                  
#> 2 103TA0400X    II. Grouping        Behavioral Health & Social Service Providers
#> 3 103TA0400X    III. Classification Psychologist                                
#> 4 103TA0400X    IV. Specialization  Addiction (Substance Use Disorder)          

taxonomy_hierarchy(taxonomy_level = "I. Section")
#> # A tibble: 874 × 3
#>    taxonomy_code taxonomy_level taxonomy_level_title
#>    <chr>         <ord>          <chr>               
#>  1 101200000X    I. Section     Individual          
#>  2 101Y00000X    I. Section     Individual          
#>  3 101YA0400X    I. Section     Individual          
#>  4 101YM0800X    I. Section     Individual          
#>  5 101YP1600X    I. Section     Individual          
#>  6 101YP2500X    I. Section     Individual          
#>  7 101YS0200X    I. Section     Individual          
#>  8 102L00000X    I. Section     Individual          
#>  9 102X00000X    I. Section     Individual          
#> 10 103G00000X    I. Section     Individual          
#> # ℹ 864 more rows

taxonomy_hierarchy(taxonomy_title = "Allopathic & Osteopathic Physicians")
#> # A tibble: 231 × 3
#>    taxonomy_code taxonomy_level taxonomy_level_title               
#>    <chr>         <ord>          <chr>                              
#>  1 202C00000X    II. Grouping   Allopathic & Osteopathic Physicians
#>  2 202D00000X    II. Grouping   Allopathic & Osteopathic Physicians
#>  3 202K00000X    II. Grouping   Allopathic & Osteopathic Physicians
#>  4 204C00000X    II. Grouping   Allopathic & Osteopathic Physicians
#>  5 204D00000X    II. Grouping   Allopathic & Osteopathic Physicians
#>  6 204E00000X    II. Grouping   Allopathic & Osteopathic Physicians
#>  7 204F00000X    II. Grouping   Allopathic & Osteopathic Physicians
#>  8 204R00000X    II. Grouping   Allopathic & Osteopathic Physicians
#>  9 207K00000X    II. Grouping   Allopathic & Osteopathic Physicians
#> 10 207KA0200X    II. Grouping   Allopathic & Osteopathic Physicians
#> # ℹ 221 more rows
```
