@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OTIF Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OTIF_REPORT_1 
as select from ZI_FI_DEBTOR_RPT_4 as a
inner join I_SalesOrderScheduleLine as b on b.SalesOrder = a.SalesOrder and b.SalesOrderItem = a.SalesOrderItem 
                                        and b.ScheduleLine = a.ScheduleLine
{
    key a.SalesOrder,
    key a.SalesOrderItem,
//    cast( b.ScheduleLineOrderQuantity as abap.dec( 13, 3 ) )     as ScheduleLineOrderQuantity,
//    cast( b.DeliveredQtyInOrderQtyUnit as abap.dec( 13, 3 ) )    as DeliveredQtyInOrderQtyUnit,
//    cast( b.OpenConfdDelivQtyInOrdQtyUnit as abap.dec( 13, 3 ) ) as OpenConfdDelivQtyInOrdQtyUnit,
    b.ConfirmedDeliveryDate,
    b.ScheduleLineCategory
        
}
// where b.OpenConfdDelivQtyInOrdQtyUnit <> 0
