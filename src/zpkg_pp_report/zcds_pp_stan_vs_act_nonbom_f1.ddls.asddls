@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_STAN_VS_ACT_NONBOM_F1
  as select from ZCDS_PP_NONBOM_RPT_3 //ZCDS_PP_STAN_VS_ACT_NONBOM_F
{
  key PostingDate,
  key Plant,
  key CostCenter,
      //    key CostCenterDescription,
  key Material,
  key GLAccount,
  key consbase                                               as conbase,
      ProductName                                            as ProductDescription,
      MaterialGroup,
      MaterialGroupName,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      QuantityInBaseUnit                                     as lmqty,
      MaterialBaseUnit1                                      as MaterialBaseUnit,
      GLAccountLongName,
      // @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      conqty,
      MaterialBaseUnit                                       as MaterialBaseUnit1,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      actissue                                               as issqty,
      MaterialBaseUnit                                       as MaterialBaseUnit2,
      @Semantics.amount.currencyCode: 'Currency'
      actissval,
      currency,
      stdissue,
      lastpurprice,
      cast( ( lastpurprice * stdissue ) as abap.dec(23, 2) ) as stdissueval
}


