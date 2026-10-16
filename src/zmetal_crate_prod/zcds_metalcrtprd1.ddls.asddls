@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS  for Metal Crate Production'
@AbapCatalog.sqlViewName: 'ZCDS_METALCRATE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZCDS_METALCRATE1 
with parameters p_date: sydate
  as select from ZCDS_METALCRTPRD as a
  left outer join I_BOMComponentWithKeyDate( P_KeyDate: $parameters.p_date ) as b on a.ItemCode = b.BillOfMaterial
  left outer join I_Product as c on a.ItemCode = c.Product
  {
  key a.CustomerCode,
  key a.ItemCode as MetalCrateItem,
  b.BillOfMaterial,
  b.BillOfMaterialItemQuantity  as QuantityToBeProduced
  }
//  where c.ProductGroup = 'Z041'
