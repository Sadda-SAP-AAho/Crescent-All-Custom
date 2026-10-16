@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_SUPPLIER_DETAILS
  as select distinct from I_JournalEntry     as a
    inner join            I_JournalEntryItem as b on  a.CompanyCode        = b.CompanyCode
                                                  and a.FiscalYear         = b.FiscalYear
                                                  and a.AccountingDocument = b.AccountingDocument
    inner join            I_Supplier         as c on  c.Supplier             =  b.OffsettingAccount
                                                  and c.SupplierAccountGroup <> 'ZEMP'
{
  key a.CompanyCode        as CompCode,
  key a.FiscalYear         as FY,
  key a.AccountingDocument as JENo,
      c.Supplier,
      c.SupplierName

}

where
       b.SourceLedger = '0L'
  and  b.Ledger       = '0L'
  and(
       b.GLAccount    = '0048200100'
    or b.GLAccount    = '0036400160'
    or b.GLAccount    = '0036400130'
    or b.GLAccount    = '0048401010'
  )
