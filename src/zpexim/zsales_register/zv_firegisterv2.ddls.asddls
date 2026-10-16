@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI REGISTER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_FIREGISTERV2

  as select distinct from I_OperationalAcctgDocItem as a

    inner join            I_GLAccountText           as b on  b.GLAccount = a.GLAccount
                                                         and b.Language  = $session.system_language

{

  key    a.AccountingDocument,
  key    a.FiscalYear,
  key    a.CompanyCode,
         a.GLAccount,
         a.IN_HSNOrSACCode,
         a.TransactionCurrency,
         b.GLAccountName,
         sum( cast( a.AmountInTransactionCurrency as abap.dec( 23,2 ) ) ) as Amount

}

where
  (
       a.AccountingDocumentType =    'DR'
    or a.AccountingDocumentType =    'DG'
  )

  and(
       b.GLAccount              like '%36%'
    or b.GLAccount              =    '0012800810'
    or b.GLAccount              =    '0048400450'
  )

group by
  a.AccountingDocument,
  a.FiscalYear,
  a.CompanyCode,
  a.GLAccount,
  a.IN_HSNOrSACCode,
  a.TransactionCurrency,
  b.GLAccountName
