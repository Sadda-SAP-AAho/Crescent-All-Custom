@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST 2B PART MATCH-4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GST_2B_PART_MATCH_4
  as select distinct from I_JournalEntry             as a

    inner join            I_JournalEntryItem         as b  on  b.AccountingDocument       = a.AccountingDocument
                                                           and b.FiscalYear               = a.FiscalYear
                                                           and b.SourceLedger             = '0L'
                                                           and b.Ledger                   = '0L'
                                                           and a.ReverseDocument          is initial
                                                           and (
                                                              a.AccountingDocumentType    = 'KR'
                                                              or a.AccountingDocumentType = 'RE'
                                                            )
                                                           and a.CompanyCode              = '1000'

    inner join            ZI_GSTINFODASH             as b1 on  b1.Jeno    = a.AccountingDocument
                                                           and b1.Fisyear = a.FiscalYear

    inner join            ZI_GSTR2BREG_I             as c  on c.invno = b1.Twobrefno

    inner join            ZI_GSTR2BREG_H             as d  on  d.id       = c.id
                                                           and d.canceled = 'NO'
                                                           and d.fisyear  = a.FiscalYear

    inner join            I_Supplier                 as e  on  e.Supplier     = b.OffsettingAccount
                                                           and e.SupplierName = c.lglname

    inner join            I_Businesspartnertaxnumber as f  on f.BusinessPartner = b.OffsettingAccount


  //    left outer join       I_SupplierInvoiceAPI01     as h  on  h.SupplierInvoiceWthnFiscalYear = a.OriginalReferenceDocument
  //                                                           and h.IsInvoice                     = 'X'
  //                                                           and h.ReverseDocument               is initial
  //                                                           and h.FiscalYear                    = d.fisyear
  //                                                           and h.FiscalYear                    = a.FiscalYear

{
  key d.comments                                as GSTMonth,
  key c.rowno,
  key a.FiscalYear,
  key a.AccountingDocument,
      a.AccountingDocumentType,
      cast( 'Part Match-4' as abap.char( 12 ) ) as CDS,
      //      h.SupplierInvoice,
      f.BPTaxNumber,
      b.OffsettingAccount                       as Supplier,
      e.SupplierName,
      a.DocumentReferenceID                     as InvRefNo,
      'Others'                                  as Type

}
