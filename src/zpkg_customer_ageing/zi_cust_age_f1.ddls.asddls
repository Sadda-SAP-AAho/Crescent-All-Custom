@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Ageing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUST_AGE_F1
  with parameters
    p_cur    : zde_cur_va,
    p_date   : zde_date_va,
    p_agdate : zde_agdate_va
  as select from ZI_CUST_AGING( p_date : $parameters.p_date, p_agdate : $parameters.p_agdate )
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
      case when $parameters.p_cur = 'CCC' then CompanyCodeCurrency
           else FunctionalCurrency end                   as currency,

      case when $parameters.p_cur = 'CCC'
          then cast(paidamt  as abap.dec( 23, 2 ) )
          else cast( paidamt1 as abap.dec( 23, 2 ) ) end as paidamt,

      case when $parameters.p_cur = 'CCC'
               then AmountInCompanyCodeCurrency
               else AmountInFunctionalCurrency end       as balamt
               
               
     
}
