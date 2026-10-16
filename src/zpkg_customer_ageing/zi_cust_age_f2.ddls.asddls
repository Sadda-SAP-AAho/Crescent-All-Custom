@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Ageing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUST_AGE_F2
  with parameters
    p_cur    : zde_cur_va,
    p_date   : zde_date_va,
    p_agdate : zde_agdate_va
  as select from ZI_CUST_AGE_F1( p_cur : $parameters.p_cur , p_date : $parameters.p_date, p_agdate : $parameters.p_agdate )
{
  key type,
  key CompanyCode,
  key Customer,
  key BusinessPartnerFullName,
  key CustomerAccountGroup,
  key PaymentTerms,
  key AccountingDocumentType,
  key AccountingDocument,
  key AccountingDocumentItem,
  key FiscalYear,
      InvoiceType,
      ispattern,
      businessplace,
      arinv,
      SalesGroup,
      SpecialGLCode,
      DocumentReferenceID,
      PostingDate,
      DocumentDate,
      netduedate,
      CompanyCodeCurrency,
      FunctionalCurrency,
      AmountInCompanyCodeCurrency,
      AmountInFunctionalCurrency,
      GLAccount,
      profitcenter,
      AssignmentReference,
      inv,
      SALESDOCUMENT,
      days_c,
      TaxNumber3,
      TaxNumberRef,
      Salesnoteref,
      RegionName,
      PaymentTerm,
      Reference3IDByBusinessPartner,
      exchangerate,
      accountgroupname,
      DocumentItemText,
      Etadt,
      Etddt,
      Ladingdt,
      Docsentcustdt,
      Docpresentbnkdt,
      currency,
      paidamt,
      balamt,
      cast( ( coalesce(balamt,0)  + coalesce(cast(paidamt as abap.dec( 21, 2 )),0)  )  as abap.dec( 23, 2 )) as dueamt01



}
