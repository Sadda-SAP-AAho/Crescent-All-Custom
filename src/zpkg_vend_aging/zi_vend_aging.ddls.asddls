@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Aging'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_VEND_AGING
  with parameters
    p_date   : zde_date_va,
    p_agdate : zde_agdate_va
  as select from ZCDS_VEND_AGING
{
  key CompanyCode,
  key Supplier,
  key BusinessPartnerFullName,
  key SupplierAccountGroup,
  key PaymentTerms,
  key AccountingDocumentType,
  key AccountingDocument,
  key AccountingDocumentItem,
  key FiscalYear,
      MinorityGroup,
      SpecialGLCode,
      DocumentReferenceID,
      PostingDate,
      DocumentDate,
      NetDueDate,
      CompanyCodeCurrency,
      FunctionalCurrency,
      AmountInCompanyCodeCurrency,
      AmountInFunctionalCurrency,
      GLAccount,
      ProfitCenter,
      cast( cast( case when $parameters.p_agdate = 'PD' 
                 then cast( dats_days_between( PostingDate, $parameters.p_date ) as abap.int4 )
                 else cast( dats_days_between( NetDueDate, $parameters.p_date )  as abap.int4 ) end 
           as abap.char( 11 ) ) as abap.dec( 11 ) ) as days_c
}
where
  (
       ClearingDate is initial
    or ClearingDate >= $parameters.p_date
  )
  and  PostingDate  <= $parameters.p_date
