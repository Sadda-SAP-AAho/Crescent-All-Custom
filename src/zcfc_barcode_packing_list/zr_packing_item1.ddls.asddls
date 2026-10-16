@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PACKING_ITEM1 as select from ZI_PACKLIST_ITM
{
  key Delivery,
  key Posnr,
  key Matnr,

  Item        as Item,
  Id          as Id,
  max(Packinglist) as Packinglist,
  max(Plant)       as Plant,
  max(Maktx)       as Maktx,
  Meins       as Meins,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  max(Qty)         as Qty,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  max(Packqty)     as Packqty,
  max(Priority)    as Priority,
  max(Packmat)     as Packmat,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  max(Packmatnwt)  as Packmatnwt,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  max(Matnetwt)    as Matnetwt,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  max(Eachnetwt)   as Eachnetwt,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  max(Eachgrowt)   as Eachgrowt,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  max(Netwt)       as Netwt,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  max(Growt)       as Growt,
 Wtunit      as Wtunit,
  max(Packmattyp)  as Packmattyp,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  max(Mateachpkg)  as Mateachpkg,
  max(Copy)        as Copy
 
}group by
  Delivery,
  Posnr,
  Matnr,
  Item,
  Id,
  Meins,
  Wtunit;
