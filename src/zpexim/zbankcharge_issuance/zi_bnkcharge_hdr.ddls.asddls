@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For bank charges header'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define root view entity ZI_BNKCHARGE_HDR
  as select from zdt_bnkch_hdr
{
  key id            as Id,
      bnkchargename as Bnkchargename,
      category      as Category,
      active        as Active,
      glcode        as Glcode
}
