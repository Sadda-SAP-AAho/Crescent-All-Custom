@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO No our Reference'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PONOOURREF
  as select from    I_PurchaseOrderAPI01      as a

    inner join      I_BillingDocument         as b on b.BillingDocument = a.CorrespncInternalReference

    inner join      I_OperationalAcctgDocItem as c on c.PurchasingDocument = a.PurchaseOrder

    left outer join ZV_COSTINGPL_32           as d on  b.BillingDocument = d.AssignmentReference
                                                   and c.GLAccount       = d.GLAccount

{

  key    c.CompanyCode,
  key    c.AccountingDocument,
  key    c.FiscalYear,
  key    c.AccountingDocumentItem,
  key    b.BillingDocument     as AssignmentReference,
         '3'                   as zCase,
         c.AccountingDocumentItemType,
         c.GLAccount,
         ( case when ( b.BillingDocument = d.AssignmentReference and c.GLAccount = d.GLAccount )
                then 'X'
                else 'Y' end ) as Status,
         a.PurchaseOrder       as PurchasingDocument,
         c.CompanyCodeCurrency,
         @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
         c.AmountInCompanyCodeCurrency

}
