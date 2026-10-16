@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_COSTPLFI

  //FI Part
  as select from I_OperationalAcctgDocItem as a

   inner join   I_BillingDocument         as b on b.BillingDocument = a.AssignmentReference

{
  key    a.CompanyCode,
  key    a.AccountingDocument,
  key    a.FiscalYear,
  key    a.AccountingDocumentItem,
  key    a.AssignmentReference,
         '1' as zCase,
         a.AccountingDocumentItemType,
         a.GLAccount,
         a.PurchasingDocument,
         a.CompanyCodeCurrency,
         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         a.AmountInCompanyCodeCurrency

}

where
  ( a.AssignmentReference is not initial and a.PurchasingDocument is initial )

//SES Part
union select from ZV_COSTINGPL_32 as a

{
  key    a.CompanyCode,
  key    a.AccountingDocument,
  key    a.FiscalYear,
  key    a.AccountingDocumentItem,
  key    a.AssignmentReference,
         '2'             as zCase,
         a.AccountingDocumentItemType,
         a.GLAccount,
         a.PurchaseOrder as PurchasingDocument,
         a.CompanyCodeCurrency,
         a.AmountInCompanyCodeCurrency

}

//PO Number Our Reference
union select from I_PurchaseOrderAPI01      as a

  inner join      I_BillingDocument         as b on b.BillingDocument = a.CorrespncInternalReference

  inner join      I_OperationalAcctgDocItem as c on c.PurchasingDocument = a.PurchaseOrder

{

  key    c.CompanyCode,
  key    c.AccountingDocument,
  key    c.FiscalYear,
  key    c.AccountingDocumentItem,
  key    b.BillingDocument as AssignmentReference,
         '3'               as zCase,
         c.AccountingDocumentItemType,
         c.GLAccount,
         a.PurchaseOrder   as PurchasingDocument,
         c.CompanyCodeCurrency,
         c.AmountInCompanyCodeCurrency

}

//where a.Status = 'Y'

//PO Number of Service direct from MIRO
union select from I_OperationalAcctgDocItem as c

  inner join      ZV_COSTINGPL_36           as a on  c.PurchasingDocument            = a.PurchaseOrder
                                                 and c.PurchasingDocumentItem        = a.PurchaseOrderItem
  // and c.OriginalReferenceDocument     = a.OriginalReference
                                                 and c.Reference3IDByBusinessPartner = a.Reference3

{

  key     c.CompanyCode,
  key     c.AccountingDocument,
  key     c.FiscalYear,
  key     c.AccountingDocumentItem,
  key     a.ServiceEntrySheetName as AssignmentReference,
          '4'                     as zCase,
          c.AccountingDocumentItemType,
          c.GLAccount,
          a.PurchaseOrder         as PurchasingDocument,
          c.CompanyCodeCurrency,
          c.AmountInCompanyCodeCurrency

}
where
  c.AccountingDocumentType = 'RE'
  
