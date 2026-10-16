@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR VACUUM BAG - Stock Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_VACB_4
  as select from I_StockQuantityCurrentValue_2( P_DisplayCurrency : 'INR' ) as a
    inner join   I_ProductPlantBasic                                        as b on  b.Product = a.Product
                                                                                 and b.Plant   = a.Plant
    inner join   I_Product                                                  as c on c.Product = a.Product
{
  a.Plant,
  sum( case when ( a.ProductGroup = 'Z003' and a.StorageLocation = 'BGFG' )
            then cast( ( a.MatlWrhsStkQtyInMatlBaseUnit * c.NetWeight ) as abap.dec( 23, 3 ) ) else cast( 0 as abap.dec( 23, 3 ) ) end ) as fgstock,
  sum( case when ( a.ProductGroup = 'Z025' or a.ProductGroup = 'Z026' or a.ProductGroup = 'Z027' or a.ProductGroup = 'Z028' )
            then cast( ( a.MatlWrhsStkQtyInMatlBaseUnit * c.NetWeight ) as abap.dec( 23, 3 ) ) else cast( 0 as abap.dec( 23, 3 ) ) end ) as sfgstock,
  sum( case when a.ProductGroup = 'Z025'
            then cast( ( a.MatlWrhsStkQtyInMatlBaseUnit * c.NetWeight ) as abap.dec( 23, 3 ) ) else cast( 0 as abap.dec( 23, 3 ) ) end ) as caststock,
  sum( case when a.ProductGroup = 'Z026'
            then cast( ( a.MatlWrhsStkQtyInMatlBaseUnit * c.NetWeight ) as abap.dec( 23, 3 ) ) else cast( 0 as abap.dec( 23, 3 ) ) end ) as macstock,
  sum( case when a.ProductGroup = 'Z027'
            then cast( ( a.MatlWrhsStkQtyInMatlBaseUnit * c.NetWeight ) as abap.dec( 23, 3 ) ) else cast( 0 as abap.dec( 23, 3 ) ) end ) as grindstock,
  sum( case when a.ProductGroup = 'Z028'
            then cast( ( a.MatlWrhsStkQtyInMatlBaseUnit * c.NetWeight ) as abap.dec( 23, 3 ) ) else cast( 0 as abap.dec( 23, 3 ) ) end ) as paintstock

}
where
       a.Plant              = '1300'
  and(
       b.ProfitCenter       = '0000001301'
    or b.ProfitCenter       = '0000001302'
  )
  and  a.InventoryStockType = '01'
  and  a.ValuationAreaType  = '1'
group by
  a.Plant
