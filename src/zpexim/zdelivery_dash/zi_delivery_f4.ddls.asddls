@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Delivery Packing List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DELIVERY_F4 
as select distinct from  //zdt_deldash_hdr as a
// inner join 
I_DeliveryDocument as b // on b.DeliveryDocument = a.delivery
left outer join I_Customer as c on c.Customer = b.SoldToParty
{
    key b.DeliveryDocument as DeliveryDocument,
    key b.DeliveryDate,
    key b.SoldToParty,
    key c.CustomerFullName
}
//where a.canind <> 'X'
group by
b.DeliveryDocument,
b.DeliveryDate,
b.SoldToParty,
c.CustomerFullName

