@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Custom CDS for I_PRODUCTDESCRIPTION'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_PRODUCTDESCRIPTION as select from I_ProductDescription
{
    key Product,
    key Language,
    ProductDescription,
    LanguageISOCode,
    /* Associations */
    _Language,
    _Product
}
