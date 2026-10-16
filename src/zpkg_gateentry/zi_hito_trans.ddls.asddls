@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transport Order Header'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define root view entity ZI_HITO_TRANS
  as select from ztm_hito_trans
  composition [0..*] of ZI_IITO_TRANS as _Item
{
  key ztm_hito_trans.id            as Id,
      ztm_hito_trans.itono         as Itono,
      ztm_hito_trans.createby      as Createby,
      ztm_hito_trans.createname    as Createname,
      ztm_hito_trans.createdate    as Createdate,
      ztm_hito_trans.createtime    as Createtime,
      ztm_hito_trans.begda         as Begda,
      ztm_hito_trans.endda         as Endda,
      ztm_hito_trans.ebeln         as Ebeln,
      ztm_hito_trans.slgort        as Slgort,
      ztm_hito_trans.dlgort        as Dlgort,
      ztm_hito_trans.lifnr         as Lifnr,
      ztm_hito_trans.vehicleno     as Vehicleno,
      ztm_hito_trans.transport     as Transport,
      ztm_hito_trans.dname         as Dname,
      ztm_hito_trans.meins         as Meins,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      ztm_hito_trans.trgew         as Trgew,
      ztm_hito_trans.itostat       as Itostat,
      ztm_hito_trans.cancelremarks as Cancelremarks,
      ztm_hito_trans.trips         as Trips,
      ztm_hito_trans.plant         as Plant,
      _Item
}
