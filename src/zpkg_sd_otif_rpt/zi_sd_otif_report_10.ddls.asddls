@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Note ref'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OTIF_REPORT_10 
as select from ZI_SD_OTIF_REPORT_9 as a
inner join ZI_DELDASH_HDR as b on a.Delivery = b.Delivery  
{
    key a.ReferenceSDDocument,
    key a.ReferenceSDDocumentItem,
    key a.Delivery,
    b.Salesnoteref
}
where b.Canind <> 'X'
group by
a.ReferenceSDDocument,
a.ReferenceSDDocumentItem,
a.Delivery,
b.Salesnoteref
