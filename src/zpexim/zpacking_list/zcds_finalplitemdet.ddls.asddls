@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for final packinglist item '
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_FINALPLITEMDET
  as select distinct from I_BillingDocument              as a
    left outer join       I_BillingDocumentItem          as f on f.BillingDocument = a.BillingDocument
    left outer join       I_UnitOfMeasure                as e on e.UnitOfMeasure = f.BillingQuantityUnit
    left outer join       I_SalesOrderItem               as z on  z.SalesOrder         = f.SalesDocument
                                                              and z.SalesOrderItem     = f.SalesDocumentItem
                                                              and (f.SalesSDDocumentCategory = 'C'
                                                                   or f.SalesSDDocumentCategory = 'H')
    left outer join       ZI_DELDASH_HDR                 as j on  j.Delivery                    = f.ReferenceSDDocument
                                                              and f.ReferenceSDDocumentCategory = 'J'
                                                              and j.Canind <> 'X'
    left outer join       I_ProductPlantBasic            as b on  f.Material = b.Product
                                                              and f.Plant    = b.Plant
    left outer join       I_AE_CnsmpnTaxCtrlCodeTxt      as c on  b.ConsumptionTaxCtrlCode = c.ConsumptionTaxCtrlCode
                                                              and c.CountryCode            = 'IN'
                                                              and c.Language               = 'E'
    left outer join       I_BillingDocItemPrcgElmntBasic as d on  d.BillingDocument     = a.BillingDocument
                                                              and d.BillingDocumentItem = f.BillingDocumentItem
                                                              and (
                                                                 d.ConditionType        = 'ZPR0'
                                                                 or d.ConditionType     = 'ZPR1'
                                                                 or d.ConditionType     = 'ZSPC'
                                                               )
  //left outer join I_CUSTOMERMATERIAL as e on e.Customer = a.SoldToParty and a.Material = e.Material
    left outer join       I_SalesOrderItem               as g on  g.SalesOrder = f.SalesDocument
                                                              and g.SalesOrderItem = f.SalesDocumentItem
                                                              and g.Material   = f.Material
//    left outer join       zi_finalpack_hdr               as h on h.Packinglist = a.BillingDocument
//    left outer join       zi_finalpack_itm               as k on  k.Id     =  h.Id
//                                                              and k.Delivery = f.ReferenceSDDocument
//                                                              and k.Posnr  =  f.ReferenceSDDocumentItem
//                                                              and h.Status <> 'CANCELED'
    left outer join      ZV_FINALPLDET                    as  k on k.Delivery = f.ReferenceSDDocument
                                                                and k.Posnr  =  f.ReferenceSDDocumentItem  


{
  key a.BillingDocument,
  key f.BillingDocumentItem,
      k.Priority,
      f.Material,
      f.BillingDocumentItemText,
      e.UnitOfMeasure_E as BillingQuantityUnit,
      @Semantics.quantity.unitOfMeasure : 'meins'
      ceil( cast( f.BillingQuantity as abap.dec( 16,2 ) ))     as BillingQuantity,
      a.TransactionCurrency,
      c.ConsumptionTaxCtrlCodeText1,
      b.ConsumptionTaxCtrlCode,
      cast( (d.ConditionRateValue) as abap.dec(13,2) ) as ConditionRateValue,
      //      e.MaterialByCustomer,
      z.PurchaseOrderByCustomer,
      z.CustomerPurchaseOrderDate,
      g.AdditionalMaterialGroup1,
      f.BillingDocumentDate,
      ltrim(g.UnderlyingPurchaseOrderItem,'0')         as UnderlyingPurchaseOrderItem,
      g.PurchaseOrderByShipToParty,
      g.MaterialByCustomer,
      //    @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
      //    cast( ( d.ConditionRateValue * a.BillingQuantity ) as abap.dec(13,2) ) as amount,
      k.Wtunit,
      @Semantics.quantity.unitOfMeasure : 'meins'
      ceil( cast( k.packqty as abap.dec( 16,2 ) ))     as Packqty,


      k.Packmattyp,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      k.eachnetwt,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      k.eachgrowt,
      @Semantics.quantity.unitOfMeasure : 'meins'
      ceil( cast( k.qty as abap.dec( 16,2 ) ) )        as Qty,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      k.netwt,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      k.growt,
      @Semantics.quantity.unitOfMeasure : 'meins'
      k.mateachpkg,
      k.Meins,
      j.Contno



}
where
  a.BillingDocumentType = 'F2' 
// and h.Canind <> 'X' 
group by
  a.BillingDocument,
  f.BillingDocumentItem,
  k.Priority,
  f.Material,
  f.BillingDocumentItemText,
  e.UnitOfMeasure_E ,
  f.BillingQuantity,
  a.TransactionCurrency,
  c.ConsumptionTaxCtrlCodeText1,
  b.ConsumptionTaxCtrlCode,
  d.ConditionRateValue,
  z.PurchaseOrderByCustomer,
   z.CustomerPurchaseOrderDate,
    g.AdditionalMaterialGroup1,
  f.BillingDocumentDate,
  g.UnderlyingPurchaseOrderItem,
  g.PurchaseOrderByShipToParty,
  g.MaterialByCustomer,
  k.Wtunit,
  k.packqty,
  k.Packmattyp,
  k.eachnetwt,
  k.eachgrowt,
  k.qty,
  k.netwt,
  k.growt,
  k.mateachpkg,
  k.Meins,
  j.Contno
