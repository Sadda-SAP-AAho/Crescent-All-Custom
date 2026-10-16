@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Details(48200100)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_JE_DETAILS_1
  as select distinct from I_JournalEntry       as a
    inner join            I_JournalEntryItem   as b on  a.CompanyCode        = b.CompanyCode
                                                    and a.FiscalYear         = b.FiscalYear
                                                    and a.AccountingDocument = b.AccountingDocument
    left outer join       I_GLAccountText      as c on  b.GLAccount = c.GLAccount
                                                    and c.Language  = 'E'
    left outer join       I_Supplier           as d on d.Supplier = b.OffsettingAccount
    left outer join       ZTBL_FCTN_JE_DETAILS as e on  a.CompanyCode        = e.CompCode
                                                    and a.FiscalYear         = e.FY
                                                    and a.AccountingDocument = e.JENo
                                                    and b.GLAccount          = e.GLAccount
{
  key a.CompanyCode                        as CompCode,
  key a.FiscalYear                         as FY,
  key a.AccountingDocument                 as JENo,
      a.DocumentDate                       as JEDate,
      concat(
        case substring( cast( a.DocumentDate as abap.char(8) ), 5, 2 )
          when '01' then 'January'
          when '02' then 'February'
          when '03' then 'March'
          when '04' then 'April'
          when '05' then 'May'
          when '06' then 'June'
          when '07' then 'July'
          when '08' then 'August'
          when '09' then 'September'
          when '10' then 'October'
          when '11' then 'November'
          when '12' then 'December'
        end,
        concat(
          ' ',
          substring( cast( a.DocumentDate as abap.char(8) ), 1, 4 )
        )
      )                                    as MonthYear,

      b.CompanyCodeCurrency,
      a.AccountingDocumentHeaderText,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( b.AmountInCompanyCodeCurrency ) as AmtInr,
      b.GLAccount,
      c.GLAccountLongName,
      a.AccountingDocumentType,
      a.AbsoluteExchangeRate,
      d.Supplier,
      d.SupplierFullName                   as SupplierName
}

where e.RowNo = 1
  and b.SourceLedger = '0L'
  and b.Ledger       = '0L'
//  and b.GLAccount    = '0048200100'

group by
  a.CompanyCode,
  a.FiscalYear,
  a.AccountingDocument,
  e.RowNo,
  a.DocumentDate,
  b.CompanyCodeCurrency,
  a.AccountingDocumentHeaderText,
  b.GLAccount,
  c.GLAccountLongName,
  a.AccountingDocumentType,
  a.AbsoluteExchangeRate,
  d.Supplier,
  d.SupplierFullName
