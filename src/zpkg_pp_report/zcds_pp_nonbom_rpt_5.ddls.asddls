@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_NONBOM_RPT_5
  as select from ZCDS_PP_NONBOM_RPT_4
{
  key PostingDate,
  key Material,
  key Plant,
  key consbase,
  key CostCenter,
  key GLAccount,
  key typeofmould,
      ProductName,
      MaterialGroup,
      MaterialGroupName,
      GLAccountLongName,
      qtyperbox,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( actissue ) as actissue,
      MaterialBaseUnit1,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      QuantityInBaseUnit,
      conqty,
      @Semantics.amount.currencyCode: 'currency'
      sum( actissval ) as actissval,
      currency
}
group by
  PostingDate,
  Material,
  Plant,
  consbase,
  CostCenter,
  GLAccount,
  typeofmould,
  ProductName,
  MaterialGroup,
  MaterialGroupName,
  GLAccountLongName,
  qtyperbox,
  MaterialBaseUnit,
  MaterialBaseUnit1,
  QuantityInBaseUnit,
  conqty,
  currency
