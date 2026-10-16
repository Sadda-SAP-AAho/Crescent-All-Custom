@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Planning Report 4(Basic)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_4_4 
  as select distinct from zdt_bomdet                                                as a
    left outer join       I_StockQuantityCurrentValue_2( P_DisplayCurrency : 'INR') as b on  a.component            = b.Product
                                                                                         and a.plant                = b.Plant

                                                                                         and (
                                                                                            b.StorageLocation       = 'SASG'
                                                                                            or b.StorageLocation    = 'KUSG'
                                                                                            or b.StorageLocation    = 'BGSG'
                                                                                            or b.StorageLocation    = 'BASG'
                                                                                          )
                                                                                         and (
                                                                                            b.InventoryStockType    = '01'
                                                                                            or b.InventoryStockType = '02'
                                                                                          )
                                                                                         and b.ValuationAreaType    = '1'

{
  key a.plant,
  key a.hedmaterial,
  key a.component,
      a.productgroup,
      cast( sum(b.MatlWrhsStkQtyInMatlBaseUnit) as abap.dec(23,3) ) as matstock

}
group by
  a.plant,
  a.hedmaterial,
  a.component,
  a.productgroup

union

select distinct from zdt_bomdet                                                as a
  left outer join    I_StockQuantityCurrentValue_2( P_DisplayCurrency : 'INR') as b on  a.component                 = b.Product
                                                                                    and a.plant                     = b.Plant

                                                                                    and b.InventorySpecialStockType = 'O'
                                                                                    and (
                                                                                       b.InventoryStockType         = '01'
                                                                                       or b.InventoryStockType      = '02'
                                                                                     )
                                                                                    and b.ValuationAreaType         = '1'

{
  key a.plant,
  key a.hedmaterial,
  key a.component,
      a.productgroup,
      cast( sum(b.MatlWrhsStkQtyInMatlBaseUnit) as abap.dec(23,3) ) as matstock

}
group by
  a.plant,
  a.hedmaterial,
  a.component,
  a.productgroup
