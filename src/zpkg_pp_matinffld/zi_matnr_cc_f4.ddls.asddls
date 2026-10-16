@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Cast Code'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MATNR_CC_F4 
as select from I_Product as a
inner join I_ProductDescription as b on b.Product = a.Product and b.Language = 'E'
{
    key a.Product,
    key b.ProductDescription
}
where a.ProductGroup = 'Z025'
