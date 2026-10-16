@AbapCatalog.sqlViewName: 'ZRATE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for rate in proforma invoice'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_RATE 
as select distinct  from I_DeliveryDocument as a
left outer join I_DeliveryDocumentItem as b on a.DeliveryDocument = b.DeliveryDocument
left outer join I_SalesDocItemPricingElement as c on c.SalesDocument = b.ReferenceSDDocument
                                                and c.SalesDocumentItem = b.ReferenceSDDocumentItem
                                                and c.SDDocumentCategory = 'C'
{
  key b.DeliveryDocument,
  key b.DeliveryDocumentItem,
      c.TransactionCurrency,
  cast(sum(c.ConditionRateValue) as abap.dec(23,2) ) as rate
}
where (c.ConditionType = 'ZPR0' or c.ConditionType = 'ZPR1' or c.ConditionType = 'ZSPC')
group by b.DeliveryDocument,
         b.DeliveryDocumentItem,
         c.TransactionCurrency
