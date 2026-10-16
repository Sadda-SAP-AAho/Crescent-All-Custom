@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_6
  as select from I_BillingDocumentItem      as a
    inner join   I_BillingDocumentItemBasic as b on  b.ReferenceSDDocument     = a.ReferenceSDDocument
                                                 and b.ReferenceSDDocumentItem = a.ReferenceSDDocumentItem
    inner join   I_BillingDocument          as c on  c.BillingDocument          =  b.BillingDocument
                                                 and c.AccountingTransferStatus <> 'E'
{
  a.BillingDocument     as arinv,
  c.BillingDocument,
  c.DocumentReferenceID as billingdocumentref
}
where
      a.ReferenceSDDocumentCategory = 'J'
  and b.BillingDocumentType         = 'F8'
group by
  a.BillingDocument,
  c.BillingDocument,
  c.DocumentReferenceID
