@AbapCatalog.sqlViewName: 'ZSV2PIXY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS For Proforma Invoice 3rd Table'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_PROINV_T4 as select from I_BillingDocument as a
            inner join I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument
            inner join            ZCDS_PRO_T4        as i on i.DeliveryDocument = b.ReferenceSDDocument
                                                     and i.DeliveryDocumentItem = b.ReferenceSDDocumentItem
            inner join            ZV_PRO_T3_N        as j on  j.DeliveryDocument     = b.ReferenceSDDocument
                                                     and j.DeliveryDocumentItem = b.ReferenceSDDocumentItem
            left outer join I_BillingDocumentItemPrcgElmnt as n on n.BillingDocument = b.BillingDocument
                                                    and n.BillingDocumentItem = b.BillingDocumentItem
                                                    and n.ConditionType = 'ZDDW'
{
    key a.BillingDocument,
    i.ConsumptionTaxCtrlCodeText1,
    i.ConsumptionTaxCtrlCode,
    sum(j.netwt) as snw,
    n.ConditionRateValue as lf,
    sum(i.Qty)  as sqty
}
where
  b.ReferenceSDDocumentCategory = 'J' and a.BillingDocumentType = 'F8'
group by
    a.BillingDocument, 
    i.ConsumptionTaxCtrlCodeText1,
    i.ConsumptionTaxCtrlCode,
    n.ConditionRateValue
  
