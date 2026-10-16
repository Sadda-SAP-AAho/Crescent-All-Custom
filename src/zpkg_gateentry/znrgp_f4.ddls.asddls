@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for NRGP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity znrgp_f4
  as select distinct from    zdt_ghead as a
    left outer join zdt_ghead as b on b.rgpgatepass = a.gatepass
{
  key    a.gatepass,
  key    a.gatepassdate,
  key    b.rgpgatepass,
  key    a.type as type,
  key    case when a.type = 'RGP' then 'RETURN RGP'
     when a.type = 'STO OUTBOUND' then 'STO INBOUND'
     end        as newtype

}
where
  (
       a.type        = 'RGP'
    or a.type        = 'STO OUTBOUND'
  )
//  and  b.rgpgatepass is null
