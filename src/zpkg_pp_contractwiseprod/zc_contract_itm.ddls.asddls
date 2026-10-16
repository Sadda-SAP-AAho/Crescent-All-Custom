@EndUserText.label: 'Contractor Wise Production Report Item'
@Metadata.ignorePropagatedAnnotations: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #XXL,
    dataClass: #TRANSACTIONAL
}
define view entity ZC_CONTRACT_ITM
  as projection on ZI_CONTRACT_ITM
{
//      @Search.defaultSearchElement: true
//      @EndUserText.label: 'Posting Date'
//  key shpflrdt,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Operation No.'
  key opr,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Plant'
  key plant,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Department'
  key dept,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Contractor'
  key cont,
      @EndUserText.label: 'Item No.'
  key matnr,
      @EndUserText.label: 'Item Name'
      itemname,
      @Search.defaultSearchElement: true
      weightunit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      @EndUserText.label: 'Product Net Weight'
      NetWeight,
      @Search.defaultSearchElement: true
      materialbaseunit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label: 'GR qty Day1'
      Day1qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label: 'GR qty Day2'
      Day2qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label: 'GR qty Day3'
      Day3qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label: 'GR qty Day4'
      Day4qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label: 'GR qty Day5'
      Day5qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label: 'GR qty Day6'
      Day6qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label: 'GR qty Day7'
      Day7qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label: 'Total Production Qty'
      TotalPerDayQty,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      @EndUserText.label: 'Qty (In KG)'
      Qtyinkg,
      @EndUserText.label: 'Activity 1'
      activity1,
      @EndUserText.label: 'Activity 2'
      activity2,
      @EndUserText.label: 'Activity 3'
      activity3,
      @EndUserText.label: 'Activity 4'
      activity4,
      @EndUserText.label: 'Activity 1 Amt'
      activity1amt,
      @EndUserText.label: 'Activity 2 Amt'
      activity2amt,
      @EndUserText.label: 'Activity 3 Amt'
      activity3amt,
      @EndUserText.label: 'Activity 4 Amt'
      activity4amt,
      @EndUserText.label: 'Total Amount'
      totalamt,
      /* Associations */
      _head : redirected to parent ZC_CONTRACT_HDR
}
