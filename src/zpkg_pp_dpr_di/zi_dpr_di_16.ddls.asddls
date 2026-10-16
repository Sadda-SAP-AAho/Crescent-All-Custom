@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR DI - Power Register with DI'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_DI_16 
as select from ZI_PWRRDNGHEAD as a
inner join ZI_PWRRDNGITEM as b on  b.Id = a.Id
inner join ZI_PWRHDMASTER as c on  c.Headcd = b.Headcd and c.Metertyp = b.Metertyp 
                               and c.Subheadcd = b.Subhdcd 
{
    a.Readdate,
    sum( case when c.Diprcnt is not initial 
               then cast( division( ( cast( b.Meterrdng as abap.dec( 13, 3 ) ) * cast( c.Diprcnt as abap.dec( 6, 2 ) )
                                      * cast( a.UnitRate as abap.dec( 13, 2 ) ) ), 100, 3 ) as abap.dec( 23, 3 ) ) 
               else 0 end ) as powercostact
}
where a.Readloccd = '1100'
group by a.Readdate
