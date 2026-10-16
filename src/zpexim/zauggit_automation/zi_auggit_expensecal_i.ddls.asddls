@EndUserText.label: 'Expanse Calculation Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_AUGGIT_EXPENSECAL_I 
 as select from zdt_expensecal_i
  association to parent ZI_AUGGIT_EXPENSECAL as _head on $projection.Id = _head.Id
{
  key zdt_expensecal_i.id              as Id,
  key zdt_expensecal_i.item            as Item,
      zdt_expensecal_i.commid          as Commid,
      zdt_expensecal_i.expansetype     as Expansetype,
      zdt_expensecal_i.percontship     as Percontship,
      zdt_expensecal_i.forwarder       as Forwarder,
      zdt_expensecal_i.countcontship   as countcontship,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_expensecal_i.amount          as Amount,
      zdt_expensecal_i.currency        as Currency,
      zdt_expensecal_i.exchangerate    as Exchangerate,
      zdt_expensecal_i.amountinr       as Amountinr,
      zdt_expensecal_i.servicepo       as Servicepo,
      zdt_expensecal_i.servicepoline   as Servicepoline,
      zdt_expensecal_i.serentrysheet   as Serentrysheet,
      zdt_expensecal_i.servicepobt     as Servicepobt,
      zdt_expensecal_i.serviceentrybt  as serviceentrybt,
      zdt_expensecal_i.serviceporef    as serviceporef,
      zdt_expensecal_i.serviceentryref as serviceentryref, 
      zdt_expensecal_i.copy            as copy,      
      _head
}
