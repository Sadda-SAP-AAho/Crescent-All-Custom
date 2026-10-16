@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item View 3'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_ITEMVIEW2
  as select distinct from ZI_ITEMVIEW1 as a
    inner join            ZI_ITEMVIEW  as b on  a.shpflrdt = b.shpflrdt
                                            and a.cont     = b.cont
                                            and a.opr      = b.opr
                                            and a.plant    = b.plant
                                            and a.dept     = b.dept
                                            and a.matnr    = b.matnr
{

  key a.shpflrdt,
  key a.cont,
  key a.opr,
  key a.plant,
  key a.dept,
  key b.matnr,
      b.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      b.NetWeight,
      b.ProductDescription,
      b.contname,
//      b.prodord,
      a.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.Day1qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.Day2qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.Day3qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.Day4qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.Day5qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.Day6qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.Day7qty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.TotalPerDayQty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.Qtyinkg
}
