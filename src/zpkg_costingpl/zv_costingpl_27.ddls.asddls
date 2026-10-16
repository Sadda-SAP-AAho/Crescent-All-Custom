@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing PL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_27

  as select distinct from I_JournalEntryItem as a

    inner join            I_GLAccountText    as c on  c.Language  = $session.system_language
                                                  and c.GLAccount = a.GLAccount

{

  key    a.CompanyCode,
  key    a.AccountingDocument,
  key    a.FiscalYear,
  key    a.ReferenceDocument,
  key    a.ReferenceDocumentItem,
         c.GLAccount     as GLAccount,
         c.GLAccountName as GLAccountName

}

where
        a.GLAccount              like '%36%'

  and(
        a.GLAccount              <>   '0036300020'
    and a.GLAccount              <>   '0036300030'
  )

  and   a.AccountingDocumentType =    'RV'

  and   a.Ledger                 =    '0L'
