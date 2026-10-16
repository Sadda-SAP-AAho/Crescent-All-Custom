@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Aging'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_VEND_AGING_F 
with parameters
    p_cur    : zde_cur_va,
    p_date   : zde_date_va,
    p_agdate : zde_agdate_va,
    p_age1   : zdm_age_buc_va,
    p_age2   : zdm_age_buc_va,
    p_age3   : zdm_age_buc_va,
    p_age4   : zdm_age_buc_va,
    p_age5   : zdm_age_buc_va
as select from ZI_VEND_AGING( p_date : $parameters.p_date, p_agdate : $parameters.p_agdate  ) 
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
    GLAccount,
    ProfitCenter,
    case when $parameters.p_cur = 'CCC' then CompanyCodeCurrency
         else FunctionalCurrency end as currency,
    days_c,
    case when days_c >= 1
         then case when $parameters.p_cur = 'CCC' 
              then AmountInCompanyCodeCurrency 
              else AmountInFunctionalCurrency end
         else 0 end as balamt,
    case when days_c <= 0
         then case when $parameters.p_cur = 'CCC' 
              then AmountInCompanyCodeCurrency 
              else AmountInFunctionalCurrency end
         else 0 end as dueamt,     
    case when days_c >= 1 and days_c <= $parameters.p_age1
         then case when $parameters.p_cur = 'CCC' 
              then AmountInCompanyCodeCurrency 
              else AmountInFunctionalCurrency end
         else 0 end as ageb1,
    case when days_c > $parameters.p_age1 and days_c <= $parameters.p_age2
         then case when $parameters.p_cur = 'CCC' 
              then AmountInCompanyCodeCurrency 
              else AmountInFunctionalCurrency end
         else 0 end as ageb2,     
    case when days_c > $parameters.p_age2 and days_c <= $parameters.p_age3
         then case when $parameters.p_cur = 'CCC' 
              then AmountInCompanyCodeCurrency 
              else AmountInFunctionalCurrency end
         else 0 end as ageb3,
    case when days_c > $parameters.p_age3 and days_c <= $parameters.p_age4
         then case when $parameters.p_cur = 'CCC' 
              then AmountInCompanyCodeCurrency 
              else AmountInFunctionalCurrency end
         else 0 end as ageb4,
    case when days_c > $parameters.p_age4 and days_c <= $parameters.p_age5
         then case when $parameters.p_cur = 'CCC' 
              then AmountInCompanyCodeCurrency 
              else AmountInFunctionalCurrency end
         else 0 end as ageb5,            
    case when days_c > $parameters.p_age5
         then case when $parameters.p_cur = 'CCC' 
              then AmountInCompanyCodeCurrency 
              else AmountInFunctionalCurrency end
         else 0 end as ageb6      

}
