@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for contractwise report'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_CONTRACT_ITM
  as select distinct from zdt_contract_itm as c
    association to parent ZI_CONTRACT_HDR as _head on $projection.cont     = _head.Cont
//                                                   $projection.shpflrdt = _head.Shpflrdt
                                                   and $projection.plant    = _head.Plant
                                                   and $projection.dept     = _head.Dept
                                                   and $projection.opr      = _head.Opr




{

  key c.opr,
  key c.plant,
  key c.dept,
  key c.cont,
  key c.matnr,
      c.itemname,
      c.weightunit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      c.netweight as NetWeight,
      c.materialbaseunit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      c.day1qty as Day1qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      c.day2qty as Day2qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      c.day3qty as Day3qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      c.day4qty as Day4qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      c.day5qty as Day5qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      c.day6qty as Day6qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      c.day7qty as Day7qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      c.totalperdayqty as TotalPerDayQty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      c.qtyinkg as Qtyinkg,
      c.activity1    as activity1,
      c.activity2    as activity2,
      c.activity3    as activity3,
      c.activity4    as activity4,
      c.activity1amt as activity1amt,
      c.activity2amt as activity2amt,
      c.activity3amt as activity3amt,
      c.activity4amt as activity4amt,
      c.totalamt     as totalamt,
      _head
}
