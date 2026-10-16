@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR VACUUM BAG - Rej Loss Value Foundry ret'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_VACB_22
  as select from ZI_DPR_VACB_21          as a
    inner join   I_ProductValuationBasic as d on  d.Product       = a.Material
                                              and d.ValuationArea = a.Plant
{
  a.ManufacturingOrder,
  sum( case when d.InventoryValuationProcedure = 'V'
            then cast( d.MovingAveragePrice as abap.dec( 23, 2 ) )
            when d.InventoryValuationProcedure = 'S'
            then cast( d.StandardPrice as abap.dec( 23, 2 ) )
            else 0 end ) as Price

}
group by
  a.ManufacturingOrder
