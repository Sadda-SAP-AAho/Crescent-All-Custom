@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Material Serial Number'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MATSER_F4
  as select from I_Equipment     as a
  inner join   I_EquipmentStatus as b on b.Equipment             = a.Equipment
                                     and b.MaintObjectInternalID = a.MaintObjectInternalID
  inner join   I_SerialNumberStockSegment as c on c.Material    = a.Material
                                              and c.SerialNumber = a.SerialNumber
                                              and c.Equipment    = a.Equipment
  inner join I_Product as d on   d.Product = a.Material
                           and ( d.ProductGroup = 'Z025' or d.ProductGroup = 'Z026'
                            or   d.ProductGroup = 'Z027' or d.ProductGroup = 'Z028' )
{
  key a.Material,
  key c.Plant,
  key c.StorageLocation,
  key a.SerialNumber
}
where
      a.Material               is not initial
  and a.SerialNumber           is not initial
  and b.EquipmentIsInWarehouse = 'X'
  and c.InventoryStockType     = '01'
group by
  a.Material,
  c.Plant,
  c.StorageLocation,
  a.SerialNumber
