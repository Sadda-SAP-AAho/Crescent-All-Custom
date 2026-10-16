@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR DI - DI Treatment Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_DI_13
  as select from I_OperationalAcctgDocItem as a
    inner join   I_Product                 as b on b.Product = a.Product
    inner join   zdt_dpr_di_cc             as c on  c.costtype = 'B'
                                                and c.kostl    = a.CostCenter
    inner join   zdt_gl_dpr_di             as d on  d.costtype = 'B'
                                                and d.hkont    = a.GLAccount
    inner join   zdt_mg_dpr_di             as e on  e.costtype = 'B'
                                                and e.matkl    = b.ProductGroup
{
  a.PostingDate,
  sum( cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) ) as trtmntcostacc
}
group by
  a.PostingDate
