@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Goods Issue Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_GOODSISSUE
  with parameters
    p_date_low  : zde_date,
    p_date_high : zde_date

  as select distinct from I_GoodsMovementCube as a
{
  key a.Material,
  key a.Plant,
  key a.StorageLocation,
      a.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum ( a.MatlStkChangeQtyInBaseUnit )  as GoodsIssueQty,
      a.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum ( a.GoodsMovementStkAmtInCCCrcy ) as GoodsIssueValue
}

where
      a.GoodsMovementType = '261'
  and a.PostingDate       between $parameters.p_date_low and $parameters.p_date_high

group by
  a.Material,
  a.Plant,
  a.StorageLocation,
  a.MaterialBaseUnit,
  a.CompanyCodeCurrency
