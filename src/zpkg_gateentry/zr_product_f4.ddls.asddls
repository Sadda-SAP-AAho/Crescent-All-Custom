@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PRODUCT_F4
  as select from I_Product              as a
    inner join   I_ProductDescription_2 as b on(
      a.Product      = b.Product
      and b.Language = $session.system_language
    )
{
  key a.Product,
      b.ProductDescription
}
