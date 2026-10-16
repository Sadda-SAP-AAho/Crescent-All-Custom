@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Tax Invoice Item Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_PROINVITM as 
select from zi_taxhdr as i
left outer join I_BillingDocument as a on a.BillingDocument = i.Billingdoc
left outer join I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument
left outer join I_BillingDocumentItemPrcgElmnt as c on c.BillingDocument = b.BillingDocument
                                                    and c.BillingDocumentItem = b.BillingDocumentItem
                                                    and ( c.ConditionType = 'ZPR0' or c.ConditionType = 'ZPR1' )
left outer join I_BillingDocumentItemPrcgElmnt as l1 on l1.BillingDocument = b.BillingDocument
                                                    and l1.BillingDocumentItem = b.BillingDocumentItem
                                                    and l1.ConditionType = 'ZSPC'
left outer join I_BillingDocumentItemPrcgElmnt as d on d.BillingDocument = b.BillingDocument
                                                    and d.BillingDocumentItem = b.BillingDocumentItem
                                                    and ( d.ConditionType = 'ZK07' or d.ConditionType = 'ZK08'
                                                          or d.ConditionType = 'D100')
//left outer join I_BillingDocumentItemPrcgElmnt as e on e.BillingDocument = b.BillingDocument
//                                                    and e.BillingDocumentItem = b.BillingDocumentItem
//                                                    and e.ConditionType = 'JOIG'
//left outer join I_BillingDocumentItemPrcgElmnt as  m on m.BillingDocument = b.BillingDocument
//                                                    and m.BillingDocumentItem = b.BillingDocumentItem
//                                                    and ( m.ConditionType = 'ZTC1' or m.ConditionType = 'ZTC2')

left outer join I_BillingDocumentItemPrcgElmnt as f on f.BillingDocument = b.BillingDocument
                                                    and f.BillingDocumentItem = b.BillingDocumentItem
                                                    and 
                                                    ( //f.ConditionType = 'ZFIP' or f.ConditionType = 'ZFIV'
                                                     f.ConditionType = 'ZPFP' or f.ConditionType = 'ZPFV' )
                                                     //f.ConditionType = 'ZXIP' or f.ConditionType = 'ZXIV' )
left outer join ZI_MATFLD as mat_text on b.Material = mat_text.Product
//left outer join ZI_PACKLIST_ITM as g on g.Delivery = b.ReferenceSDDocument 
//                                        and g.Posnr = b.BillingDocumentItem and b.ReferenceSDDocumentCategory = 'J'
//left outer join I_SalesOrderItem   as h on h.SalesOrder = b.SalesDocument and b.SalesDocumentItem = h.SalesOrderItem
//                                                          and h.Product = b.Product
left outer join I_ProductPlantBasic as k on k.Product = b.Product and k.Plant = b.Plant 
left outer join I_AE_CnsmpnTaxCtrlCodeTxt as j on j.ConsumptionTaxCtrlCode = k.ConsumptionTaxCtrlCode
                                               and j.Language = 'E' and j.CountryCode = 'IN'
                                                    
 {
   key a.BillingDocument,
   key b.BillingDocumentItem,
       b.Material,
       mat_text.Matlngtxt as BillingDocumentItemText, 
//       b.BillingDocumentItemText,
//       @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
//       b.ItemNetWeight,
//       @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
//       sum(b.ItemNetWeight) as Totalnetweight,
       k.ConsumptionTaxCtrlCode,
       j.ConsumptionTaxCtrlCodeText1,
       @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
       b.BillingQuantity,
       b.BillingQuantityUnit,
       case when (l1.ConditionRateValue is initial or l1.ConditionRateValue is null)
       then c.ConditionRateValue
       else ( coalesce(c.ConditionRateValue,0) + coalesce(l1.ConditionRateValue,0) )
        end as rate,
       c.TransactionCurrency,
//      @Semantics.amount.currencyCode : 'TransactionCurrency'
//       m.ConditionAmount as tcs,
      @Semantics.amount.currencyCode : 'TransactionCurrency'
       d.ConditionAmount as discvalue,
//       e.ConditionRateValue as igstrate,
//      @Semantics.amount.currencyCode : 'TransactionCurrency'
//       e.ConditionAmount as igstamt,
     
//       c.ConditionRateValue * b.BillingQuantity as Totalvalue,
      @Semantics.amount.currencyCode : 'TransactionCurrency'
       f.ConditionAmount as packingfreight
//       @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
//       ceil( cast(g.Packqty as abap.dec(15,3 ) ) ) as pkg,
//       h.MaterialByCustomer as customermaterial      
       
}
group by a.BillingDocument,
   b.BillingDocumentItem,
   b.Material,
   b.BillingDocumentItemText,
   mat_text.Matlngtxt,
   k.ConsumptionTaxCtrlCode,
   j.ConsumptionTaxCtrlCodeText1,
   b.BillingQuantity,
   b.BillingQuantityUnit,
   c.ConditionRateValue,
   l1.ConditionRateValue,
   c.TransactionCurrency,
   d.ConditionAmount,
   f.ConditionAmount
        
