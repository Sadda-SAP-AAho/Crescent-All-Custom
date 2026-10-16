@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View For SC/SO Report'
@Metadata.allowExtensions: true
define view entity ZC_SCSO_RECD_RPT
  with parameters
    p_date_low  : zde_date,
    p_date_high : zde_date
  as select from ZSD_SCSO_RECD_RPT(
                 p_date_low  : $parameters.p_date_low,
                 p_date_high : $parameters.p_date_high
                 )



{
  key SalesDocument,
  key    doc_type,

  key    SalesDocumentItem,
      SalesDocumentDate,
      SoldToParty,
      TransactionCurrency,
      BankIdentification,
      Plant,
      salesperson,
      Material,
      SalesDocumentItemText,
      MaterialGroup,
      ProductGroupName,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      OrderQuantity,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      TargetQuantity,
      BaseUnit,
      ConditionType,
      unit_price,
      total_price,
      PriceDetnExchangeRate,
      total_price_inr,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      ItemGrossWeight,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      ItemNetWeight,
      ItemWeightUnit,
      ProfitCenter,
      ProfitCenterLongName
}
