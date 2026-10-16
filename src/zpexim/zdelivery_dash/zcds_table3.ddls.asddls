@AbapCatalog.sqlViewName: 'ZSV2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS For Proforma Invoice 3rd Table'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_TABLE3
  as select distinct from I_DeliveryDocument     as a
    inner join            I_DeliveryDocumentItem as b on a.DeliveryDocument = b.DeliveryDocument
    inner join            ZV_PROFORMA_ITM        as i on  i.DeliveryDocument     = b.DeliveryDocument
                                                      and i.DeliveryDocumentItem = b.DeliveryDocumentItem
{
  key a.DeliveryDocument,
      i.ConsumptionTaxCtrlCode,
      i.ConsumptionTaxCtrlCodeText1,
      sum(i.Netwt) as snw,
      sum(i.amt)   as totamt
}

group by
  a.DeliveryDocument,
  i.ConsumptionTaxCtrlCode,
  i.ConsumptionTaxCtrlCodeText1
