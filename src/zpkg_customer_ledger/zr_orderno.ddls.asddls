@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order No'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_ORDERNO as select distinct from I_OperationalAcctgDocItem as a
inner join C_BillgDocItmPrcgElmntBscDEX_1 as b on b.BillingDocument = a.OriginalReferenceDocument
{
    key $session.client as clnt,
    key a.AccountingDocument,
    key a.FiscalYear,
    key a.CompanyCode,
    b.SalesDocument as BillingDocument
}
