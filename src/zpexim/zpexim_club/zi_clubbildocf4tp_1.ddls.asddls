@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EXIM Clubbing Doc Type F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CLUBBILDOCF4TP_1

  as select distinct from ZI_CLUBBILDOCF4TP
{

  key BillingDocument,
  key BillingDocumentItem,
      concat( BillingDocument, BillingDocumentItem ) as BillingCombo,
      Product,
      BillingDocumentItemText,
      Plant,
      Batch,
      SalesOffice,
      SalesOrganization,
      DistributionChannel,
      Division,
      HSNSAC,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      BillingQuantity,
      BillingQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      ItemGrossWeight,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      ItemNetWeight,
      ItemWeightUnit,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      NetAmount,
      TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      division( NetAmount, BillingQuantity, 2 )      as UnitPrice

}

where
      BillingQuantity <> 0
  and UsageIndicator  =  ''
