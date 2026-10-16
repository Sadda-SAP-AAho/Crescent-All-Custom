@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Copy of i_regiontext'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_regiontext as select from I_RegionText 
{
    key Country,
    key Region,
    key Language,
    RegionName,
    _Region,
    _Language,
    _Country
}
