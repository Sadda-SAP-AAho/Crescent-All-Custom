@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commercial Container Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_EXIMCOMMCNI

  as select from zexim_comm_cni

  association to parent ZI_EXIMCOMMHDR as _head on $projection.Id = _head.Id

{
  key id            as Id,
  key item          as Item,
      containerno   as Containerno,
      containersize as Containersize,
      sealno        as Sealno,
      uom           as Uom,
      @Semantics.quantity.unitOfMeasure: 'uom'
      tareweight    as Tareweight,
      @Semantics.quantity.unitOfMeasure: 'uom'
      grossweight   as Grossweight,
      ewaybillno    as Ewaybillno,
      remarks       as Remarks,

      _head
}
