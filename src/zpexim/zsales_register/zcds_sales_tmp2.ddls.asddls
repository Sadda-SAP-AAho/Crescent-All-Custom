@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'CDS for Sales Register'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZCDS_SALES_TMP2
  as select distinct from ZCDS_SALES_TMP1            as a

    left outer join       I_BillingDocumentItemBasic as b on b.ReferenceSDDocument = a.OutboundDeliveryNo
    left outer join       I_BillingDocument          as c on c.BillingDocument = b.BillingDocument

{
  key b.BillingDocument,
  key b.BillingDocumentItem,
  key c.BillingDocument     as CommercialInvNum,
      a.CompanyCode,
      a.FiscalYear,
      b.ReferenceSDDocument,
      b.ReferenceSDDocumentItem,
      b.SalesDocument,
      b.SalesDocumentItem,
      c.BillingDocumentDate as CommInvDate,
      c.CreationDate,
      c.DocumentReferenceID as CommInvRef
}

where
      b.BillingDocumentType        = 'F2'
  and c.CancelledBillingDocument   = ''

  and c.BillingDocumentIsCancelled = ''

  and c.AccountingPostingStatus    = 'C'
  or  c.AccountingPostingStatus    = 'D'
