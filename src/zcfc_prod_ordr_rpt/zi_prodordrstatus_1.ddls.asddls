@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Order Status-1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PRODORDRSTATUS_1
  as select distinct from ZTBL_FCTN_PROD_ITEM        as a
    inner join            I_ManufacturingOrderStatus as b on  a.ProductionOrder = b.ManufacturingOrder
                                                          and b.StatusIsActive  = 'X'

{
  key a.ProductionOrder,
      ( case when ( b.StatusCode = 'I0046' or b.StatusCode = 'I0045' ) then 'C'
             when b.StatusCode = 'I0002' then 'R' end ) as Status
}
