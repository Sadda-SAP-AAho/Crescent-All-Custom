@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Group'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_ProductGroupText_2 as select from I_ProductGroupText_2
{
    key ProductGroup,
    key Language,
    ProductGroupName,
    ProductGroupText,
    /* Associations */
    _Language,
    _ProductGroup
}
