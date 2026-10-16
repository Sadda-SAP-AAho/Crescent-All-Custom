@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier of Payment'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_PAYMENT_HEAD_L3  as select distinct from I_OperationalAcctgDocItem as a
inner join I_JournalEntry as b
on ( b.AccountingDocument = a.AccountingDocument and b.FiscalYear = a.FiscalYear 
     and b.CompanyCode = a.CompanyCode )
//left outer join I_BusinessPartnerAddressTP_3 as g on g.BusinessPartner = a.supplier
{
  key a.AccountingDocument,
  key a.FiscalYear,
  key a.CompanyCode,
  a.Supplier
}
  where
  (
    (
         a.AccountingDocumentType =  'ZP'
      or a.AccountingDocumentType =  'KZ'
    )
    and  a.Supplier               is not initial
    and  a.ClearingIsReversed     <> 'X'
    and  a.FinancialAccountType   =  'K'
    and  ( b.IsReversed           = '' and b.IsReversal = '' )
  )

group by a.AccountingDocument,a.FiscalYear,a.CompanyCode,a.Supplier

