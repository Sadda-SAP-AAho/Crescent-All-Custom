@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for GSTR 2B Register Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_GSTR2BREG_I
  as select from zdt_gstr2breg_i
  association to parent ZI_GSTR2BREG_H as _Head on $projection.id = _Head.id
{
  key id,
  key item,
  key rowno,
      suppgstn,
      lglname,
      invno,
      invtyp,
      invdate,
      invval,
      placesupply,
      revcharge,
      rateperc,
      taxval,
      intgrtax,
      centraltax,
      stateuttax,
      cess,
      gstrperiod,
      gstrfildate,
      itcavail,
      reason,
      apptaxrate,
      _Head
}
