@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Net Due Date'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_NETDUEDATE01 as select from ZR_NETDUEDATE
{
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
    CASHDISCOUNT1DAYS,
    max(NetDueDate) as netduedate
}
group by AccountingDocument,
    FiscalYear,
     CompanyCode,
    CASHDISCOUNT1DAYS
