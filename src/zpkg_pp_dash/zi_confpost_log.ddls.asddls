@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Conf Post Log'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_CONFPOST_LOG
  as select from zdt_confpost_log
  association to parent ZI_CONFPOST_HDR as _Head on $projection.Id = _Head.Id
{
  key id       as Id,
  key log      as Log,
      refitem  as Refitem,
      reford   as Reford,
      shpflrno as Shpflrno,
      matnr    as Matnr,
      plant    as Plant,
      prodord  as Prodord,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      qty      as Qty,
      meins    as Meins,
      postedby as Postedby,
      postedon as Postedon,
      postedat as Postedat,
      uniqueid as Uniqueid,
      movtype  as Movtype,
      _Head

}
