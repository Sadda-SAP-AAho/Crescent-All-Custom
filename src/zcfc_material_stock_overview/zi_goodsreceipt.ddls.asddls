@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Goods Receipt Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_GOODSRECEIPT
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
      sum ( a.MatlStkChangeQtyInBaseUnit )  as GoodsReceiptQty,
      a.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum ( a.GoodsMovementStkAmtInCCCrcy ) as GoodsReceiptValue
}

where
      a.GoodsMovementType = '101'
  and a.PostingDate       between $parameters.p_date_low and $parameters.p_date_high

group by
  a.Material,
  a.Plant,
  a.StorageLocation,
  a.MaterialBaseUnit,
  a.CompanyCodeCurrency
