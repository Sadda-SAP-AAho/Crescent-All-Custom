@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final view for proforma invoice table 1'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZV_PROFORMA_ITMFINAL 
    as select distinct from I_DeliveryDocument         as a
    left outer join       I_DeliveryDocumentItem       as b    on a.DeliveryDocument = b.DeliveryDocument
    left outer join       I_SalesDocumentItem          as s    on s.SalesDocument = b.ReferenceSDDocument
                                                               and s.SalesDocumentItem = b.ReferenceSDDocumentItem 
    left outer join       I_ProductPlantBasic          as c    on  c.Product = b.Product
                                                               and c.Plant   = b.Plant
    left outer join       ZI_MATFLD                    as m    on m.Product = b.Product

    left outer join       I_AE_CnsmpnTaxCtrlCodeTxt    as d    on  c.ConsumptionTaxCtrlCode = d.ConsumptionTaxCtrlCode
                                                               and d.Language               = 'E'
                                                               and d.CountryCode            = 'IN'
    left outer join       I_UnitOfMeasure              as e    on e.UnitOfMeasure = b.DeliveryQuantityUnit
    left outer join       ZCDS_RATE                    as h    on  h.DeliveryDocument     = b.DeliveryDocument
                                                               and h.DeliveryDocumentItem = b.DeliveryDocumentItem

    left outer join       I_SalesDocItemPricingElement as dis  on  dis.SalesDocument     = b.ReferenceSDDocument
                                                               and dis.SalesDocumentItem = b.ReferenceSDDocumentItem
                                                               and (
                                                                  dis.ConditionType      = 'ZK07'
                                                                  or dis.ConditionType   = 'ZK08'
                                                                  or dis.ConditionType   = 'D100'
                                                                )
    left outer join       I_SalesDocItemPricingElement as pack on  pack.SalesDocument     = b.ReferenceSDDocument
                                                               and pack.SalesDocumentItem = b.ReferenceSDDocumentItem
                                                               and (
                                                                  pack.ConditionType      = 'ZPFP'
                                                                  or pack.ConditionType   = 'ZPFV'
                                                                )
{

  key b.DeliveryDocument,
  key b.DeliveryDocumentItem,
      b.TransactionCurrency,
      b.Product,
//      b.DeliveryDocumentItemText,
      m.Matlngtxt as DeliveryDocumentItemText,
      s.PurchaseOrderByCustomer as PURCHASEORDERBYCUSTOMER,
      s.UnderlyingPurchaseOrderItem as PURCHASEORDERITEM,
      d.ConsumptionTaxCtrlCodeText1,
      c.ConsumptionTaxCtrlCode,
      e.UnitOfMeasure_E                                               as unit,
      b.DeliveryQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      ceil( cast( b.ActualDeliveryQuantity as abap.dec( 16,2 ) ))      as Qty,
      h.rate,
      dis.ConditionRateValue                                          as Disc,
      pack.ConditionRateValue                                         as Pack,
      cast((b.ActualDeliveryQuantity * h.rate )  as abap.dec(13,2) )  as amt
}

