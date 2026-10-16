@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Register - Packing List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_SALESREGPACKLIST
  as select from zdt_packlist_itm as a

    inner join   zdt_packlist_hdr as b on  b.id     = a.id
                                       and b.canind = ''
{
  key a.delivery     as Delivery,
  key a.posnr        as Posnr,
      a.wtunit,
      @Semantics.quantity.unitOfMeasure: 'wtunit'
      sum( a.growt ) as Growt
}

group by
  a.delivery,
  a.posnr,
  a.wtunit
