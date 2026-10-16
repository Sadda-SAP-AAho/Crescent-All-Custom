@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'On Time Despatch'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ONTMDSPTCH
  as select distinct from ZI_PROFITCENTERLIST    as x
    left outer join       I_DeliveryDocumentItem as a on  a.Plant        = x.Plant
                                                      and a.ProfitCenter = x.ProfitCenter
                                                      and x.Plant        is not initial
    left outer join       I_DeliveryDocument     as b on b.DeliveryDocument = a.DeliveryDocument
    left outer join       ZI_CONDELDATE          as c on  c.SalesOrder     = a.ReferenceSDDocument
                                                      and c.SalesOrderItem = a.ReferenceSDDocumentItem

{
  key x.Plant,
  key x.ProfitCenter,
  key x.ProfitCenterName,
      
      b.ActualGoodsMovementDate,

      sum( cast( case when c.ConfirmedDeliveryDate > b.ActualGoodsMovementDate
                      then case when b.DeliveryDocumentType = 'LF' then a.ItemNetWeight
                                else ( -1 * a.ItemNetWeight ) end
                      else 0 end as abap.dec( 23, 3 ) ) ) as ontimdespwt
}

where
       b.ActualGoodsMovementDate    is not initial
  and(
       b.DeliveryDocumentType       = 'LF'
    or b.DeliveryDocumentType       = 'LR2'
  )
  and  b.OverallGoodsMovementStatus = 'C'

group by
  x.Plant,
  x.ProfitCenter,
  x.ProfitCenterName,
  b.ActualGoodsMovementDate
