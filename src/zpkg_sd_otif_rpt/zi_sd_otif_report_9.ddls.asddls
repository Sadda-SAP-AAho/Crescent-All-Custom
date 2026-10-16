@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Note ref'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OTIF_REPORT_9
  as select from ZI_DELDASH_HDR         as a
    inner join   ZI_DELDASH_ITM         as d on  d.Id = a.Id
    inner join   I_DeliveryDocumentItem as c on  c.DeliveryDocument     = a.Delivery
                                             and c.DeliveryDocumentItem = d.Posnr
    inner join   I_DeliveryDocument     as e on  e.DeliveryDocument = a.Delivery
{
  c.ReferenceSDDocument,
  c.ReferenceSDDocumentItem,
  max( a.Delivery ) as Delivery

}
where
      a.Canind                  <> 'X'
  and a.Salesnoteref            is not initial
  and e.ActualGoodsMovementDate is initial
group by
  c.ReferenceSDDocument,
  c.ReferenceSDDocumentItem
