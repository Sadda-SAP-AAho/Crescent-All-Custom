@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-Inventory(RM)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MGMTDASH_INV_RM
  as select distinct from I_StockQuantityCurrentValue_2 ( P_DisplayCurrency : 'INR' ) as a
    left outer join       I_ProductPlantBasic                                         as b on  a.Product = b.Product
                                                                                           and a.Plant   = b.Plant
    left outer join       I_Product                                                   as c on a.Product = c.Product
{
  key    a.Plant,
  key    b.ProfitCenter                                                                                                                             as ProfitCenter,

         sum( cast ( cast( coalesce ( a.MatlWrhsStkQtyInMatlBaseUnit , 0 ) as abap.dec(12,3) ) * coalesce ( c.NetWeight , 0 ) as abap.dec(12,3) ) ) as rmonhandwt

}


where
  (
       c.ProductGroup = 'Z015'
    or c.ProductGroup = 'Z017'
    or c.ProductGroup = 'Z021'
  )

group by
  a.Plant,
  b.ProfitCenter
