@AbapCatalog.sqlViewName: 'ZEXIMBANKTYPE'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Maintanence Type'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZI_BANK_TYPE as select from zexim_bank_type
{
    key banktype as Banktype
}
