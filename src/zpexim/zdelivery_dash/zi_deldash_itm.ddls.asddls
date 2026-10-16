@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Delivery Dash Item'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_DELDASH_ITM
  as select from zdt_deldash_itm
  association to parent ZI_DELDASH_HDR as _Head on $projection.Id = _Head.Id
{
  key id         as Id,
  key item       as Item,
      delivery   as Delivery,
      posnr      as Posnr,
      plant      as Plant,
      lgort      as Lgort,
      matnr      as Matnr,
      maktx      as Maktx,
      meins      as Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      qty        as Qty,
      cusreqdt   as Cusreqdt,
      revno      as Revno,
      oitfdt     as Oitfdt,
      itmpaiinfo as Itmpaiinfo,
      hsn        as Hsn,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      nwt        as Nwt,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      gwt        as Gwt,
      unit       as Unit,
      _Head // Make association public
}
