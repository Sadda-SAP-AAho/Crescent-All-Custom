@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item View 2'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_ITEMVIEW1
  as select from ZI_ITEMVIEW
{

  key shpflrdt,
  key cont,
  key opr,
  key plant,
  key dept,
  key matnr,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast(sum(Day1qty) as abap.dec(30,3) )        as Day1qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast(sum(Day2qty) as  abap.dec(30,3) )       as Day2qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast(sum(Day3qty) as abap.dec(30,3) )        as Day3qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast(sum(Day4qty) as abap.dec(30,3) )        as Day4qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast(sum(Day5qty) as abap.dec(30,3) )        as Day5qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast(sum(Day6qty) as abap.dec(30,3) )        as Day6qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast(sum(Day7qty) as abap.dec(30,3) )        as Day7qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast(sum(TotalPerDayQty) as abap.dec(30,3) ) as TotalPerDayQty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast(sum(Qtyinkg) as abap.dec(30,3) )        as Qtyinkg
}
where
  MaterialBaseUnit is not initial
group by
  shpflrdt,
  cont,
  opr,
  plant,
  dept,
  matnr,
  MaterialBaseUnit
