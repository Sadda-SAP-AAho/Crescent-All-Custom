@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'contractwise report item final details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_CONTRACT_ITMFINAL
  as select from ZI_CONTRACT_ITM
//  association to parent ZI_CONTRACT_HDR as _head on  $projection.shpflrdt = _head.Shpflrdt
//                                                 and $projection.cont     = _head.Cont
//                                                 and $projection.plant    = _head.Plant
//                                                 and $projection.dept     = _head.Dept
//                                                 and $projection.opr      = _head.Opr
{
  key opr,
  key plant,
  key dept,
  key cont,
  key matnr,
      itemname as ProductDescription,
      weightunit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      NetWeight,
      materialbaseunit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(Day1qty)        as Day1qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(Day2qty)        as Day2qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(Day3qty)        as Day3qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(Day4qty)        as Day4qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(Day5qty)        as Day5qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(Day6qty)        as Day6qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(Day7qty)        as Day7qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(TotalPerDayQty) as TotalPerDayQty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(Qtyinkg)        as Qtyinkg,
      activity1,
      activity2,
      activity3,
      activity4,
      activity1amt,
      activity2amt,
      activity3amt,
      activity4amt,
      totalamt
      /* Associations */
//      _head
}
group by
  opr,
  plant,
  dept,
  cont,
  matnr,
  itemname,
  weightunit,
  NetWeight,
  materialbaseunit,
  activity1,
  activity2,
  activity3,
  activity4,
  activity1amt,
  activity2amt,
  activity3amt,
  activity4amt,
  totalamt
