@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Invoice Update Header'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define root view entity ZI_INVUPDHDR as select from zdt_invupdhdr
{
  key id       as id,
      invno    as invno,
      invyr    as invyr,
      invdt    as invdt,
      custcode as custcode,
      custdesc as custdesc,
      waers    as waers,
      @Semantics.amount.currencyCode: 'Waers'
      contamt  as contamt,
      netduedt as netduedt,
      pterm    as pterm,
      date1    as date1,
      date2    as date2,
      datefld  as datefld
}
