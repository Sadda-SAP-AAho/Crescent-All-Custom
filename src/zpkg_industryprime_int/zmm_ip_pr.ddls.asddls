@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Indent/PR Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_IP_PR
  as select from    I_PurchaseRequisitionItemAPI01 as a
    inner join      I_PurchaseRequisitionAPI01     as a1 on(
      a1.PurchaseRequisition = a.PurchaseRequisition
    )
    inner join      I_Plant                        as b  on(
       b.Plant = a.Plant
     )
    inner join zdt_ip_matgrptmg as z on z.matkl =  a.MaterialGroup //added by SP on 17.04.24
    left outer join I_BusinessUserBasic            as c  on(
       c.UserID = a.CreatedByUser
     )
    left outer join I_ProductText                  as d  on(
       d.Product      = a.Material
       and d.Language = $session.system_language
     )
    left outer join I_ProductPlantBasic            as e  on(
       e.Product   = a.Material
       and e.Plant = a.Plant
     )
    left outer join I_Product                      as f  on(
       f.Product = a.Material
     )
    left outer join I_PurReqnAcctAssgmtAPI01       as g  on(
       g.PurchaseRequisition         = a.PurchaseRequisition
       and g.PurchaseRequisitionItem = a.PurchaseRequisitionItem
     )
    left outer join I_CostCenterText               as h  on(
       h.CostCenter          = g.CostCenter
       and h.ControllingArea = 'A000'
       and h.Language        = $session.system_language
     )
    left outer join I_UnitOfMeasure                as i  on(
       i.UnitOfMeasure = a.BaseUnit
     )
{
  key a1.PurchaseRequisition                                                        as doc_num,
  key a.PurchaseRequisitionItem                                                     as doc_num_item,
  key a.Plant                                                                       as warehousecode,
      a.CreationDate,
      a.CreationTime,
      cast( left( cast( a.LastChangeDateTime as abap.char(30) ),8 ) as abap.dats )  as LastChangeDate,
      tstmp_to_tims( cast( a.LastChangeDateTime as timestamp ),
                     abap_system_timezone( $session.client,'NULL' ),
                     $session.client,
                     'NULL' )                                                       as LastChangeTime,
      a.LastChangeDateTime,
      b._Customer.Customer                                                          as Customer,
      b._Customer.CustomerName                                                      as warehousename,
      b._Customer.BPAddrStreetName                                                  as warehousestreet,
      b._Customer.CityName                                                          as warehousecity,
      b._Customer.PostalCode                                                        as warehousezipcode,
      a.CreatedByUser                                                               as bycode,
      c.PersonFullName                                                              as byname,
      a.PurReqCreationDate                                                          as datesdoc,
      a.DeliveryDate                                                                as datesreq,
      a1.PurReqnDescription                                                         as remark,
      a.Material                                                                    as item_check,
      d.ProductName                                                                 as item_name,
      e.ConsumptionTaxCtrlCode                                                      as hsn,
      i.UnitOfMeasure_E                                                             as uom_i,
      a.BaseUnit                                                                    as uom_b,
      a.MaterialGroup                                                               as itemgroup_code,
      f._ProductGroupText_2[ Language = $session.system_language ].ProductGroupText as itemgroup_name,
      g.CostCenter                                                                  as costcentercode,
      h.CostCenterDescription                                                       as costcentername,
      @Semantics.quantity.unitOfMeasure: 'uom_b'
      a.RequestedQuantity                                                           as quantity,
      @Semantics.amount.currencyCode: 'Currency'
      a.PurchaseRequisitionPrice                                                    as price,
      a.PurReqnItemCurrency                                                         as Currency,
      a.PurchaseRequisitionItemText                                                 as description,
      a.IsDeleted                                                                   as deleted,
      a.IsClosed                                                                    as closed, //added by SP on 17.04.24
      case when a.ProcessingStatus = 'N' then '' else 'X' end                       as process
}
where
  (
       a.PurReqnReleaseStatus = '02'
    or a.PurReqnReleaseStatus = '05'
  )
  and a.PurReqnOrigin = 'R'
