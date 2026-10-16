@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for sum of weight of finalpl items'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_WEIGHTSUM 
as select distinct from ZCDS_WEIGHT
{
  key BillingDocument,
      Meins,
     @Semantics.quantity.unitOfMeasure : 'meins'
      sum(Netwt) as sumnetwt,
     @Semantics.quantity.unitOfMeasure : 'meins'
      sum(Growt) as sumgrosswt

}
group by BillingDocument,
         Meins
