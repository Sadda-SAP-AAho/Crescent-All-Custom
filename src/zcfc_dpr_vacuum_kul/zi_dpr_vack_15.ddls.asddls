@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR VACCUM KUL - Power Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_VACK_15 
as select from ZI_PWRRDNGHEAD as a
inner join ZI_PWRRDNGITEM as b on b.Id = a.Id 
inner join ZI_PWRHDMASTER as c on  c.Headcd = b.Headcd and c.Metertyp = b.Metertyp 
                               and c.Subheadcd = b.Subhdcd 
{
    a.Readdate,
    sum( case when b.Metertyp = 'AUX' 
              then case when c.Vacprcnt is not initial 
                   then cast( division( cast( ( cast( b.Meterrdng as abap.dec( 19, 6 ) ) * cast( c.Vacprcnt as abap.dec( 6, 3 ) ) ) as abap.dec( 19, 6 ) ), 100, 6 ) as abap.dec( 19, 6 ) ) 
                   else 0 end 
              else 0 end ) as aux,
    sum( case when b.Metertyp = 'FURNACE' 
              then case when c.Vacprcnt is not initial 
                   then cast( division( cast( ( cast( b.Meterrdng as abap.dec( 19, 6 ) ) * cast( c.Vacprcnt as abap.dec( 6, 3 ) ) ) as abap.dec( 19, 6 ) ), 100, 6 ) as abap.dec( 19, 6 ) ) 
                   else 0 end
              else 0 end ) as furnace
}
where a.Readloccd = '1200'
group by a.Readdate
