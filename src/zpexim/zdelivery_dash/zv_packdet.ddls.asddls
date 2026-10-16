@AbapCatalog.sqlViewName: 'Z_PACK'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for pl details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view  ZV_PACKDET as 
select distinct from ZI_PACKLIST_HDR as a 
inner join ZI_PACKLIST_ITM  as b on b.Id = a.Id               
{
    key a.Delivery,
    key b.Posnr,
        b.Wtunit,
        b.Meins,
        b.Packmattyp,
        sum(b.Packqty) as packqty,
        sum(b.Netwt)   as netwt,
        sum(b.Growt)   as growt
}
where a.Canind <> 'X'
group by 
a.Delivery,
b.Posnr,
b.Wtunit,
b.Meins,
b.Packmattyp
