@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO-wise Component Requirement'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SO_COMPREQ
  as select distinct from I_SalesOrder             as a
    left outer join       I_SalesOrderItem         as b on a.SalesOrder = b.SalesOrder

    left outer join       I_SalesOrderScheduleLine as c on  c.SalesOrder     = b.SalesOrder
                                                        and c.SalesOrderItem = b.SalesOrderItem

    left outer join       ZCDS_OPENSODET1          as d on  d.SalesOrder     = b.SalesOrder
                                                        and d.SalesOrderItem = b.SalesOrderItem


{
  key a.SalesOrder                 as SalesOrderNo,
  key b.SalesOrderItem             as SORowNumber,
      a.CreationDate               as SODate,
      a.RequestedDeliveryDate      as RequestedDelDate,
      a.SoldToParty                as CustomerCode,
      b.Product                    as MaterialNo,
      b.SalesOrderItemText         as MaterialName,
      b.OrderQuantityUnit,
      b.ProfitCenter               as ProfitCenterName,
      b.Plant                      as plant,
      min(d.CommittedDeliveryDate) as OurCommittedDelDate,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      d.balanceqty                 as SOOpenQty,
      c.ScheduleLineCategory,
      a.OverallSDProcessStatus,
      b.SDProcessStatus


}
where
      a.OverallSDProcessStatus <> 'C'
  and c.ScheduleLineCategory   =  'CP'
  and d.balanceqty             >  0


group by
  a.SalesOrder,
  b.SalesOrderItem,
  a.CreationDate,
  a.RequestedDeliveryDate,
  a.SoldToParty,
  b.Product,
  b.SalesOrderItemText,
  b.OrderQuantity,
  b.OrderQuantityUnit,
  b.ProfitCenter,
  b.Plant,
  a.OverallSDProcessStatus,
  b.SDProcessStatus,
  c.ScheduleLineCategory,
  d.balanceqty
