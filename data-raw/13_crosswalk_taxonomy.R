source(here::here("data-raw", "pins_internal.R"))

cross_tax <- arktax::get_pin("cross_raw") |>
  dplyr::select(
    taxonomy_code,
    taxonomy_description,
    specialty_code,
    specialty_description
    )

pin_update(
  cross_tax,
  "cross_tax",
  "Medicare Taxonomy Crosswalk Taxonomy Codes 2024",
  "Medicare Provider and Supplier Taxonomy Crosswalk Taxonomy Codes 2024"
)


cross_tax |>
  tidyr::separate_longer_delim(
    cols = taxonomy_description,
    delim = stringr::regex("[\\/|,]")) |>
  dplyr::mutate(
    taxonomy_description = dplyr::if_else(
      codex::sf_detect(taxonomy_description, "Urban Indian Health \\(I"),
      "Urban Indian Health [ITU] Pharmacy",
      stringr::str_squish(taxonomy_description))) |>
  dplyr::filter(codex::sf_ndetect(taxonomy_description, "^T$|U\\)\\sPharmacy")) |>
  dplyr::mutate(.group = dplyr::row_number(),
                .by = c(taxonomy_code),
                .after = 1)

cross_tax |>
  dplyr::count(taxonomy_description, sort = TRUE)

arktax::taxonomy_hierarchy() |>
  dplyr::filter(!description %in% c("Individual", "Non-Individual")) |>
  dplyr::count(description, sort = TRUE)



cross_tax |>
  tidyr::pivot_wider(
    names_from = .group,
    values_from = taxonomy_description,
    names_prefix = "tax")

cross_tax |>
  hacksaw::count_split(
    tax1,
    tax2,
    tax3,
    tax4,
    tax5,
    tax6
  )
