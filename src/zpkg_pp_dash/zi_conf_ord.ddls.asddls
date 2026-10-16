@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Conf Order'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_CONF_ORD
  as select from zdt_cont_ord
  association to parent ZI_CONF_HDR as _Head on $projection.Id = _Head.Id
{
  key zdt_cont_ord.id        as Id,
  key zdt_cont_ord.item      as Item,
  key zdt_cont_ord.ord       as Ord,
      zdt_cont_ord.shpflrno  as Shpflrno,
      zdt_cont_ord.matnr     as Matnr,
      zdt_cont_ord.plant     as Plant,
      zdt_cont_ord.prodord   as Prodord,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_cont_ord.pendprqty as Pendprqty,
      zdt_cont_ord.meins     as Meins,
      zdt_cont_ord.serial    as Serial,
      zdt_cont_ord.heatno    as Heatno,
      zdt_cont_ord.rej       as Rej,
      zdt_cont_ord.status    as Status,
      zdt_cont_ord.ovstatus  as Ovstatus,
      _Head

}
