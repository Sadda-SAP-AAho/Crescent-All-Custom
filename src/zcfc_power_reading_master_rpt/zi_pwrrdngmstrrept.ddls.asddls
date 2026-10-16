@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Power Reading Master Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PWRRDNGMSTRREPT
  as select distinct from ZI_PWRHEADCOMPCAL

{
  key Id,
  key Item,
  key Docnum,
      Readdate,
      Readloccd,
      Readlocnm,
      Readdept,
      UnitRate,
      Subhdcd,
      Subhdnm,
      Headcd,
      Headnm,
      Metertyp,
      Meterrdng,
      Diprcnt,
      DiUnits,
      cast ( DiUnits as abap.dec( 16, 3 ) ) * cast ( UnitRate as abap.dec( 16, 3 ) ) as DiAmt,
      Ciprcnt,
      CiUnits,
      cast ( CiUnits as abap.dec( 16, 3 ) ) * cast ( UnitRate as abap.dec( 16, 3 ) ) as CiAmt,

      cast ( DiUnits as abap.dec( 16, 3 ) ) * cast ( UnitRate as abap.dec( 16, 3 ) ) +
      cast ( CiUnits as abap.dec( 16, 3 ) ) * cast ( UnitRate as abap.dec( 16, 3 ) ) as TotalAmt
}
