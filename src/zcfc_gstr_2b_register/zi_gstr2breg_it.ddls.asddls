@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'GSTR 2B Register-Item'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define view entity ZI_GSTR2BREG_IT
  as select from zdt_gstr2breg_it
  association to parent ZI_GSTR2BREG_HD as _Head on $projection.Id = _Head.Id
{
  key id          as Id,
  key item        as Item,
      suppgstn    as Suppgstn,
      lglname     as Lglname,
      invno       as Invno,
      invtyp      as Invtyp,
      invdate     as Invdate,
      invval      as Invval,
      placesupply as Placesupply,
      revcharge   as Revcharge,
      rateperc    as Rateperc,
      taxval      as Taxval,
      intgrtax    as Intgrtax,
      centraltax  as Centraltax,
      stateuttax  as Stateuttax,
      cess        as Cess,
      gstrperiod  as Gstrperiod,
      gstrfildate as Gstrfildate,
      itcavail    as Itcavail,
      reason      as Reason,
      apptaxrate  as Apptaxrate,
      _Head
}
