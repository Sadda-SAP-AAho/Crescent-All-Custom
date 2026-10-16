@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Open SO Report Details'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_OPENSODET
  as select distinct from I_SalesOrder                   as a
    left outer join       I_SalesOrderItem               as b   on a.SalesOrder = b.SalesOrder
    left outer join       I_ProfitCenterText             as y   on  y.ProfitCenter = b.ProfitCenter
                                                                and y.Language     = 'E'
    left outer join       I_SalesDocument                as c   on c.SalesDocument = b.SalesOrder
    left outer join       I_SalesDocumentItem            as w   on  w.SalesDocument               = b.SalesOrder
                                                                and w.SalesDocumentItem           = b.SalesOrderItem
                                                                and w.ReferenceSDDocumentCategory = 'G'
    left outer join       I_SalesContract                as f   on f.SalesContract = w.ReferenceSDDocument
    left outer join       I_Plant                        as z   on  z.Plant    = b.Plant
                                                                and z.Language = 'E'
    left outer join       I_ProductPlantBasic            as g   on  g.Product = b.Product
                                                                and g.Plant   = b.Plant
    left outer join       I_Product                      as h   on h.Product = b.Product
    left outer join       I_AdditionalMaterialGroup1Text as i   on  i.AdditionalMaterialGroup1 = b.AdditionalMaterialGroup1
                                                                and i.Language                 = 'E'
    left outer join       I_Customer                     as j   on  j.Customer = a.SoldToParty
                                                                and j.Language = 'E'
    left outer join       I_SalesGroupText               as k   on  k.SalesGroup = a.SalesGroup
                                                                and k.Language   = 'E'
    left outer join       ZCDS_BALANCEVAL                as m   on  m.SalesDocument     = b.SalesOrder
                                                                and m.SalesDocumentItem = b.SalesOrderItem
    left outer join       I_SalesDocItemPricingElement   as n   on  n.SalesDocument     = b.SalesOrder
                                                                and n.SalesDocumentItem = b.SalesOrderItem
                                                                and (
                                                                   n.ConditionType      = 'ZPR0'
                                                                   or n.ConditionType   = 'ZPR1'
                                                                 )
  //    left outer join       ZCDS_SCHEDLINE                                as o  on  o.SalesOrder     = b.SalesOrder
  //                                                                              and o.SalesOrderItem = b.SalesOrderItem
    left outer join       ZCDS_SCHEDULINE1               as o   on  o.SalesOrder     = b.SalesOrder
                                                                and o.SalesOrderItem = b.SalesOrderItem

    left outer join       I_CustomerPaymentTermsText     as p   on  p.CustomerPaymentTerms = a.CustomerPaymentTerms
                                                                and p.Language             = 'E'
    left outer join       zdt_mcod_tmg                   as r   on r.codcode = c.YY1_CountryofDestinat_SDH
    left outer join       ZI_FD_F4                       as s   on s.value_low = c.YY1_FinalDestination_SDH
    left outer join       zdt_mpod_tmg                   as t   on t.podcode = c.YY1_PortofDischarge1_SDH
    left outer join       zdt_mpol_tmg                   as u   on u.polcode = c.YY1_PortOfLoading1_SDH
    left outer join       I_SalesDocItemPricingElement   as x   on  x.SalesDocument     = b.SalesOrder
                                                                and x.SalesDocumentItem = b.SalesOrderItem
                                                                and (
                                                                   x.ConditionType      = 'ZXIV'
                                                                   or x.ConditionType   = 'ZXIP'
                                                                 )


    left outer join       zdt_matdesc                    as q   on  q.salesorder     = b.SalesOrder
                                                                and q.salesorderitem = b.SalesOrderItem
    left outer join       I_SDDocumentReasonText         as z2  on  z2.SDDocumentReason = a.SDDocumentReason
                                                                and z2.Language         = 'E'
    left outer join       zdt_pp_matinffld               as z3  on z3.product = b.Product
    left outer join       ZCDS_MATERIALSTOCK             as z4  on  z4.Material = b.Material
                                                                and z4.Plant    = b.Plant
    left outer join       ZCDS_PACKLIST                  as z5  on  z5.ReferenceSDDocument     = b.SalesOrder
                                                                and z5.ReferenceSDDocumentItem = b.SalesOrderItem
    left outer join       ZCDS_REJECTION_REASON          as z6  on  z6.SalesDocument     = b.SalesOrder
                                                                and z6.SalesDocumentItem = b.SalesOrderItem
    left outer join       I_SalesDocumentItem            as z7  on  z7.SalesDocument     = b.SalesOrder
                                                                and z7.SalesDocumentItem = b.SalesOrderItem

    left outer join       ZTBL_FCTN_BOM_ITEMS            as z8  on  b.Product = z8.material
                                                                and b.Plant   = z8.plant
    left outer join       I_AdditionalMaterialGroup2Text as z9  on  b.AdditionalMaterialGroup2 = z9.AdditionalMaterialGroup2
                                                                and z9.Language                = 'E'
    left outer join       I_BusinessUserBasic            as z10 on z10.UserID = a.CreatedByUser

    left outer join       I_CustomerSalesArea            as z11 on a.SoldToParty = z11.Customer
    left outer join       ztmg_salesgrp                  as v   on  v.salesgroup            = z11.SalesGroup
                                                                and v.configdeprecationcode is initial

{
  key a.SalesOrder,
  key b.SalesOrderItem,
      //  key o.ScheduleLine,
      a.CreationDate                                                                             as salesdate,
      a.CreationDate                                                                             as CreationDate,
      z10.PersonFullName                                                                         as Createdby,
      a.LastChangeDate                                                                           as UpdateDate,
      a.RequestedDeliveryDate                                                                    as reqdeldate,
      w.ReferenceSDDocument                                                                      as SalesContract,
      a.SoldToParty,
      a.TransactionCurrency,
      a.PriceDetnExchangeRate                                                                    as exchrate,
      p.CustomerPaymentTermsName,
      a.IncotermsClassification,
      z.PlantName,
      b.PurchaseOrderByCustomer,
      b.CustomerPurchaseOrderDate,
      //      b.CommittedDeliveryDate,
      //      ( case when b.YY1_OTIFDate_SDI is initial then b.CommittedDeliveryDate
      //             else b.YY1_OTIFDate_SDI end )                                                       as CommittedDeliveryDate,
      ( case when b.YY1_OTIFDate_SDI is initial
             then ( case when b.CommittedDeliveryDate is initial
                         then $session.system_date
                         else b.CommittedDeliveryDate end )
             else b.YY1_OTIFDate_SDI end )                                                       as CommittedDeliveryDate,
      
      b.UnderlyingPurchaseOrderItem,
      b.Product,
      b.Plant,
      ---old logic---
      //b.SalesOrderItemText,
      ---new logic---
      ( case when ( z3.product = b.Product and z3.matlngtxt is initial ) then b.SalesOrderItemText
             when ( z3.product = b.Product and z3.matlngtxt is not initial ) then z3.matlngtxt
             else b.SalesOrderItemText end )                                                     as SalesOrderItemText,
      b.MaterialByCustomer,
      ( case when ( b.Product = z8.material and b.Plant   = z8.plant) then 'YES' else 'NO' end ) as BOM_Item,
      b.OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      b.OrderQuantity,
      y.ProfitCenterName                                                                         as ProfitCenter,
      cast(concat(concat(concat(substring(z7.YY1_CustomerRequiredDe_SDI  ,7,2),'/'),
       concat(substring(z7.YY1_CustomerRequiredDe_SDI  ,5,2),'/' ) ),
       substring(z7.YY1_CustomerRequiredDe_SDI  ,1,4)) as abap.char(10) )                        as custreqdeldate,
      r.codcodenam                                                                               as YY1_CountryofDestinat_SDH,
      s.text                                                                                     as YY1_FinalDestination_SDH,
      t.podcodename                                                                              as YY1_PortofDischarge1_SDH,
      u.polcodename                                                                              as YY1_PortOfLoading1_SDH,
      c.SalesOrganization,
      c.DistributionChannel,
      j.CustomerName,
      v.salesperson                                                                              as SalesPersonName,
      g.ConsumptionTaxCtrlCode,
      h.WeightUnit,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      h.NetWeight,
      cast(m.unitprice as abap.dec(13,2))                                                        as unitprice,
      //      o.salesorderweight,
      i.AdditionalMaterialGroup1Name,
      case n.ConditionType
      when 'ZPR1' then 'Fixed Price'
      when 'ZPR0' then 'Price List'
      end                                                                                        as pricetype,
      f.CreationDate                                                                             as contractdate,
      case c.SalesDocApprovalStatus
      when 'B' then 'YES'
      when ' ' then 'YES'
      else 'NO'
      end                                                                                        as holdstatus,
      z9.AdditionalMaterialGroup2Name                                                            as HoldbyMakt,
      cast(x.ConditionRateValue * (-1) as abap.dec(13,2))                                        as contfreight,
      z3.paintinfo                                                                               as materialpaintinfo,
      o.soholdstat,
      z2.SDDocumentReasonText,
      z3.moc,
      z3.ptnapp,
      z3.pilotprdapp,
      z4.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      z4.stockqty,
      z5.packinglist,
      cast(concat(concat(concat(substring(z5.Createdon  ,7,2),'/'),
      concat(substring(z5.Createdon ,5,2),'/' ) ),
      substring(z5.Createdon  ,1,4)) as abap.char(10) )                                          as Createdon,
      z5.Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      ceil( cast( z5.qtysum as abap.dec( 16,2 ) ) )                                              as qtysum,
      z6.SalesDocumentRjcnReasonName,
      ( cast(b.OrderQuantity as abap.dec(13,0))  *
               cast(h.NetWeight as abap.dec(13,3)) )                                             as salesorderweight,
      b.YY1_OTIFDate_SDI                                                                         as OTIF_Date,
      c.YY1_POEntryMailRecdDat_SDH,
      c.YY1_SOTransferMailRecd_SDH,
      (case
       when g.SpecialProcurementType = '40' then '1100'
        else b.Plant
        end)                                                                                     as production_plant

}
