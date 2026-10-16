@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Nostro A/c F4'

define root view entity ZI_NOSTRO_F4
  //  as select from I_BillingDocument
  as select distinct from    I_OperationalAcctgDocItem as A
    left outer join I_BillingDocument         as B on A.OriginalReferenceDocument = B.BillingDocument
    left outer join I_Customer                as c on A.Customer = c.Customer

{
  key    A.OriginalReferenceDocument,
  key    A.AccountingDocument,
  key    A.CompanyCode,
  key    A.Customer,
         A.FiscalYear,
         B.BillingDocumentDate as postingdate,
         c.CustomerFullName

}
where
  A.FinancialAccountType = 'D'  and
  A.ClearingAccountingDocument = '' and
  ( A.AccountingDocumentType = 'RV' or
    A.AccountingDocumentType = 'DR' or
    A.AccountingDocumentType = 'UE' )
