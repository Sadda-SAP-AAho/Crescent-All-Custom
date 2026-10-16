@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Testing Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_TESTING_SUM as select from ZR_TESTING_FLTP_VAL
{

    key mmyyyy,
    prctrclub,
    CompanyCodeCurrency,
    sum( cast(AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as amt
}
group by mmyyyy,
prctrclub,
CompanyCodeCurrency
