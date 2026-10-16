@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Item Gate Pass'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #TRANSACTIONAL
}
define view entity ZI_ItemGATE_PASS
  as select from ztm_igate_pass
  association to parent ZI_HGATE_PASS as _Head on $projection.Id = _Head.Id
{
  key    ztm_igate_pass.id         as Id,
  key    ztm_igate_pass.item       as Item,
         ztm_igate_pass.gatepass   as Gatepass,
         ztm_igate_pass.ebeln      as Ebeln,
         ztm_igate_pass.ebelp      as Ebelp,
         ztm_igate_pass.matnr      as Matnr,
         ztm_igate_pass.maktx      as Maktx,
         ztm_igate_pass.hsnsac     as Hsnsac,
         @Semantics.quantity.unitOfMeasure : 'Meins'
         ztm_igate_pass.menge      as Menge,
         ztm_igate_pass.meins      as Meins,
         ztm_igate_pass.wears      as Wears,
         @Semantics.amount.currencyCode: 'WEARS'
         ztm_igate_pass.netwr      as Netwr,
         ztm_igate_pass.returndate as Returndate,
         ztm_igate_pass.remarks    as Remarks,
         ztm_igate_pass.stcd3      as Stcd3,
         actretdate,
         gateno,
         recvqty,
         retremarks,
         _Head
}
