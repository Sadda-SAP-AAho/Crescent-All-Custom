@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL Code - Finance'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_FINGLCODE_1 
as select from ZV_FINGLCODE
{
    key BillingDocument,
    key BillingDocumentItem,
    key FiscalYear,
    key SalesDocument,
    key SalesDocumentItem,
    key CompanyCode,
    GLAccount,
    GLAccountName
}
where GLAccount is not initial
