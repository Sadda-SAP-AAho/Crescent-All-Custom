    @AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Aging'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_VEND_AGING
  as select from I_OperationalAcctgDocItem as a
    inner join   I_BusinessPartner         as c on c.BusinessPartner = a.Supplier
    inner join   I_BusinessPartnerSupplier as b on b.BusinessPartner = a.Supplier
    inner join   I_SupplierCompany         as d on d.Supplier = a.Supplier
    inner join   I_JournalEntry            as e on  e.AccountingDocument = a.AccountingDocument
                                               and e.CompanyCode        = a.CompanyCode
                                               and e.FiscalYear         = a.FiscalYear
    left outer join ZR_PROFITCENTER      as f on f.AccountingDocument = a.AccountingDocument
                                               and f.CompanyCode        = a.CompanyCode
                                               and f.FiscalYear         = a.FiscalYear                                         
{
  a.CompanyCode,
  a.Supplier,
  c.BusinessPartnerFullName,
  b.SupplierAccountGroup,
  a.PaymentTerms,
  a.AccountingDocumentType,
  a.AccountingDocument,
  a.AccountingDocumentItem,
  a.FiscalYear,
  d.MinorityGroup,
  a.SpecialGLCode,
  e.DocumentReferenceID,
  a.PostingDate,
  a.DocumentDate,
  a.NetDueDate,
  a.ClearingDate,
  a.CompanyCodeCurrency,
  a.FunctionalCurrency,
  a.GLAccount,
  f.profitcenter, 
  cast( a.AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) ) as AmountInCompanyCodeCurrency,
  cast( a.AmountInFunctionalCurrency  as abap.dec( 23, 2 ) ) as AmountInFunctionalCurrency
}
where
      a.FinancialAccountType =  'K'
  and a.SpecialGLCode        <> 'F'
