@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-Inventory(Store)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MGMTDASH_INV_STR
  as select distinct from I_StockQuantityCurrentValue_2 ( P_DisplayCurrency : 'INR' ) as a
    left outer join       I_ProductPlantBasic                                         as b on  a.Product = b.Product
                                                                                           and a.Plant   = b.Plant
    left outer join       I_Product                                                   as c on a.Product = c.Product
{
  key    a.Plant,
  key    b.ProfitCenter,

         sum( cast ( a.StockValueInCCCrcy as abap.dec( 12, 3 ) ) ) as StockValue

}

where
  (
       c.ProductGroup = 'Z010'
    or c.ProductGroup = 'Z011'
    or c.ProductGroup = 'Z012'
    or c.ProductGroup = 'Z013'
    or c.ProductGroup = 'Z020'
    or c.ProductGroup = 'Z030'
    or c.ProductGroup = 'Z031'
    or c.ProductGroup = 'Z034'
    or c.ProductGroup = 'Z036'
    or c.ProductGroup = 'Z039'
    or c.ProductGroup = 'Z041'
    or c.ProductGroup = 'Z042'
    or c.ProductGroup = 'Z014'
    or c.ProductGroup = 'Z016'
    or c.ProductGroup = 'Z018'
    or c.ProductGroup = 'Z019'
    or c.ProductGroup = 'Z032'
    or c.ProductGroup = 'Z035'
    or c.ProductGroup = 'Z033'
  )

group by
  a.Plant,
  b.ProfitCenter
