@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_JE_DETAILS
  as select distinct from I_JournalEntry      as a
    inner join            I_JournalEntryItem  as b on  a.CompanyCode        = b.CompanyCode
                                                   and a.FiscalYear         = b.FiscalYear
                                                   and a.AccountingDocument = b.AccountingDocument
    left outer join       I_GLAccountText     as c on  b.GLAccount = c.GLAccount
                                                   and c.Language  = 'E'

    left outer join       ZI_JE_DETAILS_1     as e on  a.CompanyCode        = e.CompCode
                                                   and a.FiscalYear         = e.FY
                                                   and a.AccountingDocument = e.JENo

    left outer join       ZI_JE_DETAILS_2     as f on  a.CompanyCode        = f.CompCode
                                                   and a.FiscalYear         = f.FY
                                                   and a.AccountingDocument = f.JENo

    left outer join       ZI_JE_DETAILS_3     as g on  a.CompanyCode        = g.CompCode
                                                   and a.FiscalYear         = g.FY
                                                   and a.AccountingDocument = g.JENo

    left outer join       ZI_JE_DETAILS_4     as h on  a.CompanyCode        = h.CompCode
                                                   and a.FiscalYear         = h.FY
                                                   and a.AccountingDocument = h.JENo
    left outer join       ZI_SUPPLIER_DETAILS as d on  e.CompCode = d.CompCode
                                                   and e.FY       = d.FY
                                                   and e.JENo     = d.JENo
                                                   and e.Supplier = d.Supplier
{
  key a.CompanyCode        as CompCode,
  key a.FiscalYear         as FY,
  key a.AccountingDocument as JENo,
      a.DocumentDate       as JEDate,
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
      )                    as MonthYear,

      b.CompanyCodeCurrency,
      a.AccountingDocumentHeaderText,

      e.GLAccount          as GLCode1,
      e.GLAccountLongName  as GLName1,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      e.AmtInr             as AmtInr1,

      f.GLAccount          as GLCode2,
      f.GLAccountLongName  as GLName2,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      f.AmtInr             as AmtInr2,

      g.GLAccount          as GLCode3,
      g.GLAccountLongName  as GLName3,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      g.AmtInr             as AmtInr3,

      h.GLAccount          as GLCode4,
      h.GLAccountLongName  as GLName4,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      h.AmtInr             as AmtInr4,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      (
       coalesce( cast( e.AmtInr as abap.dec(15,2) ), 0 ) +
       coalesce( cast( f.AmtInr as abap.dec(15,2) ), 0 ) +
       coalesce( cast( g.AmtInr as abap.dec(15,2) ), 0 ) +
       coalesce( cast( h.AmtInr as abap.dec(15,2) ), 0 )
      )                    as TotalAmtInr,

      a.AccountingDocumentType,
      a.DocumentReferenceID,
      a.AbsoluteExchangeRate,
      d.Supplier,
      d.SupplierName
}

where
       b.SourceLedger =  '0L'
  and  b.Ledger       =  '0L'
  and(
       b.GLAccount    =  '0048200100'
    or b.GLAccount    =  '0036400160'
    or b.GLAccount    =  '0036400130'
    or b.GLAccount    =  '0048401010'
  )
  and  b.GLAccount    <> '0099800010'
