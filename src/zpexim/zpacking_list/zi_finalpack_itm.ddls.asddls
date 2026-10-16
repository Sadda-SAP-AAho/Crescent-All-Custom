@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Views for Final Packing List Item'
define view entity zi_finalpack_itm
  as select from zdt_finlpack_itm
  association to parent zi_finalpack_hdr as _Head on $projection.Id = _Head.Id
{
  key zdt_finlpack_itm.id          as Id,
  key zdt_finlpack_itm.item        as Item,
      zdt_finlpack_itm.packinglist as Packinglist,
      zdt_finlpack_itm.comm_inv    as comm_inv,
      zdt_finlpack_itm.delivery    as Delivery,
      zdt_finlpack_itm.posnr       as Posnr,
      zdt_finlpack_itm.plant       as Plant,
      zdt_finlpack_itm.matnr       as Matnr,
      zdt_finlpack_itm.maktx       as Maktx,
      zdt_finlpack_itm.meins       as Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_finlpack_itm.qty         as Qty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_finlpack_itm.packqty     as Packqty,
      zdt_finlpack_itm.priority    as Priority,
      zdt_finlpack_itm.packmat     as Packmat,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      zdt_finlpack_itm.packmatnwt  as Packmatnwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      zdt_finlpack_itm.matnetwt    as Matnetwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      zdt_finlpack_itm.eachnetwt   as Eachnetwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      zdt_finlpack_itm.eachgrowt   as Eachgrowt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      zdt_finlpack_itm.netwt       as Netwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      zdt_finlpack_itm.growt       as Growt,
      wtunit                       as Wtunit,
      packmattyp                   as Packmattyp,
      @Semantics.quantity.unitOfMeasure : 'meins'
      mateachpkg                   as Mateachpkg,
      unitfob                      as Unitfob,
      copy                         as Copy,
      _Head // Make association public

}
