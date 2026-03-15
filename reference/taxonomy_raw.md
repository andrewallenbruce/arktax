# Raw Taxonomy File

Raw Taxonomy File

## Usage

``` r
taxonomy_raw(year = NULL, version = NULL, taxonomy_code = NULL)
```

## Arguments

- year:

  `<int>` year of source file release; options are `2009:2024`

- version:

  `<int>` version of source file; options are `0` or `1`

- taxonomy_code:

  `<chr>` Health Care Provider Taxonomy code, a unique alphanumeric
  code, ten characters in length

## Value

`<tibble>` of search results

## Examples

``` r
taxonomy_raw(taxonomy_code = "207ZB0001X")
#> # A tibble: 32 × 13
#>     year version code       display_name section grouping         classification
#>    <dbl>   <int> <chr>      <chr>        <chr>   <chr>            <chr>         
#>  1  2009       0 207ZB0001X NA           NA      Allopathic & Os… Pathology     
#>  2  2009       1 207ZB0001X NA           NA      Allopathic & Os… Pathology     
#>  3  2010       0 207ZB0001X NA           NA      Allopathic & Os… Pathology     
#>  4  2010       1 207ZB0001X NA           NA      Allopathic & Os… Pathology     
#>  5  2011       0 207ZB0001X NA           NA      Allopathic & Os… Pathology     
#>  6  2011       1 207ZB0001X NA           NA      Allopathic & Os… Pathology     
#>  7  2012       0 207ZB0001X NA           NA      Allopathic & Os… Pathology     
#>  8  2012       1 207ZB0001X NA           NA      Allopathic & Os… Pathology     
#>  9  2013       0 207ZB0001X NA           NA      Allopathic & Os… Pathology     
#> 10  2013       1 207ZB0001X NA           NA      Allopathic & Os… Pathology     
#> # ℹ 22 more rows
#> # ℹ 6 more variables: specialization <chr>, definition <chr>, notes <chr>,
#> #   modified <date>, effective <date>, deactivated <date>

taxonomy_raw(year = 2024, taxonomy_code = "101Y00000X")
#> # A tibble: 2 × 13
#>    year version code       display_name section    grouping       classification
#>   <dbl>   <int> <chr>      <chr>        <chr>      <chr>          <chr>         
#> 1  2024       0 101Y00000X Counselor    Individual Behavioral He… Counselor     
#> 2  2024       1 101Y00000X Counselor    Individual Behavioral He… Counselor     
#> # ℹ 6 more variables: specialization <chr>, definition <chr>, notes <chr>,
#> #   modified <date>, effective <date>, deactivated <date>

taxonomy_raw(taxonomy_code = "101Y00000X")
#> # A tibble: 32 × 13
#>     year version code       display_name section grouping         classification
#>    <dbl>   <int> <chr>      <chr>        <chr>   <chr>            <chr>         
#>  1  2009       0 101Y00000X NA           NA      Behavioral Heal… Counselor     
#>  2  2009       1 101Y00000X NA           NA      Behavioral Heal… Counselor     
#>  3  2010       0 101Y00000X NA           NA      Behavioral Heal… Counselor     
#>  4  2010       1 101Y00000X NA           NA      Behavioral Heal… Counselor     
#>  5  2011       0 101Y00000X NA           NA      Behavioral Heal… Counselor     
#>  6  2011       1 101Y00000X NA           NA      Behavioral Heal… Counselor     
#>  7  2012       0 101Y00000X NA           NA      Behavioral Heal… Counselor     
#>  8  2012       1 101Y00000X NA           NA      Behavioral Heal… Counselor     
#>  9  2013       0 101Y00000X NA           NA      Behavioral Heal… Counselor     
#> 10  2013       1 101Y00000X NA           NA      Behavioral Heal… Counselor     
#> # ℹ 22 more rows
#> # ℹ 6 more variables: specialization <chr>, definition <chr>, notes <chr>,
#> #   modified <date>, effective <date>, deactivated <date>

taxonomy_raw(taxonomy_code = c("101YM0800X", "101YP2500X")) |> print(n = 100)
#> # A tibble: 64 × 13
#>     year version code       display_name         section grouping classification
#>    <dbl>   <int> <chr>      <chr>                <chr>   <chr>    <chr>         
#>  1  2009       0 101YM0800X NA                   NA      Behavio… Counselor     
#>  2  2009       1 101YM0800X NA                   NA      Behavio… Counselor     
#>  3  2010       0 101YM0800X NA                   NA      Behavio… Counselor     
#>  4  2010       1 101YM0800X NA                   NA      Behavio… Counselor     
#>  5  2011       0 101YM0800X NA                   NA      Behavio… Counselor     
#>  6  2011       1 101YM0800X NA                   NA      Behavio… Counselor     
#>  7  2012       0 101YM0800X NA                   NA      Behavio… Counselor     
#>  8  2012       1 101YM0800X NA                   NA      Behavio… Counselor     
#>  9  2013       0 101YM0800X NA                   NA      Behavio… Counselor     
#> 10  2013       1 101YM0800X NA                   NA      Behavio… Counselor     
#> 11  2014       0 101YM0800X NA                   NA      Behavio… Counselor     
#> 12  2014       1 101YM0800X NA                   NA      Behavio… Counselor     
#> 13  2015       0 101YM0800X NA                   NA      Behavio… Counselor     
#> 14  2015       1 101YM0800X NA                   NA      Behavio… Counselor     
#> 15  2009       0 101YP2500X NA                   NA      Behavio… Counselor     
#> 16  2009       1 101YP2500X NA                   NA      Behavio… Counselor     
#> 17  2010       0 101YP2500X NA                   NA      Behavio… Counselor     
#> 18  2010       1 101YP2500X NA                   NA      Behavio… Counselor     
#> 19  2011       0 101YP2500X NA                   NA      Behavio… Counselor     
#> 20  2011       1 101YP2500X NA                   NA      Behavio… Counselor     
#> 21  2012       0 101YP2500X NA                   NA      Behavio… Counselor     
#> 22  2012       1 101YP2500X NA                   NA      Behavio… Counselor     
#> 23  2013       0 101YP2500X NA                   NA      Behavio… Counselor     
#> 24  2013       1 101YP2500X NA                   NA      Behavio… Counselor     
#> 25  2014       0 101YP2500X NA                   NA      Behavio… Counselor     
#> 26  2014       1 101YP2500X NA                   NA      Behavio… Counselor     
#> 27  2015       0 101YP2500X NA                   NA      Behavio… Counselor     
#> 28  2015       1 101YP2500X NA                   NA      Behavio… Counselor     
#> 29  2016       0 101YM0800X NA                   NA      Behavio… Counselor     
#> 30  2016       1 101YM0800X NA                   NA      Behavio… Counselor     
#> 31  2017       0 101YM0800X NA                   NA      Behavio… Counselor     
#> 32  2017       1 101YM0800X NA                   NA      Behavio… Counselor     
#> 33  2018       0 101YM0800X NA                   NA      Behavio… Counselor     
#> 34  2018       1 101YM0800X NA                   NA      Behavio… Counselor     
#> 35  2019       0 101YM0800X NA                   NA      Behavio… Counselor     
#> 36  2019       1 101YM0800X NA                   NA      Behavio… Counselor     
#> 37  2020       0 101YM0800X NA                   NA      Behavio… Counselor     
#> 38  2020       1 101YM0800X NA                   NA      Behavio… Counselor     
#> 39  2021       0 101YM0800X Mental Health Couns… NA      Behavio… Counselor     
#> 40  2021       1 101YM0800X Mental Health Couns… Indivi… Behavio… Counselor     
#> 41  2022       0 101YM0800X Mental Health Couns… Indivi… Behavio… Counselor     
#> 42  2022       1 101YM0800X Mental Health Couns… Indivi… Behavio… Counselor     
#> 43  2023       0 101YM0800X Mental Health Couns… Indivi… Behavio… Counselor     
#> 44  2023       1 101YM0800X Mental Health Couns… Indivi… Behavio… Counselor     
#> 45  2024       0 101YM0800X Mental Health Couns… Indivi… Behavio… Counselor     
#> 46  2024       1 101YM0800X Mental Health Couns… Indivi… Behavio… Counselor     
#> 47  2016       0 101YP2500X NA                   NA      Behavio… Counselor     
#> 48  2016       1 101YP2500X NA                   NA      Behavio… Counselor     
#> 49  2017       0 101YP2500X NA                   NA      Behavio… Counselor     
#> 50  2017       1 101YP2500X NA                   NA      Behavio… Counselor     
#> 51  2018       0 101YP2500X NA                   NA      Behavio… Counselor     
#> 52  2018       1 101YP2500X NA                   NA      Behavio… Counselor     
#> 53  2019       0 101YP2500X NA                   NA      Behavio… Counselor     
#> 54  2019       1 101YP2500X NA                   NA      Behavio… Counselor     
#> 55  2020       0 101YP2500X NA                   NA      Behavio… Counselor     
#> 56  2020       1 101YP2500X NA                   NA      Behavio… Counselor     
#> 57  2021       0 101YP2500X Professional Counse… NA      Behavio… Counselor     
#> 58  2021       1 101YP2500X Professional Counse… Indivi… Behavio… Counselor     
#> 59  2022       0 101YP2500X Professional Counse… Indivi… Behavio… Counselor     
#> 60  2022       1 101YP2500X Professional Counse… Indivi… Behavio… Counselor     
#> 61  2023       0 101YP2500X Professional Counse… Indivi… Behavio… Counselor     
#> 62  2023       1 101YP2500X Professional Counse… Indivi… Behavio… Counselor     
#> 63  2024       0 101YP2500X Professional Counse… Indivi… Behavio… Counselor     
#> 64  2024       1 101YP2500X Professional Counse… Indivi… Behavio… Counselor     
#> # ℹ 6 more variables: specialization <chr>, definition <chr>, notes <chr>,
#> #   modified <date>, effective <date>, deactivated <date>
```
