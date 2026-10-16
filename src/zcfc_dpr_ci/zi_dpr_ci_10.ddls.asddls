@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR CI _ PGI Ontime Qty'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_CI_10 
  as select from I_DeliveryDocumentItem as a
    inner join   I_DeliveryDocument     as b on b.DeliveryDocument = a.DeliveryDocument
    inner join   ZI_DPR_CI_11           as c on  c.SalesOrder     = a.ReferenceSDDocument
                                             and c.SalesOrderItem = a.ReferenceSDDocumentItem
{
  a.ProfitCenter,
  b.ActualGoodsMovementDate,
  sum( cast( case when c.ConfirmedDeliveryDate > b.ActualGoodsMovementDate
                  then case when b.DeliveryDocumentType = 'LF' then a.ItemNetWeight
                            else ( -1 * a.ItemNetWeight ) end
                  else 0 end as abap.dec( 23, 3 ) ) ) as ontimdespwt
}
where
       a.ProfitCenter            = '0000001101'
  and  b.ActualGoodsMovementDate is not initial
  and(
       b.DeliveryDocumentType    = 'LF'
    or b.DeliveryDocumentType    = 'LR2'
  )
  and  b.OverallGoodsMovementStatus = 'C'
group by
  a.ProfitCenter,
  b.ActualGoodsMovementDate
