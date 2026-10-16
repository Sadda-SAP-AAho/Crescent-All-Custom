@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservation Status Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_RESRVSTSRPT
  as select distinct from I_ReservationDocumentHeader as a

    inner join            I_ReservationDocumentItem   as b on a.Reservation = b.Reservation

    left outer join       I_ProductText               as c on  c.Product  = b.Product
                                                           and c.Language = 'E'

    left outer join       I_Plant                     as d on d.Plant = b.Plant

    left outer join       I_StorageLocation           as e on  e.StorageLocation = b.StorageLocation
                                                           and e.Plant           = b.Plant

    left outer join       I_GLAccountText             as f on  f.GLAccount = b.GLAccount
                                                           and f.Language  = 'E'

    left outer join       I_CostCenterText            as g on  g.CostCenter = a.CostCenter
                                                           and g.Language   = 'E'

    left outer join       I_BusinessUserBasic         as h on h.UserID = a.UserID

    left outer join       ZI_MATSTOCK                 as i on  i.Product         = b.Product
                                                           and i.Plant           = b.Plant
                                                           and i.StorageLocation = b.StorageLocation

{
  key cast( a.Reservation as abap.char(10) )                                        as Reservation,
  key cast( b.ReservationItem as abap.char(4) )                                     as ReservationItem,
      a.GoodsMovementType                                                           as MovementType,
      ( case when a.GoodsMovementType = '201' then 'GI for cost center'
             when a.GoodsMovementType = '202' then 'RE for cost center'
             when a.GoodsMovementType = '221' then 'GI for project'
             when a.GoodsMovementType = '261' then 'GI for order'
             when a.GoodsMovementType = '531' then 'Receipt by-product' end )       as MovementTypeTxt,

      b.MatlCompRequirementDate                                                     as ReqmntDate,
      b.Product                                                                     as Material,
      c.ProductName                                                                 as MaterialDesc,
      b.Plant,
      d.PlantName,
      b.StorageLocation,
      e.StorageLocationName,
      ( case when b.ReservationItemIsFinallyIssued = 'X' then 'Yes' else 'No' end ) as ItmCompltd,
      ( case when b.ReservationItmIsMarkedForDeltn = 'X' then 'Yes' else 'No' end ) as ItmDeleted,
      b.BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      b.ResvnItmRequiredQtyInBaseUnit                                               as QtyinUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      b.ResvnItmWithdrawnQtyInBaseUnit                                              as QtyWithdrawn,
      ( cast( coalesce(b.ResvnItmRequiredQtyInBaseUnit,0) as abap.dec(15,3) )
      - cast( coalesce(b.ResvnItmWithdrawnQtyInBaseUnit,0) as abap.dec(15,3) ) )    as TobeIssuedQty,
      i.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      i.MatlWrhsStkQtyInMatlBaseUnit                                                as PlantStock,
      cast( b.GLAccount as abap.char(10) )                                          as GLCode,
      f.GLAccountName                                                               as GLName,
      a.CostCenter                                                                  as CostCenterCode,
      g.CostCenterName                                                              as CostCenterName,
      a.UserID                                                                      as UserID,
      h.PersonFullName                                                              as UserName

}
