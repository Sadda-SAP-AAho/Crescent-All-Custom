@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business Place'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_BUSINESS_PLACE01 as select distinct from ZR_BUSINESS_PLACE
{
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
    max(BusinessPlace) as businessplace
}
group by AccountingDocument,
FiscalYear,
CompanyCode
