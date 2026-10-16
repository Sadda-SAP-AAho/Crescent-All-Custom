@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transport Order Item'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_IITO_TRANS
  as select from ztm_iito_trans
  association to parent zi_hito_trans as _Head on $projection.Id = _Head.Id
{
  key ztm_iito_trans.id      as Id,
  key ztm_iito_trans.item    as Item,
      ztm_iito_trans.itono   as Itono,
      ztm_iito_trans.itoitem as Itoitem,
      ztm_iito_trans.matnr   as Matnr,
      ztm_iito_trans.maktx   as Maktx,
      ztm_iito_trans.werks   as Werks,
      ztm_iito_trans.meins   as Meins,
  @Semantics.quantity.unitOfMeasure : 'Meins'
      ztm_iito_trans.ntgew   as Ntgew,
      _Head
}
