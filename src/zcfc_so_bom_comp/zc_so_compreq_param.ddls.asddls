@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_SO_CompReq_Param
  with parameters
    P_SO : abap.numc(10)
  as select from    I_SalesOrder             as so
    left outer join I_SalesOrderItem         as item  on so.SalesOrder = item.SalesOrder

    left outer join I_SalesOrderScheduleLine as sched on  sched.SalesOrder     = item.SalesOrder
                                                      and sched.SalesOrderItem = item.SalesOrderItem

  //    left outer join I_SalesOrderScheduleLine as sched1 on  sched1.SalesOrder                 = item.SalesOrder
  //                                                       and sched1.SalesOrderItem             = item.SalesOrderItem
  //                                                       and sched1.ConfirmedRqmtQtyInBaseUnit > 0

    left outer join ZCDS_OPENSODET1          as opso  on  opso.SalesOrder     = item.SalesOrder
                                                      and opso.SalesOrderItem = item.SalesOrderItem


{
  key so.SalesOrder                   as SalesOrderNo,
  key item.SalesOrderItem             as SORowNumber,
      so.CreationDate                 as SODate,
      so.RequestedDeliveryDate        as RequestedDelDate,
      so.SoldToParty                  as CustomerCode,

      item.Product                   as MaterialNo,
      item.SalesOrderItemText         as MaterialName,
      //      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      //      item.OrderQuantity       as SOOpenQty,
      item.OrderQuantityUnit,
      item.ProfitCenter               as ProfitCenterName,
      item.Plant                      as plant,

      //      old logic      //
      //      min(sched1.DeliveryDate)           as OurCommittedDelDate,

      //      new logic      //
      min(opso.CommittedDeliveryDate) as OurCommittedDelDate,
      //      sched.DeliveryDate       as OurCommittedDelDate,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      //      old logic      //
      //      sched.OpenReqdDelivQtyInOrdQtyUnit as SOOpenQty,

      //      new logic      //
      opso.balanceqty                 as SOOpenQty,

      sched.ScheduleLineCategory,
      so.OverallSDProcessStatus,
      item.SDProcessStatus


}
where
      so.OverallSDProcessStatus  <> 'C'
//  and item.SDProcessStatus       <> 'C'
  and sched.ScheduleLineCategory =  'CP'
  //  and sched.ConfirmedRqmtQtyInBaseUnit > 0
  
  //      old logic      //
  //  and sched.OpenReqdDelivQtyInOrdQtyUnit >  0
  
  //      new logic      //
  and opso.balanceqty            >  0
  
  and so.SalesOrder              = $parameters.P_SO

group by
  so.SalesOrder,
  item.SalesOrderItem,
  so.CreationDate,
  so.RequestedDeliveryDate,
  so.SoldToParty,
  item.Product,
  item.SalesOrderItemText,
  item.OrderQuantity,
  item.OrderQuantityUnit,
  item.ProfitCenter,
  item.Plant,
  so.OverallSDProcessStatus,
  item.SDProcessStatus,
  sched.ScheduleLineCategory,
  //  sched.OpenReqdDelivQtyInOrdQtyUnit
  opso.balanceqty
