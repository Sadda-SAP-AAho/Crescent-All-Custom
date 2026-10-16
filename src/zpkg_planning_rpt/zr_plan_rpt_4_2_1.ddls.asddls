@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Planning FG stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_4_2_1
  as select distinct from ZR_PLAN_RPT_4_3                                           as a //zdt_bomdet                                                as a
    left outer join       I_StockQuantityCurrentValue_2( P_DisplayCurrency : 'INR') as b on  a.hedmaterial          = b.Product
                                                                                         and a.plant                = b.Plant

                                                                                         and (
                                                                                            b.StorageLocation       = 'SASG'
                                                                                            or b.StorageLocation    = 'KUSG'
                                                                                            or b.StorageLocation    = 'BGSG'
                                                                                            or b.StorageLocation    = 'BASG'
                                                                                            or b.StorageLocation    = 'SAFG'
                                                                                            or b.StorageLocation    = 'KUFG'
                                                                                            or b.StorageLocation    = 'BGFG'
                                                                                            or b.StorageLocation    = 'BAFG'
                                                                                          )
                                                                                         and (
                                                                                            b.InventoryStockType    = '01'
                                                                                            or b.InventoryStockType = '02'
                                                                                          )
                                                                                         and b.ValuationAreaType    = '1'
    left outer join       I_ProductPlantBasic                                       as c on  c.Product = a.hedmaterial
                                                                                         and c.Plant   = a.plant

{
      //  key a.plant,
  key (case when c.SpecialProcurementType = '40' then '1100'
                    else a.plant end)                               as Plant,
  key a.hedmaterial,
      cast( sum(b.MatlWrhsStkQtyInMatlBaseUnit) as abap.dec(23,3) ) as matstock

}
where
  b.MatlWrhsStkQtyInMatlBaseUnit is not initial
group by
  a.plant,
  c.SpecialProcurementType,
  a.hedmaterial
