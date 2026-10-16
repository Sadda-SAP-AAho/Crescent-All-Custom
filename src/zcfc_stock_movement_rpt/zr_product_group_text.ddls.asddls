@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity for Product Group'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PRODUCT_GROUP_TEXT
  as select from I_ProductGroupText_2
{
  key ProductGroup,
      @Semantics.text: true
      ProductGroupText
}

where
  Language = $session.system_language
