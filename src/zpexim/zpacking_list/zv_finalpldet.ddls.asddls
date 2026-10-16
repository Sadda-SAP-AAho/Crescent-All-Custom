@AbapCatalog.sqlViewName: 'ZV_FINALPACKDET'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final PL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view  ZV_FINALPLDET as 
select distinct from zi_finalpack_hdr as a 
inner join zi_finalpack_itm  as b on b.Id = a.Id               
{
    key b.Delivery,
    key b.Posnr,
        b.Priority,
        b.Wtunit,
        b.Meins,
        b.Packmattyp,
        sum(b.Mateachpkg) as mateachpkg,
        sum(b.Eachgrowt) as eachgrowt,
        sum(b.Eachnetwt) as eachnetwt,
        sum(b.Qty)       as qty,
        sum(b.Packqty) as packqty,
        sum(b.Netwt)   as netwt,
        sum(b.Growt)   as growt
}
where a.Canind <> 'X'
group by 
b.Delivery,
b.Posnr,
b.Priority,
b.Wtunit,
b.Meins,
b.Packmattyp
