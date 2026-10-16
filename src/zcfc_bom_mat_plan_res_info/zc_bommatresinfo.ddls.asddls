@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM wise Material Planning and Resource Info'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_BOMMATRESINFO
  provider contract transactional_query
  as projection on ZI_BOMMATRESINFO
{

      @EndUserText.label: 'Plant'
  key Plant,
      @EndUserText.label: 'Header Material'
  key Hedmaterial,
      @EndUserText.label: 'Header Mat. Grp. Code'
  key HeaderGrpCode,
      @EndUserText.label: 'Header Mat. Grp. Name'
  key HeaderGrpName,
      @EndUserText.label: 'Header Qty'
  key HeadQty,
      @EndUserText.label: 'Level'
  key Bomlevel,
      @EndUserText.label: 'Parent Material'
  key Parent,
      @EndUserText.label: 'Child Material'
  key Component,
      @EndUserText.label: 'Storage Location'
  key StorageLocation,
      @EndUserText.label: 'Parent Material Gross Weight'
      @Semantics.quantity.unitOfMeasure: 'ParentGrossWtUnit'
      ParentGrosswt,
      @UI.hidden: true
      ParentGrossWtUnit,
      @EndUserText.label: 'Child Material Name'
      ChildDesc,
      @EndUserText.label: 'Child Mat. Grp. Code'
      ChildGrpCode,
      @EndUserText.label: 'Child Mat. Grp. Name'
      ChildGrpName,
      @EndUserText.label: 'Quantity'
      Childqty,
      @EndUserText.label: 'UOM'
      Bomitemqtyunit,
      @EndUserText.label: 'Net Weight'
      @Semantics.quantity.unitOfMeasure: 'ChildWtUnit'
      ChildNetwt,
      @EndUserText.label: 'Weight Unit'
      ChildWtUnit,
      @EndUserText.label: 'Child Mat. Plant'
      ChildPlant,
      @EndUserText.label: 'Stock UOM'
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label: 'Child Mat. Stock'
      ChildMatlStock,
      @EndUserText.label: 'Resource 1'
      Resource_no1,
      @EndUserText.label: 'Resource 1 Name'
      Resource_no1_desc,
      @EndUserText.label: 'Cycle Time 1'
      Cycle_time_r1,
      @EndUserText.label: 'Lead Time 1'
      Lead_time_r1,
      @EndUserText.label: 'Batch Qty 1'
      Batch_qty_r1,
      @EndUserText.label: 'Resource 2'
      Resource_no2,
      @EndUserText.label: 'Resource 2 Name'
      Resource_no2_desc,
      @EndUserText.label: 'Cycle Time 2'
      Cycle_time_r2,
      @EndUserText.label: 'Lead Time 2'
      Lead_time_r2,
      @EndUserText.label: 'Batch Qty 2'
      Batch_qty_r2,
      @EndUserText.label: 'Resource 3'
      Resource_no3,
      @EndUserText.label: 'Resource 3 Name'
      Resource_no3_desc,
      @EndUserText.label: 'Cycle Time 3'
      Cycle_time_r3,
      @EndUserText.label: 'Lead Time 3'
      Lead_time_r3,
      @EndUserText.label: 'Batch Qty 3'
      Batch_qty_r3
}
