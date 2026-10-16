@EndUserText.label: 'View for Custom Sales Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_CUSTSAMPLE_ITM as
select from zi_taxhdr as i
left outer join I_BillingDocument as a on a.BillingDocument = i.Billingdoc
left outer join I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument
left outer join I_BillingDocumentItemPrcgElmnt as c on c.BillingDocument = b.BillingDocument
                                                    and c.BillingDocumentItem = b.BillingDocumentItem
                                                    and ( c.ConditionType = 'ZPR0' or c.ConditionType = 'ZPR1'
                                                          or c.ConditionType = 'ZSPC' )
left outer join I_BillingDocumentItemPrcgElmnt as d on d.BillingDocument = b.BillingDocument
                                                    and d.BillingDocumentItem = b.BillingDocumentItem
                                                    and ( d.ConditionType = 'ZK07' or d.ConditionType = 'ZK08'
                                                          or d.ConditionType = 'D100' )

left outer join I_BillingDocumentItemPrcgElmnt as f on f.BillingDocument = b.BillingDocument
                                                    and f.BillingDocumentItem = b.BillingDocumentItem
                                                    and 
                                                    ( //f.ConditionType = 'ZFIP' or f.ConditionType = 'ZFIV'
                                                     f.ConditionType = 'ZPFP' or f.ConditionType = 'ZPFV' )
                                                     //f.ConditionType = 'ZXIP' or f.ConditionType = 'ZXIV' )
//left outer join ZI_PACKLIST_ITM as g on g.Delivery = b.ReferenceSDDocument 
//                                        and g.Posnr = b.BillingDocumentItem and b.ReferenceSDDocumentCategory = 'J'
left outer join I_SalesOrderItem   as h on h.SalesOrder = b.SalesDocument and b.SalesDocumentItem = h.SalesOrderItem
                                                          and h.Product = b.Product
left outer join I_ProductPlantBasic as k on k.Product = b.Product and k.Plant = b.Plant 
left outer join I_AE_CnsmpnTaxCtrlCodeTxt as j on j.ConsumptionTaxCtrlCode = k.ConsumptionTaxCtrlCode
                                               and j.Language = 'E' and j.CountryCode = 'IN'
                                                    
 {
   key a.BillingDocument,
   key b.BillingDocumentItem,
       b.Material,
       b.BillingDocumentItemText,
       @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
       b.ItemNetWeight,
       k.ConsumptionTaxCtrlCode,
       j.ConsumptionTaxCtrlCodeText1,
       @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
       ceil( cast( b.BillingQuantity as abap.dec( 16,2 ) ) )  as BillingQuantity,
       b.BillingQuantityUnit,
       c.ConditionRateValue,
       a.AccountingExchangeRate,
       ( c.ConditionRateValue * a.AccountingExchangeRate ) as rate,
       c.TransactionCurrency,
      @Semantics.amount.currencyCode : 'TransactionCurrency'
       d.ConditionAmount as discvalue,
      @Semantics.amount.currencyCode : 'TransactionCurrency'
       f.ConditionAmount as packingfreight,
//       @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
//       ceil( cast(g.Packqty as abap.dec(15,3 ) ) ) as pkg,
       h.MaterialByCustomer as customermaterial      
       
}
group by a.BillingDocument,
   b.BillingDocumentItem,
   b.Material,
   b.BillingDocumentItemText,
   b.ItemNetWeight,
   k.ConsumptionTaxCtrlCode,
   j.ConsumptionTaxCtrlCodeText1,
   b.BillingQuantity,
   b.BillingQuantityUnit,
   a.AccountingExchangeRate,
   c.ConditionRateValue,
   c.TransactionCurrency,
   d.ConditionAmount,
   f.ConditionAmount,
   h.MaterialByCustomer
        
