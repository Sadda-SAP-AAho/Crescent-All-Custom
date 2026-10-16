@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR VACCUM KUL _ PGI Qty'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_VACK_9
  as select from I_DeliveryDocumentItem as a
    inner join   I_DeliveryDocument     as b on b.DeliveryDocument = a.DeliveryDocument
{
  a.ProfitCenter,
  b.ActualGoodsMovementDate,
  sum( cast( case when b.DeliveryDocumentType = 'LF' then a.ItemNetWeight
            else ( -1 * a.ItemNetWeight ) end as abap.dec( 23, 3 ) ) ) as despwt
}
where
       (
       a.ProfitCenter               = '0000001201'
    or a.ProfitCenter               = '0000001202'
  )
  and  b.ActualGoodsMovementDate    is not initial
  and(
       b.DeliveryDocumentType       = 'LF'
    or b.DeliveryDocumentType       = 'LR2'
  )
  and  b.OverallGoodsMovementStatus = 'C'
group by
  a.ProfitCenter,
  b.ActualGoodsMovementDate
