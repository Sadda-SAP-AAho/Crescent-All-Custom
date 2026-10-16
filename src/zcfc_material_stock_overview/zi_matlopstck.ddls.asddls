@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Opening Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_MATLOPSTCK
  with parameters
    p_date_low_1 : zde_date // user-entered date

  as select from I_MaterialStockTimeSeries(
                 P_StartDate  : $parameters.p_date_low_1,
                 P_EndDate    : $parameters.p_date_low_1,
                 P_PeriodType : 'D'
                 )         as a
    inner join   I_Product as b on a.Material = b.Product
{
  key a.Material                                             as Product,
  key b.ProductGroup                                         as ProductGroup,
  key a.Plant                                                as Plant,
  key a.StorageLocation                                      as StorageLocation,

      cast(a.MatlWrhsStkQtyInMatlBaseUnit as abap.dec(15,3)) as OpenStkQty
}
where
      a.InventoryStockType        = '01'
  and a.InventorySpecialStockType = ''
  and a.EndDate                   = $parameters.p_date_low_1;
