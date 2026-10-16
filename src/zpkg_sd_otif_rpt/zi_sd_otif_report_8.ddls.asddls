@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OTIF Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OTIF_REPORT_8
  as select from ZI_SD_OTIF_REPORT_7    as a
    inner join   ZI_PACKLIST_HDR        as b on  b.Delivery  =  a.Delivery
                                             and b.Createdon =  a.Createdon
                                             and b.Canind    <> 'X'
    inner join   ZI_PACKLIST_ITM        as d on b.Id = d.Id
    inner join   I_DeliveryDocumentItem as c on  c.DeliveryDocument     = a.Delivery
                                             and c.DeliveryDocumentItem = d.Posnr
    inner join   I_DeliveryDocument     as e on e.DeliveryDocument = a.Delivery
{
  c.ReferenceSDDocument,
  c.ReferenceSDDocumentItem,
  a.Createdon,
  max( b.Packinglist ) as Packinglist
}
where
  e.ActualGoodsMovementDate is initial
group by
  c.ReferenceSDDocument,
  c.ReferenceSDDocumentItem,
  a.Createdon
