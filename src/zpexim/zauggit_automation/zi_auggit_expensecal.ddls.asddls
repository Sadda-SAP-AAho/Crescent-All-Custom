@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Expanse Calculation'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define root view entity ZI_AUGGIT_EXPENSECAL
  as select from zdt_expensecal
composition [0..*] of ZI_AUGGIT_EXPENSECAL_I as _item
{
  key id           as Id,
      commid       as Commid,
      commdate     as Commdate,
      servicepobt  as servicepobt,
      poupd        as poupd,
      taxcode      as Taxcode,
      profitcenter as Profitcenter,
      costcenter   as Costcenter,
      _item

}
