@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL Code - Finance'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_FINGLCODE

  as select distinct from I_BillingDocument     as a

    inner join            I_BillingDocumentItem as d on d.BillingDocument = a.BillingDocument

    inner join            I_JournalEntryItem    as b on  a.CompanyCode       = b.CompanyCode
                                                     and b.SalesDocument     = d.SalesDocument
                                                     and b.SalesDocumentItem = d.SalesDocumentItem

    inner join            I_GLAccountText       as c on  c.Language  = $session.system_language
                                                     and c.GLAccount = b.GLAccount

{

  key    a.BillingDocument,
  key    d.BillingDocumentItem,
  key    b.FiscalYear,
  key    d.SalesDocument,
  key    d.SalesDocumentItem,
  key    b.CompanyCode,
         case when ( a.BillingDocumentType = 'F2' or a.BillingDocumentType = 'F8' )
         then ( case when c.GLAccount = '0036100120' then ''
                     when c.GLAccount = '0036100110' then ''
                     else c.GLAccount end )
         else ( case when c.GLAccount = '0036100120' then c.GLAccount
                     when c.GLAccount = '0036100110' then c.GLAccount
                     else '' end )end as GLAccount,
         case when ( a.BillingDocumentType = 'F2' or a.BillingDocumentType = 'F8' )
         then ( case when c.GLAccount = '0036100120' then ''
                    when c.GLAccount = '0036100110' then ''
                    else c.GLAccountName end )
         else ( case when c.GLAccount = '0036100120' then c.GLAccountName
                    when c.GLAccount = '0036100110' then c.GLAccountName
                    else '' end )end  as GLAccountName

}

where
  (
        b.GLAccount              like '%36%'
    or  b.GLAccount              =    '0012800810'
    or  b.GLAccount              =    '0048400450'
  )

  and(
        b.GLAccount              <>   '0036300020'
    and b.GLAccount              <>   '0036300030'
  )

  and   b.AccountingDocumentType =    'RV'

  and   b.Ledger                 =    '0L'

  and   d.SalesDocument          is not initial

  and   a.BillingDocumentType    <>   'G2'

group by
  a.BillingDocument,
  d.BillingDocumentItem,
  b.FiscalYear,
  d.SalesDocument,
  d.SalesDocumentItem,
  b.CompanyCode,
  c.GLAccount,
  c.GLAccountName,
  a.BillingDocumentType

union select distinct from I_BillingDocument     as a

  inner join               I_BillingDocumentItem as d on d.BillingDocument = a.BillingDocument

  inner join               I_JournalEntry        as e on  e.OriginalReferenceDocument = a.BillingDocument
                                                      and e.CompanyCode               = a.CompanyCode

  inner join               I_JournalEntryItem    as b on  b.CompanyCode        = e.CompanyCode
                                                      and b.FiscalYear         = e.FiscalYear
                                                      and b.AccountingDocument = e.AccountingDocument
// and b.SalesDocument     = d.SalesDocument
// and b.SalesDocumentItem = d.SalesDocumentItem

  inner join               I_GLAccountText       as c on  c.Language  = $session.system_language
                                                      and c.GLAccount = b.GLAccount

{

  key    a.BillingDocument,
  key    d.BillingDocumentItem,
  key    b.FiscalYear,
  key    d.SalesDocument,
  key    d.SalesDocumentItem,
  key    b.CompanyCode,
         case when ( a.BillingDocumentType = 'F2' or a.BillingDocumentType = 'F8' )
         then ( case when c.GLAccount = '0036100120' then ''
                     when c.GLAccount = '0036100110' then ''
                     else c.GLAccount end )
         else ( case when c.GLAccount = '0036100120' then c.GLAccount
                     when c.GLAccount = '0036100110' then c.GLAccount
                     else '' end )end as GLAccount,
         case when ( a.BillingDocumentType = 'F2' or a.BillingDocumentType = 'F8' )
         then ( case when c.GLAccount = '0036100120' then ''
                    when c.GLAccount = '0036100110' then ''
                    else c.GLAccountName end )
         else ( case when c.GLAccount = '0036100120' then c.GLAccountName
                    when c.GLAccount = '0036100110' then c.GLAccountName
                    else '' end )end  as GLAccountName

}

where
  (
        b.GLAccount              like '%36%'
    or  b.GLAccount              =    '0012800810'
    or  b.GLAccount              =    '0048400450'
  )

  and(
        b.GLAccount              <>   '0036300020'
    and b.GLAccount              <>   '0036300030'
  )

  and   b.AccountingDocumentType =    'RV'

  and   b.Ledger                 =    '0L'

  and   a.BillingDocumentType    =    'G2'

group by
  a.BillingDocument,
  d.BillingDocumentItem,
  b.FiscalYear,
  d.SalesDocument,
  d.SalesDocumentItem,
  b.CompanyCode,
  c.GLAccount,
  c.GLAccountName,
  a.BillingDocumentType
