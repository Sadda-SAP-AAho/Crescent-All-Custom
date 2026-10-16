@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OTIF Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OTIF_REPORT_FIN
  as select distinct from ZI_SD_OTIF_REPORT_5            as a
    left outer join       I_SalesOrderItemPricingElement as b on  b.SalesOrder        = a.SalesOrder
                                                              and b.SalesOrderItem    = a.SalesOrderItem
    //                                                   and b.ConditionType = 'ZPR0'
                                                              and (
                                                                 b.ConditionType      = 'ZPR0'
                                                                 or b.ConditionType   = 'ZPR1'
                                                               )
                                                              and b.ConditionQuantity is not initial
{
  key a.SalesOrder,
  key a.SalesOrderItem,
      //key ScheduleLine,
  key a.DeliveryDocument,
  key a.DeliveryDocumentItem,
      a.CreationDate,
      a.DocStatus,
      a.SoldToParty,
      a.Product,
      a.SalesOrderItemText,
      a.ProfitCenterName,
      a.ScheduleLineOrderQuantity,
      a.DeliveredQtyInOrderQtyUnit,
      a.OpenConfdDelivQtyInOrdQtyUnit,
      a.orderwt,
      a.openwt,
      a.PurchaseOrderByCustomer,
      a.CustomerPurchaseOrderDate,
      a.salesperson,
      a.YY1_CustomerRequiredDe_SDI,
      a.ConfirmedDeliveryDate,
      a.actdays,
      case when a.soholdstatus = 'Y' then cast( 0 as abap.dec( 23,3 ) )
           when a.openwt is initial then cast( 0 as abap.dec( 23,3 ) )
           when b.ConditionQuantity <> 0 then
           ( division( division( cast( ( a.otiframt * a.actdays ) as abap.dec( 23, 3 ) ),cast( ( 10000000 ) as abap.dec( 23,3 ) ), 3  ),cast( ( b.ConditionQuantity ) as abap.dec( 23,3 ) ), 3  ) ) end  as otifamt,
      //else ( division( a.otiframt, cast( ( a.openwt ) as abap.dec( 23,2 ) ), 2 ) ) end as otifamt,
      a.YY1_ItemPaintInformati_SDI,
      a.Packinglist,
      a.Createdon,
      a.Salesnoteref,
      a.MatlWrhsStkQtyInMatlBaseUnit,
      a.soholdstatus,

      case when a.soholdstatus = 'Y' then cast( 0 as abap.dec( 23,3 ) )
           when a.openwt is initial then cast( 0 as abap.dec( 23,3 ) )
           when b.ConditionQuantity <> 0 then
           ( division( division( cast( ( a.otiframt * a.actdays ) as abap.dec( 23, 3 ) ), cast( ( 10000000 ) as abap.dec( 23, 3 ) ), 3 ),cast( ( b.ConditionQuantity ) as abap.dec( 23,3 ) ), 3  ) ) end as finotifamt
      //else ( division( a.otiframt, cast( ( a.openwt ) as abap.dec( 23,2 ) ), 2 ) ) end as finotifamt
}
where
  a.OpenConfdDelivQtyInOrdQtyUnit is not initial
