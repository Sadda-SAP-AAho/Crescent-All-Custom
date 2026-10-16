@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR CI - Store Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_CI_12 
  as select from I_OperationalAcctgDocItem as a
    inner join   I_Product                 as b on b.Product = a.Product
    inner join   zdt_dpr_ci_cc             as c on  c.costtype = 'A'
                                                and c.kostl    = a.CostCenter
    inner join   zdt_gl_dpr_ci             as d on  d.costtype = 'A'
                                                and d.hkont    = a.GLAccount
    inner join   zdt_mg_dpr_ci             as e on  e.costtype = 'A'
                                                and e.matkl    = b.ProductGroup
{
  a.PostingDate,
  sum( cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) ) as stcostactexp
}
group by
  a.PostingDate
