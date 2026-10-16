@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_STAN_VS_ACT_NONBOM_F
  as select from    ZCDS_PP_STAN_VS_ACT_NONBOM   as a
    left outer join ZCDS_PP_STAN_VS_ACT_NONBOM_2 as c on  c.PostingDate      = a.PostingDate
                                                      and c.CostCenter       = a.CostCenter
                                                      and c.GLAccount        = a.GLAccount
                                                      and c.Plant            = a.Plant
                                                      and c.conbase          = a.conbase
    left outer join ZCDS_PP_STAN_VS_ACT_NONBOM_7 as b on  b.PostingDate = a.PostingDate
                                                      and b.CostCenter  = a.CostCenter
                                                      and b.Plant       = a.Plant
                                                      and b.GLAccount   = a.GLAccount
                                                      and b.conbase     = a.conbase
{
  a.PostingDate,
  a.Plant,
  a.CostCenter,
  a.CostCenterDescription,
  a.conbase,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  c.lmqty,
  a.MaterialBaseUnit,
  a.GLAccount,
  a.GLAccountLongName,
  b.Material,
  b.ProductDescription,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
  b.conqty,
  b.MaterialBaseUnit1,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
  b.issqty,
  b.MaterialBaseUnit2,
  @Semantics.amount.currencyCode: 'Currency'
  b.actissval,
  b.currency,
  cast( ( c.lmqty * b.conqty ) as abap.dec( 13, 3 ) ) as stdissue,
  ( case when b.issqty is not initial then cast( division( cast( b.actissval as abap.dec( 23, 2 ) ), cast( b.issqty as abap.dec( 13, 3 ) ), 2 ) as abap.dec( 23, 2) )
         else cast( 0 as abap.dec( 23, 2) ) end )     as lastpurprice
}
