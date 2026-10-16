@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Dashboard Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_DELDASHDATA
  as select distinct from ZI_SALESREGSHRT as a
    inner join            ZI_DELDASH_HDR  as b on  a.OutboundDeliveryNo =  b.Delivery
                                               and b.Canind             <> 'X'
{
  key a.OutboundDeliveryNo,
      b.Etadt,
      b.Atadt,
      b.Contdisfact,
      b.Condockindt
}
