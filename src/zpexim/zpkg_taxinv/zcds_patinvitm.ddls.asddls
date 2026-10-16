@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Pattern Invoice Item Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_PATINVITM
  as select from    zi_taxhdr                      as i
    left outer join I_BillingDocument              as a on a.BillingDocument = i.Billingdoc
    left outer join I_BillingDocumentItem          as b on a.BillingDocument = b.BillingDocument
    left outer join I_SalesOrderItem               as c on  c.SalesOrder        = b.SalesDocument
                                                        and b.SalesDocumentItem = c.SalesOrderItem
                                                        and c.Product           = b.Product
    left outer join I_BillingDocumentItemPrcgElmnt as d on  d.BillingDocument     = b.BillingDocument
                                                        and d.BillingDocumentItem = b.BillingDocumentItem
                                                        and ( d.ConditionType = 'JOIG' or d.ConditionType = 'ZOIG')
    left outer join ZI_MATFLD                      as e on e.Product = c.Material
    left outer join I_BillingDocumentItemPrcgElmnt as f on  f.BillingDocument     = b.BillingDocument
                                                        and f.BillingDocumentItem = b.BillingDocumentItem
                                                        and f.ConditionType = 'JOCG'
    left outer join I_BillingDocumentItemPrcgElmnt as g on  g.BillingDocument     = b.BillingDocument
                                                        and g.BillingDocumentItem = b.BillingDocumentItem
                                                        and g.ConditionType = 'JOSG' 
{
  key a.BillingDocument,
  key b.BillingDocumentItem,
      c.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      b.NetAmount,
      a.PurchaseOrderByCustomer,
      e.Artno,
      e.Drawno,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      d.ConditionAmount as IGSTamt,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      f.ConditionAmount as CGSTamt,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      g.ConditionAmount as SGSTamt
                                                                                               
}
group by
  a.BillingDocument,
  b.BillingDocumentItem,
  c.TransactionCurrency,
  b.NetAmount,
  a.PurchaseOrderByCustomer,
  e.Artno,
  e.Drawno,
  d.ConditionAmount,   
  f.ConditionAmount,
  g.ConditionAmount
