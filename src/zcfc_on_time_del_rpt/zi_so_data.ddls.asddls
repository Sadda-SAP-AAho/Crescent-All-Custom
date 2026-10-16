@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_SO_DATA

  as select distinct from I_SalesOrder          as a

    inner join            I_SalesOrderItem      as b  on  a.SalesOrder               =  b.SalesOrder
                                                      and a.SDDocumentReason         <> 'Z07'
                                                      and b.AdditionalMaterialGroup2 is initial
                                                      
    inner join            ZCDS_SCHEDULINE1      as b1 on  b1.SalesOrder     = b.SalesOrder
                                                      and b1.SalesOrderItem = b.SalesOrderItem
                                                      and b1.soholdstat     = 'NO'

    left outer join       I_SalesDocumentItem   as c  on  c.SalesDocument     = b.SalesOrder
                                                      and c.SalesDocumentItem = b.SalesOrderItem

    left outer join       I_CustomerSalesArea   as d  on a.SoldToParty = d.Customer

    left outer join       ztmg_salesgrp         as e  on  e.salesgroup            = d.SalesGroup
                                                      and e.configdeprecationcode is initial
                                                      and d.SalesGroup            is not null

    left outer join       I_ProductPlantBasic   as g  on  g.Product = b.Product
                                                      and g.Plant   = b.Plant

    left outer join       I_Product             as h  on h.Product = b.Product

    left outer join       I_SalesDocument       as i  on i.SalesDocument = c.SalesDocument

    left outer join       zdt_pp_matinffld      as j  on j.product = b.Product

    left outer join       ZCDS_REJECTION_REASON as l  on  l.SalesDocument     = b.SalesOrder
                                                      and l.SalesDocumentItem = b.SalesOrderItem

{
  key a.SalesOrder,

  key b.SalesOrderItem,

      a.CreationDate                                 as sodate,

      (case when c.YY1_CustomerRequiredDe_SDI <> '00000000'
            then c.YY1_CustomerRequiredDe_SDI
            else '' end )                            as custreqdeldate,

      ( case when b.YY1_OTIFDate_SDI is initial and b.CommittedDeliveryDate is not initial
             then b.CommittedDeliveryDate

             when b.YY1_OTIFDate_SDI is initial and b.CommittedDeliveryDate is initial
             then b.RequestedDeliveryDate

             else b.YY1_OTIFDate_SDI end )           as CommittedDeliveryDate,

      a.SoldToParty                                  as CustCode,

      e.salesperson                                  as SalesPerson,

      b.Plant,

      j.moc                                          as MOC,

      b.Product                                      as Material,

      ( case when ( j.product = b.Product and j.matlngtxt is initial ) then b.SalesOrderItemText
             when ( j.product = b.Product and j.matlngtxt is not initial ) then j.matlngtxt
             else b.SalesOrderItemText end )         as MaterialDesc,

      g.ConsumptionTaxCtrlCode                       as HSNCode,

      b.OrderQuantityUnit                            as UOM,

      h.WeightUnit,

      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      h.NetWeight,

      b.OrderQuantityUnit,

      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      b.OrderQuantity,

      ( cast(b.OrderQuantity as abap.dec(13,0))  *
               cast(h.NetWeight as abap.dec(13,3)) ) as OrderWt,
      b1.soholdstat,
      e.salesperson                                  as SP,
      a.SDDocumentReason,
      l.SalesDocumentRjcnReasonName                  as RejectionRsn,
      b.AdditionalMaterialGroup2

}

where
  l.SalesDocumentRjcnReasonName is null
