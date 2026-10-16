@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Material Serial Number'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MATSER_1_F4
as select from I_MaterialBOMLink as d 
inner join I_BillOfMaterialItemBasic as a on d.BillOfMaterial = a.BillOfMaterial
inner join ZI_MATSER_F4 as c on c.Material = a.BillOfMaterialComponent  and c.Plant = d.Plant

{
    key d.Material as Material_1,
    key c.Material,
    key c.Plant,
    key c.StorageLocation,
    key c.SerialNumber
    
}
where a.BillOfMaterialCategory = 'M'
group by
//a.BillOfMaterial,
d.Material,
c.Material,
c.Plant,
c.StorageLocation,
c.SerialNumber
