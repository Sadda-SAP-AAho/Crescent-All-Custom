@AbapCatalog.sqlViewName: 'ZSV1PI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS For Proforma Invoice 3rd Table'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_PROINV_T3
  as select distinct from I_BillingDocument     as a
    inner join            I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument
//    inner join            ZV_DELDASHPRNT_ITM    as i on  i.DeliveryDocument     = b.ReferenceSDDocument
//                                                     and i.DeliveryDocumentItem = b.ReferenceSDDocumentItem
    inner join            ZV_PRO_T3_N           as i on i.DeliveryDocument = b.ReferenceSDDocument
                                                     and i.DeliveryDocumentItem = b.ReferenceSDDocumentItem
    inner join            ZV_PRO_T3             as j on  j.DeliveryDocument     = b.ReferenceSDDocument
                                                     and j.DeliveryDocumentItem = b.ReferenceSDDocumentItem
  //     inner join ZV_DELDASHHDR as j on j.DeliveryDocument = i.DeliveryDocument
{
  key a.BillingDocument,
      i.ConsumptionTaxCtrlCode,
      i.ConsumptionTaxCtrlCodeText1,
      sum(i.netwt) as snw,
      sum(j.amt)   as totamt
//      sum(i.amt)   as totamt
}
where
  b.ReferenceSDDocumentCategory = 'J' and a.BillingDocumentType = 'F8'
group by
  a.BillingDocument,
  i.ConsumptionTaxCtrlCode,
  i.ConsumptionTaxCtrlCodeText1

