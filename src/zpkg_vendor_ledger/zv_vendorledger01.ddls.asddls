@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Ledger'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_VENDORLEDGER01

  with parameters
    p_begda : datum

  as select from    I_Supplier         as b

    left outer join I_JournalEntryItem as a on  b.Supplier             =  a.Supplier
                                            and a.Ledger               =  '0L'
                                            and a.SourceLedger         =  '0L'
                                            and a.FinancialAccountType =  'K'
                                            and a.PostingDate          < $parameters.p_begda
                                            and a.SpecialGLCode        <> 'F'
{
  key     $parameters.p_begda                as postingdate,
  key     b.Supplier,
  key     a.CompanyCode,
          b.SupplierName,
          a.CompanyCodeCurrency,
          concat( b.Supplier, 'A' )          as SortCode,
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          sum(a.AmountInCompanyCodeCurrency) as AmountInCompanyCodeCurrency,
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          sum(a.DebitAmountInCoCodeCrcy)     as DebitAmountInCoCodeCrcy,
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          sum(a.CreditAmountInCoCodeCrcy)    as CreditAmountInCoCodeCrcy
}

group by
  a.CompanyCodeCurrency,
  b.Supplier,
  a.CompanyCode,
  b.SupplierName
