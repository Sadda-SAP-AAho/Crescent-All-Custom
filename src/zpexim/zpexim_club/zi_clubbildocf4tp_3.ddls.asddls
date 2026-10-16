@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exim Delivery Club F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CLUBBILDOCF4TP_3
  as select from I_DeliveryDocumentItem
  association [1..1] to I_DeliveryDocument as _DeliveryDocument on $projection.DeliveryDocument = _DeliveryDocument.DeliveryDocument
{
  key DeliveryDocument,
  key DeliveryDocumentItem,
      concat( DeliveryDocument, DeliveryDocumentItem ) as DeliveryCombo,
      Material, //Product,
      //      BillingDocumentItemText,
      Plant,
      Batch,
      _DeliveryDocument.SalesOffice                    as SalesOffice,
      _DeliveryDocument.SalesOrganization              as SalesOrganization,
      _DeliveryDocument.DistrChnlForIntcoBilling       as DistributionChannel,
      _DeliveryDocument.DivisionForIntcoBilling        as Division,
      //      HSNSAC,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      ActualDeliveryQuantity,
      DeliveryQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      ItemGrossWeight,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      ItemNetWeight,
      ItemWeightUnit,
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      ''                                               as NetAmount,
      TransactionCurrency,
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      //      division( NetAmount, BillingQuantity, 2 )      as UnitPrice,
      //      ''                                               as UnitPrice,

      _DeliveryDocument

}

where
  ActualDeliveryQuantity <> 0
