@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_SALESMATERIALSTOCK

  as select from I_MaterialStock_2 as a

    inner join   I_ProductText     as b on  b.Product  = a.Material
                                        and b.Language = $session.system_language

    inner join   I_Product         as c on c.Product = a.Material

{

  key a.Material,
  key a.Plant,
      b.ProductName,
      a.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( a.MatlStkIncrQtyInMatlBaseUnit ) as IncreaseStock,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( a.MatlStkDecrQtyInMatlBaseUnit ) as DecreaseStock

}

where
      c.ProductType =    'ZFG'
  and a.Plant       =    '1200'
  and a.Material    like 'MCB%'

group by
  a.Material,
  a.Plant,
  b.ProductName,
  a.MaterialBaseUnit
