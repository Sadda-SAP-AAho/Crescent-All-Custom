@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR 2A RECO-REPORT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GSTR2ARECO_RPT
  as select distinct from ZI_GEN_LEDGER              as a

    left outer join       ZI_GSTINFODASH             as b on  a.AccountingDocument = b.Jeno
                                                          and a.FiscalYear         = b.Fisyear

    left outer join       I_JournalEntry             as c on  c.FiscalYear         = a.FiscalYear
                                                          and c.CompanyCode        = a.CompanyCode
                                                          and c.AccountingDocument = a.AccountingDocument

    left outer join       I_JournalEntryItem         as d on  d.CompanyCode        = c.CompanyCode
                                                          and d.FiscalYear         = c.FiscalYear
                                                          and d.AccountingDocument = c.AccountingDocument

    left outer join       I_SupplierInvoiceAPI01     as e on  e.SupplierInvoiceWthnFiscalYear = c.OriginalReferenceDocument
                                                          and e.IsInvoice                     = 'X'
                                                          and e.ReverseDocument               is initial
                                                          and e.FiscalYear                    = c.FiscalYear

    left outer join       I_Businesspartnertaxnumber as f on f.BusinessPartner = a.OffsettingAccount

    left outer join       I_Supplier                 as g on g.Supplier = a.OffsettingAccount

    left outer join       ZI_VEND_MAIL               as h on  h.Lifnr = a.OffsettingAccount
                                                          and h.Mail1 is not initial


{
  key ( case when b.Gstmonth is not null then 'Claimed' else 'Unclaimed' end )  as Status,
  key a.FiscalYear,
  key a.CompanyCode,
  key a.GLAccount,
  key a.GLAccountName,
  key cast( a.AccountingDocument as abap.char( 10 ) )                           as AccountingDocument,
  key a.LedgerGLLineItem,
  key a.CommInvNo,
  key a.Product,
  key a.ProductName,
      a.POItemName,
      a.Supplier,
      a.Customer,
      a.Plant,
      a.CostCenter,
      a.CostCenterName,
      a.ProfitCenter,
      a.ProfitCenterName,
      a.Segment,
      a.PostingDate,
      a.AccountingDocumentType,
      a.PostingKey,
      a.AccountAssignment,
      a.AccountAssignmentType,
      c.DocumentReferenceID                                                     as JERefNo,
      e.DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      e.InvoiceGrossAmount                                                      as APValue,
      a.Amount,
      a.CompanyCodeCurrency,
      a.TaxCode,
      a.OffsettingAccount,
      a.OffsettingAccountName,
      a.OutboundDelNo,
      a.OutboundDelQty,
      a.QtyUOM,
      a.PurchaseOrder,
      a.PRShortText,
      a.POItemText,
      a.DocumentItemText,
      a.NumberOfItems,
      a.WBSElement,
      a.WBSDesc,
      a.BaseUnit,
      @Semantics: { quantity : {unitOfMeasure: 'BaseUnit'} }
      a.Quantity,
      b.Twobrefno,
      b.Gstremarks,
      b.Newgstno,
      b.Gstmonth,
      b.Extra1,
      b.Extra2,
      f.BPTaxNumber                                                             as SupplierGSTN,
      g.PhoneNumber1                                                            as PhoneNo,
      h.Mail1                                                                   as Email,
      (case when g.PurchasingIsBlocked = 'X' then 'Yes' else 'No' end )         as PurchaseBlock,
      (case when g.PaymentIsBlockedForSupplier = 'X' then 'Yes' else 'No' end ) as PaymentBlock
}

where
  (
       a.GLAccount = '0012800200'
    or a.GLAccount = '0012800210'
    or a.GLAccount = '0012800220'
    or a.GLAccount = '0012800230'
    or a.GLAccount = '0012800240'
    or a.GLAccount = '0012800250'
    or a.GLAccount = '0012800260'
    or a.GLAccount = '0012800270'
    or a.GLAccount = '0012800280'
    or a.GLAccount = '0012800290'
    or a.GLAccount = '0012800300'
    or a.GLAccount = '0012800310'
    or a.GLAccount = '0012800340'
    or a.GLAccount = '0012800350'
    or a.GLAccount = '0012800360'
  )
