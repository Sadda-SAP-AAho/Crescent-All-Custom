@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Ageing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUST_AGE_F
  with parameters
    p_cur    : zde_cur_va,
    p_date   : zde_date_va,
    p_agdate : zde_agdate_va,
    p_age1   : zdm_age_buc_va,
    p_age2   : zdm_age_buc_va,
    p_age3   : zdm_age_buc_va,
    p_age4   : zdm_age_buc_va,
    p_age5   : zdm_age_buc_va
  as select from ZI_CUST_AGE_F2( p_cur : $parameters.p_cur , p_date : $parameters.p_date, p_agdate : $parameters.p_agdate )
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
           
      paidamt,
      balamt,
      dueamt01,

//      case when $parameters.p_cur = 'CCC'
//          then cast(paidamt  as abap.dec( 23, 2 ) )
//          else cast( paidamt1 as abap.dec( 23, 2 ) ) end as paidamt,
//
//      case when $parameters.p_cur = 'CCC'
//               then AmountInCompanyCodeCurrency
//               else AmountInFunctionalCurrency end       as balamt,
//      case when days_c <= 0
//           then case when $parameters.p_cur = 'CCC'
//                then AmountInCompanyCodeCurrency
//                else AmountInFunctionalCurrency end
//           else 0 end                                    as dueamt,
//      case when days_c >= 1 and days_c <= $parameters.p_age1
//           then case when $parameters.p_cur = 'CCC'
//                then AmountInCompanyCodeCurrency
//                else AmountInFunctionalCurrency end
//           else 0 end                                    as ageb1,
//      case when days_c > $parameters.p_age1 and days_c <= $parameters.p_age2
//           then case when $parameters.p_cur = 'CCC'
//                then AmountInCompanyCodeCurrency
//                else AmountInFunctionalCurrency end
//           else 0 end                                    as ageb2,
//      case when days_c > $parameters.p_age2 and days_c <= $parameters.p_age3
//           then case when $parameters.p_cur = 'CCC'
//                then AmountInCompanyCodeCurrency
//                else AmountInFunctionalCurrency end
//           else 0 end                                    as ageb3,
//      case when days_c > $parameters.p_age3 and days_c <= $parameters.p_age4
//           then case when $parameters.p_cur = 'CCC'
//                then AmountInCompanyCodeCurrency
//                else AmountInFunctionalCurrency end
//           else 0 end                                    as ageb4,
//      case when days_c > $parameters.p_age4 and days_c <= $parameters.p_age5
//           then case when $parameters.p_cur = 'CCC'
//                then AmountInCompanyCodeCurrency
//                else AmountInFunctionalCurrency end
//           else 0 end                                    as ageb5,
//      case when days_c > $parameters.p_age5
//           then case when $parameters.p_cur = 'CCC'
//                then AmountInCompanyCodeCurrency
//                else AmountInFunctionalCurrency end
//           else 0 end                                    as ageb6
           
           
           
       case when days_c <= 0
           then dueamt01 
           else 0 end                                    as dueamt,
      case when days_c >= 1 and days_c <= $parameters.p_age1
             then dueamt01 
           else 0 end                                    as ageb1,
      case when days_c > $parameters.p_age1 and days_c <= $parameters.p_age2
             then dueamt01 
           else 0 end                                  as ageb2,
      case when days_c > $parameters.p_age2 and days_c <= $parameters.p_age3
             then dueamt01 
           else 0 end                                  as ageb3,
      case when days_c > $parameters.p_age3 and days_c <= $parameters.p_age4
            then dueamt01 
           else 0 end                                  as ageb4,
      case when days_c > $parameters.p_age4 and days_c <= $parameters.p_age5
             then dueamt01 
           else 0 end                                 as ageb5,
      case when days_c > $parameters.p_age5
            then dueamt01 
           else 0 end                                  as ageb6
}
