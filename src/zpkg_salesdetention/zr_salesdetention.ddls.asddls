@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Detention'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZR_SALESDETENTION

  as select from ZV_SALESDETENTION_V1
{
  key ARInvNo,
  key DeliveryDocument,
      CreationDate,
      CreationTime,
      CustomerCode,
      PackingList,
      ContainerNickName,
      DeliveryDate,
      ContainerNo,
      ContainerPickupValidityDate,
      ContainerActualPickupDate,
      ContainerActualPickupWeekDay,
      ContainerFactoryInDate,
      ContainerFactoryOutDate,
      CartingOrderAppDate,
      CartingOrderRecDate,
      ContainerDockInDate,
      ContainerCutoffDate,
      GateOpenDate,
      TransporterName,
      Forwarder,
      ShippingLine,
      TrxnCurrency,
      ExchangeRate,
      ContainerSize,
      PlantName,
      Plant,
      MOC,
      Truckholdingdays,
      Truckdetentionamount,
      Factorydetentiondays,
      Factorydetentionamount,
      Docdetentiondays,
      Docdetentionamount
}
