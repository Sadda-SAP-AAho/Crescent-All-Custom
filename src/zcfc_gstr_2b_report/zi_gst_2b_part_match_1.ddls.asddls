@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST 2B PART MATCH-1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GST_2B_PART_MATCH_1
  as select distinct from I_JournalEntry             as a

    inner join            I_JournalEntryItem         as b on  b.AccountingDocument       = a.AccountingDocument
                                                          and b.FiscalYear               = a.FiscalYear
                                                          and b.SourceLedger             = '0L'
                                                          and b.Ledger                   = '0L'
                                                          and a.ReverseDocument          is initial
                                                          and (
                                                             a.AccountingDocumentType    = 'KR'
                                                             or a.AccountingDocumentType = 'RE'
                                                           )
                                                          and a.CompanyCode              = '1000'

    inner join            ZI_GSTR2BREG_I             as c on c.invno = a.DocumentReferenceID

    inner join            ZI_GSTR2BREG_H             as d on  d.id       = c.id
                                                          and d.canceled = 'NO'
                                                          and d.fisyear  = a.FiscalYear

    inner join            I_Supplier                 as e on e.Supplier = b.OffsettingAccount

    inner join            I_Businesspartnertaxnumber as f on  f.BusinessPartner = b.OffsettingAccount
                                                          and f.BPTaxNumber     = c.suppgstn


  //    left outer join       I_SupplierInvoiceAPI01     as g on  g.SupplierInvoiceWthnFiscalYear = a.OriginalReferenceDocument
  //                                                          and g.IsInvoice                     = 'X'
  //                                                          and g.ReverseDocument               is initial
  //                                                          and g.FiscalYear                    = d.fisyear
  //                                                          and g.FiscalYear                    = a.FiscalYear

{
  key d.comments                                as GSTMonth,
  key c.rowno,
  key a.FiscalYear,
  key a.AccountingDocument,
      a.AccountingDocumentType,
      cast( 'Part Match-1' as abap.char( 12 ) ) as CDS,
      //      g.SupplierInvoice,
      f.BPTaxNumber,
      b.OffsettingAccount                       as Supplier,
      e.SupplierName,
      a.DocumentReferenceID                     as InvRefNo,
      'Others'                                  as Type

}
