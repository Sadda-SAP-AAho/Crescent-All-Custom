@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Material Info'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_MATERIAL_INFO
  provider contract transactional_query
  as projection on ZI_MATERIAL_INFO
{
      @EndUserText.label: 'Material No'
      @Search.defaultSearchElement: true
  key MaterialNo,
      @EndUserText.label: 'Plant'
      @Search.defaultSearchElement: true
  key PlantCode,
      @EndUserText.label: 'Dec'
      Description,
      @EndUserText.label: 'Product'
      ProductType,
      @EndUserText.label: 'Product type name'
      ProductTypName,
      @EndUserText.label: 'Material Groupo'
      @Search.defaultSearchElement: true
      MaterialGroup,
      @EndUserText.label: 'Group name'
      MaterialGroupName,
      @EndUserText.label: 'UOM'
      UoM,
      @EndUserText.label: 'Weight Unit'
      WeightUnit,
      @EndUserText.label: 'Gross Weight'
      GrossWeight,
      @EndUserText.label: 'net Weight'
      NetWeight,
      @EndUserText.label: 'Unit of weight'
      UnitofWeight,
      @EndUserText.label: 'Qty per Box'
      QtyPerBox,
      @EndUserText.label: 'Moc'
      MOC

}
