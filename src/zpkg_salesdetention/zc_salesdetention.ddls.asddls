@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Detention'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_SALESDETENTION

  provider contract transactional_query

  as projection on ZR_SALESDETENTION
{
        @EndUserText.label: 'AR Invoice Number'
        @Search.defaultSearchElement: true
  key   ARInvNo,
        @EndUserText.label: 'Delivery Document'
  key   DeliveryDocument,
        @EndUserText.label: 'Creation Date'
        CreationDate,
        @EndUserText.label: 'Creation Time'
        CreationTime,
        @EndUserText.label: 'Customer Code'
        CustomerCode,
        @EndUserText.label: 'Packing List No.'
        PackingList,
        @EndUserText.label: 'Container Nick Name'
        ContainerNickName,
        @EndUserText.label: 'Delivery Date'
        DeliveryDate,
        @EndUserText.label: 'Container No.'
        ContainerNo,
        @EndUserText.label: 'Container Pickup Validty Date'
        ContainerPickupValidityDate,
        @EndUserText.label: 'Container Actual Pickup Date'
        ContainerActualPickupDate,
        @EndUserText.label: 'Container Pickup WeekDay'
        ContainerActualPickupWeekDay,
        @EndUserText.label: 'Container Factory In Date'
        ContainerFactoryInDate,
        @EndUserText.label: 'Container Factory Out Date'
        ContainerFactoryOutDate,
        @EndUserText.label: 'Carting Order Applied On'
        CartingOrderAppDate,
        @EndUserText.label: 'Carting Order Recd. On'
        CartingOrderRecDate,
        @EndUserText.label: 'Container Dock In Date'
        ContainerDockInDate,
        @EndUserText.label: 'Container Cut Off Date'
        ContainerCutoffDate,
        @EndUserText.label: 'Gate Open Date'
        GateOpenDate,
        @EndUserText.label: 'Transporter Name'
        TransporterName,
        @EndUserText.label: 'Forwarder'
        Forwarder,
        @EndUserText.label: 'Shipping Line'
        ShippingLine,
        @EndUserText.label: 'Currency'
        TrxnCurrency,
        @EndUserText.label: 'Exchange Rate'
        ExchangeRate,
        @EndUserText.label: 'Container Size'
        ContainerSize,
        @EndUserText.label: 'Plant Name'
        PlantName,
        @EndUserText.label: 'Plant Code'
        Plant,
        @EndUserText.label: 'MOC'
        MOC,
        @EndUserText.label: 'Truck Holding Days'
        Truckholdingdays,
        @EndUserText.label: 'Truck Holding Detention Amount'
        Truckdetentionamount,
        @EndUserText.label: 'Factory Detention Days'
        Factorydetentiondays,
        @EndUserText.label: 'Factory Detention Amount'
        Factorydetentionamount,
        @EndUserText.label: 'Document Transport Detention No of Days'
        Docdetentiondays,
        @EndUserText.label: 'Document Transport Detention'
        Docdetentionamount
}
