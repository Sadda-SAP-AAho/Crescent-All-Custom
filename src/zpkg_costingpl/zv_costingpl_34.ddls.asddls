@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_34

  as select from I_SalesContractItem          as a

    inner join   I_SlsContrItemPricingElement as b on  b.SalesContract = a.SalesContract
                                                   and b.ConditionType = 'ZRAW'

{

  key a.SalesContract,
      sum( case when b.ConditionType = 'ZRAW' then cast( b.ConditionAmount as abap.dec( 21,2 ) ) else 0 end ) as ZRAW

}

group by
  a.SalesContract
