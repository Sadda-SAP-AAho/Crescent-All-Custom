@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OTIF Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OTIF_REPORT_5
  as select distinct from ZI_SD_OTIF_REPORT
{
  key SalesOrder,
  key SalesOrderItem,
  key DeliveryDocument,
  key DeliveryDocumentItem,
      CreationDate,
      DocStatus,
      SoldToParty,
      Product,
      SalesOrderItemText,
      ProfitCenterName,
      ScheduleLineOrderQuantity,
      DeliveredQtyInOrderQtyUnit,
      OpenConfdDelivQtyInOrdQtyUnit,
      orderwt,
      openwt,
      PurchaseOrderByCustomer,
      CustomerPurchaseOrderDate,
      salesperson,
      YY1_CustomerRequiredDe_SDI,
      ConfirmedDeliveryDate,
      case when soholdstatus = 'Y' then cast( 0 as abap.int4 )
           when ConfirmedDeliveryDate >= systemdate then cast( 0 as abap.int4 )
           else cast( dats_days_between( ConfirmedDeliveryDate, systemdate  ) as abap.int4 ) end                                                                                                               as actdays,
      // else cast( dats_days_between( systemdate, ConfirmedDeliveryDate ) as abap.int4 ) end as actdays,
      cast( ( ( otiframt * OpenConfdDelivQtyInOrdQtyUnit ) + ( division( cast( ( otiframt1 * OpenConfdDelivQtyInOrdQtyUnit ) as abap.dec( 13, 2 ) ), ScheduleLineOrderQuantity , 3 ) ) ) as abap.dec( 23,2 ) ) as otiframt,
      YY1_ItemPaintInformati_SDI,
      Packinglist,
      Createdon,
      Salesnoteref,
      MatlWrhsStkQtyInMatlBaseUnit,
      soholdstatus,
      systemdate
}
