@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Packing List Item'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_PACKLIST_ITM
  as select from zdt_packlist_itm
  association to parent ZI_PACKLIST_HDR as _Head on $projection.Id = _Head.Id
{
  key zdt_packlist_itm.id          as Id,
  key zdt_packlist_itm.item        as Item,
      zdt_packlist_itm.packinglist as Packinglist,
      zdt_packlist_itm.delivery    as Delivery,
      zdt_packlist_itm.posnr       as Posnr,
      zdt_packlist_itm.plant       as Plant,
      zdt_packlist_itm.matnr       as Matnr,
      zdt_packlist_itm.maktx       as Maktx,
      zdt_packlist_itm.meins       as Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_packlist_itm.qty         as Qty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_packlist_itm.packqty     as Packqty,
      zdt_packlist_itm.priority    as Priority,
      zdt_packlist_itm.packmat     as Packmat,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      zdt_packlist_itm.packmatnwt  as Packmatnwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      zdt_packlist_itm.matnetwt    as Matnetwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      zdt_packlist_itm.eachnetwt   as Eachnetwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      zdt_packlist_itm.eachgrowt   as Eachgrowt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      zdt_packlist_itm.netwt       as Netwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      zdt_packlist_itm.growt       as Growt,
      wtunit                       as Wtunit,
      packmattyp                   as Packmattyp,
      @Semantics.quantity.unitOfMeasure : 'meins'
      mateachpkg                   as Mateachpkg,
      copy                         as Copy,
      _Head // Make association public
}
