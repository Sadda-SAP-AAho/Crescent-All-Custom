@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_STAN_VS_ACT_NONBOM
  as select from    I_MaterialDocumentItem_2 as a
    inner join      I_Product                as d on d.Product = a.Material
    inner join      I_CostCenterText         as b on  b.CostCenter      = a.CostCenter
                                                  and b.ControllingArea = a.ControllingArea
                                                  and b.ValidityEndDate = '99991231'
    left outer join I_GLAccountTextRawData   as c on  c.GLAccount = a.GLAccount
                                                  and c.Language  = 'E'
    left outer join zdt_pp_matinffld         as e on e.product = a.Material
{
  a.PostingDate,
  a.Plant,
  a.CostCenter,
  b.CostCenterDescription,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  sum( case when e.consbase = 'LM' then cast( a.QuantityInBaseUnit as abap.quan( 13, 3 ) )
       when ( e.consbase = 'CASTING' and e.typeofmould = 'SMALL VACCUM' and e.qtyperbox is not initial )
       then cast( division(cast( a.QuantityInBaseUnit as abap.dec( 13, 3 ) ), cast( e.qtyperbox as abap.dec( 13, 3 ) ), 3) as abap.quan( 13, 3 ) )
       when ( e.consbase = 'CASTING' and e.typeofmould = 'BIG VACCUM' and e.qtyperbox is not initial )
       then cast( division(cast( ( a.QuantityInBaseUnit * 2 ) as abap.dec( 13, 3 ) ), cast( e.qtyperbox as abap.dec( 13, 3 ) ), 3) as abap.quan( 13, 3 ) ) 
       when ( e.consbase = 'CASTING' and e.typeofmould = 'MANIPULATOR' and e.qtyperbox is not initial )
       then cast( division(cast( ( a.QuantityInBaseUnit * 35 ) as abap.dec( 13, 3 ) ), cast( ( e.qtyperbox * 10 ) as abap.dec( 13, 3 ) ), 3) as abap.quan( 13, 3 ) )
       when ( e.consbase = 'CASTING' and e.typeofmould = 'FLEXILINE' and e.qtyperbox is not initial )
       then cast( division(cast( ( a.QuantityInBaseUnit * 55 ) as abap.dec( 13, 3 ) ), cast( ( e.qtyperbox * 10 ) as abap.dec( 13, 3 ) ), 3) as abap.quan( 13, 3 ) )
       else cast( 0 as abap.quan( 13, 3) ) 
       end ) as QuantityInBaseUnit,
  a.MaterialBaseUnit,
  a.GLAccount,
  c.GLAccountLongName,
  a.OrderID,
  cast( case when d.ProductGroup = 'Z025' then 'CASTING'
             when d.ProductGroup = 'Z021' then 'MELTING' end as abap.char( 10 ) ) as conbase

}
where
       a.GoodsMovementType        =  '101'
  and  a.GoodsMovementIsCancelled <> 'X'
  and  a.CostCenter               is not initial
  and(
       a.Plant                    =  '1100'
    or a.Plant                    =  '1200'
    or a.Plant                    =  '1300'
    or a.Plant                    =  '1400'
  )
// and ( d.ProductGroup = 'Z025' or d.ProductGroup = 'Z021' )
group by
  a.PostingDate,
  a.Plant,
  a.CostCenter,
  b.CostCenterDescription,
  a.MaterialBaseUnit,
  a.GLAccount,
  c.GLAccountLongName,
  a.OrderID,
  d.ProductGroup
  //e.consbase,
  //e.typeofmould,
  //e.qtyperbox
