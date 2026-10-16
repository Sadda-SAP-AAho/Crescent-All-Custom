@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Final Comm columns'
define view entity ZVFINALCOMDATA
  as select distinct from I_BillingDocumentItem          as a
    left outer join       I_BillingDocument              as f on f.BillingDocument = a.BillingDocument
     left outer join       I_UnitOfMeasure            as s on s.UnitOfMeasure = a.BillingQuantityUnit
    left outer join       I_SalesOrderItem               as z on  z.SalesOrder         = a.SalesDocument
                                                              and z.SalesOrderItem     = a.SalesDocumentItem
                                                              and (a.SalesSDDocumentCategory = 'C'
                                                                   or a.SalesSDDocumentCategory = 'H')
    left outer join       I_ProductPlantBasic            as b on  a.Material = b.Product
                                                              and a.Plant    = b.Plant
    left outer join       I_AE_CnsmpnTaxCtrlCodeTxt      as c on  b.ConsumptionTaxCtrlCode = c.ConsumptionTaxCtrlCode
                                                              and c.CountryCode            = 'IN'
                                                              and c.Language               = 'E'
    left outer join       I_BillingDocItemPrcgElmntBasic as d on  d.BillingDocument     = a.BillingDocument
                                                              and d.BillingDocumentItem = a.BillingDocumentItem
                                                              and (
                                                                 d.ConditionType        = 'ZPR0'
                                                                 or d.ConditionType     = 'ZPR1'
                                                               )
   left outer join       I_BillingDocItemPrcgElmntBasic as e on  e.BillingDocument     = a.BillingDocument
                                                              and e.BillingDocumentItem = a.BillingDocumentItem
                                                              and (
                                                                 e.ConditionType        = 'ZK07'
                                                                 or e.ConditionType     = 'ZK08'
                                                                 or e.ConditionType     = 'D100'
                                                               )
   left outer join I_BillingDocumentItemPrcgElmnt as h on  h.BillingDocument     = a.BillingDocument
                                                        and h.BillingDocumentItem = a.BillingDocumentItem
                                                        and (
                                                           h.ConditionType        = 'ZFIP'
                                                           or h.ConditionType     = 'ZFIV'
                                                           //  or f.ConditionType = 'ZPFP' or f.ConditionType = 'ZPFV'
                                                           or h.ConditionType     = 'ZXIP'
                                                           or h.ConditionType     = 'ZXIV'
                                                         )
                                                              
   left outer join I_BillingDocumentItemPrcgElmnt as i on  i.BillingDocument     = a.BillingDocument
                                                        and i.BillingDocumentItem = a.BillingDocumentItem
                                                        and (
                                                              i.ConditionType     = 'ZPFV'
                                                           or i.ConditionType     = 'ZPFP'
                                                          
                                                         )
  //left outer join I_CUSTOMERMATERIAL as e on e.Customer = a.SoldToParty and a.Material = e.Material
    left outer join       I_SalesOrderItem               as g on  g.SalesOrder = a.SalesDocument
                                                              and g.SalesOrderItem = a.SalesDocumentItem
                                                              and g.Material   = a.Material
  //++logic change as per email dated 02/07/2025 @AM
    left outer join      I_Customer                      as lc on lc.Customer = a.SoldToParty
    left outer join I_BillingDocumentItemPrcgElmnt as tarrif on  tarrif.BillingDocument     = a.BillingDocument
                                                        and tarrif.BillingDocumentItem = a.BillingDocumentItem
                                                        and (
                                                              tarrif.ConditionType     = 'ZXIP'
                                                           or tarrif.ConditionType     = 'ZXIV'
                                                         )
  //--logic change as per email dated 02/07/2025 @AM                                                           
{
  key a.BillingDocument,
  key a.BillingDocumentItem,
      a.Material,
      a.BillingDocumentItemText,
      s.UnitOfMeasure_E as BillingQuantityUnit,
      g.OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      ceil( cast(  a.BillingQuantity as abap.dec( 16,2 ) ) )  as BillingQuantity,
      a.TransactionCurrency,
      c.ConsumptionTaxCtrlCodeText1,
      b.ConsumptionTaxCtrlCode,
      //++logic change as per email dated 02/07/2025 @AM
//      case when lc.Country = 'US'                                     "Commented by Akash on 19th June 2026 Requested by @Surajit Dey
//      then cast( (coalesce(d.ConditionRateValue,0) - ( ( coalesce( cast(tarrif.ConditionAmount as abap.dec(13,2) ),0) ) * -1 ) / cast(a.BillingQuantity as abap.dec(13,2) ) ) as abap.dec(13,2) )
//      else //pervious logic
//      cast( (d.ConditionRateValue) as abap.dec(13,2) )                     end as ConditionRateValue,
 cast( (d.ConditionRateValue) as abap.dec(13,2) )  as ConditionRateValue, 
 
      //--logic change as per email dated 02/07/2025 @AM
      //      e.MaterialByCustomer,
      z.PurchaseOrderByCustomer,
      z.CustomerPurchaseOrderDate,
      f.BillingDocumentDate,
      ltrim(g.UnderlyingPurchaseOrderItem,'0')                               as UnderlyingPurchaseOrderItem,
      g.PurchaseOrderByShipToParty,
      g.MaterialByCustomer,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      
//      case when lc.Country = 'US'                              "Commented by Akash on 19th June 2026 Requested by @Surajit Dey
//      then cast( (cast( (coalesce(d.ConditionRateValue,0) - ( ( coalesce( cast(tarrif.ConditionAmount as abap.dec(13,2) ),0) ) * -1 ) / cast(a.BillingQuantity as abap.dec(13,2) ) ) as abap.dec(13,2) ) * a.BillingQuantity ) as abap.dec(23,2) )
//      else
//      cast((d.ConditionRateValue * a.BillingQuantity ) as abap.dec(23,2) ) end as amount,

 cast((d.ConditionRateValue * a.BillingQuantity ) as abap.dec(23,2) ) as amount,
 
      //++logic change as per email dated 02/07/2025 @AM
      @Semantics.amount.currencyCode : 'TransactionCurrency'
//      case when lc.Country = 'US'                                 "Commented by Akash on 19th June 2026 Requested by @Surajit Dey
//      then cast( (tarrif.ConditionAmount) as abap.dec(13,2) )
//      else
//      ////cast( (h.ConditionAmount) as abap.dec(13,2) )
//      cast( 0 as abap.dec(13,2) ) 
//      end as freightamt,

 cast( 0 as abap.dec(13,2) ) as freightamt,                        
      //--logic change as per email dated 02/07/2025 @AM
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      cast( (i.ConditionAmount) as abap.dec(13,2) ) as  packingamt,
       @Semantics.amount.currencyCode : 'TransactionCurrency'
      cast( (e.ConditionAmount) as abap.dec(13,2) ) as  discamt


}
where
  a.BillingDocumentType = 'F2'
group by
  a.BillingDocument,
  a.BillingDocumentItem,
  a.Material,
  a.BillingDocumentItemText,
  s.UnitOfMeasure_E,
  g.OrderQuantityUnit,
  a.BillingQuantity,
  a.TransactionCurrency,
  c.ConsumptionTaxCtrlCodeText1,
  b.ConsumptionTaxCtrlCode,
  d.ConditionRateValue,
  h.ConditionAmount,
  i.ConditionAmount,
  e.ConditionAmount,
  //      e.MaterialByCustomer,
  z.PurchaseOrderByCustomer,
  z.CustomerPurchaseOrderDate,
  f.BillingDocumentDate,
  g.MaterialByCustomer,
  g.UnderlyingPurchaseOrderItem,
  g.PurchaseOrderByShipToParty,
  tarrif.ConditionAmount,
  lc.Country
