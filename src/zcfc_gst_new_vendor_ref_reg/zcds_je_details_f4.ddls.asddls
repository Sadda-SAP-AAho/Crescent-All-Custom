@AbapCatalog.sqlViewName: 'ZJEDETAILSF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Details-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_JE_DETAILS_F4
  as select distinct from I_JournalEntry     as a
    inner join            I_JournalEntryItem as b on  a.CompanyCode        = b.CompanyCode
                                                  and a.FiscalYear         = b.FiscalYear
                                                  and a.AccountingDocument = b.AccountingDocument
    inner join            I_Supplier         as c on b.Supplier = c.Supplier
{
  key a.FiscalYear,
  key a.CompanyCode,
  key cast( a.AccountingDocument as abap.char( 10 ) ) as Jeno,
      a.PostingDate                                   as Jedate,
      c.Supplier                                      as Supplcode,
      a.DocumentReferenceID                           as Jerefno


}
where
      b.SourceLedger = '0L'
  and b.Ledger       = '0L'
