@AbapCatalog.sqlViewName: 'ZV_DUTY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for duty drawback table'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_TABLE4_N  as select distinct from I_DeliveryDocument           as a
    inner join            I_DeliveryDocumentItem       as b on a.DeliveryDocument = b.DeliveryDocument
    inner join            ZCDS_PROFORMA_T4             as i on i.DeliveryDocument = b.DeliveryDocument
                                                            and i.DeliveryDocumentItem = b.DeliveryDocumentItem
//    left outer join       ZV_PROFORMA_ITM              as i on  i.DeliveryDocument     = b.DeliveryDocument
//                                                            and i.DeliveryDocumentItem = b.DeliveryDocumentItem
    left outer join       I_SalesDocItemPricingElement as n on  n.SalesDocument      = b.ReferenceSDDocument
                                                            and n.SalesDocumentItem  = b.ReferenceSDDocumentItem
                                                            and n.ConditionType      = 'ZDDW'
                                                            and n.SDDocumentCategory = 'C'
{
  key a.DeliveryDocument,
  key b.DeliveryDocumentItem,
      i.ConsumptionTaxCtrlCodeText1,
      i.ConsumptionTaxCtrlCode,
      i.snw as snw,
      n.ConditionRateValue as lf,
      i.Qty          as sqty
}
