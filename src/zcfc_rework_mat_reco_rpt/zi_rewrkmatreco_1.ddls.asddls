@AbapCatalog.sqlViewName: 'ZREWRKMATRECO1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rework Material Reco Report-1'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REWRKMATRECO_1
  as select distinct from I_ProductionOrder          as a
    inner join            I_ProductionOrderComponent as b on a.ProductionOrder = b.ProductionOrder
    left outer join       I_BusinessUserBasic        as c on c.UserID = a.CreatedByUser
    left outer join       I_ProfitCenterText         as d on  a.ProfitCenter = d.ProfitCenter
                                                          and d.Language     = 'E'
    left outer join       I_Plant                    as e on a.ProductionPlant = e.Plant
    left outer join       I_OrderTypeText            as f on  a.ProductionOrderType = f.OrderType
                                                          and f.Language            = 'E'
    left outer join       I_ProductText              as g on  b.Material = g.Product
                                                          and g.Language = 'E'
    left outer join       I_ProductGroupText_2       as h on  b.MaterialGroup = h.ProductGroup
                                                          and h.Language      = 'E'
    left outer join       I_Product                  as i on b.Material = i.Product
    left outer join       I_BusinessUserBasic        as j on j.UserID = a.LastChangedByUser
    left outer join       I_MaterialDocumentItem_2   as k on  b.ProductionOrder = k.OrderID
                                                          and b.ReservationItem = k.ReservationItem
    left outer join       I_MaterialDocumentHeader_2 as l on k.MaterialDocument = l.MaterialDocument
    left outer join       I_Materialledgercube_Lit   as m on l.MaterialDocument = m.ReferenceDocument
    left outer join       I_GoodsMovementTypeT       as n on  k.GoodsMovementType = n.GoodsMovementType
                                                          and n.Language          = 'E'
    left outer join       I_DebitCreditCodeText      as o on  k.DebitCreditCode = o.DebitCreditCode
                                                          and o.Language        = 'E'
    left outer join       I_GLAccountText            as p on  k.GLAccount = p.GLAccount
                                                          and p.Language  = 'E'
    left outer join       ZI_PRODQTY                 as q on  a.ProductionOrder = q.ProdOrdrNo
                                                          and b.ReservationItem = q.ReservationItem

{
  key a.ProductionOrder                                                    as ProdOrdrNo,
  key ( case when a.OrderActualReleaseDate <> '00000000'
        then cast( a.OrderActualReleaseDate as abap.dats )
        else cast( '' as abap.dats )
        end )                                                              as OrdrActRelDate,
  key c.PersonFullName                                                     as CreatedBy,
  key ( case when a.CreationDate <> '00000000'
        then cast( a.CreationDate as abap.dats )
        else cast( '' as abap.dats )
        end )                                                              as CreationDate,
  key j.PersonFullName                                                     as LastUptBy,
  key ( case when a.LastChangeDate <> '00000000'
        then cast( a.LastChangeDate as abap.dats )
        else cast( '' as abap.dats )
        end )                                                              as LastUptDate,
  key a.ProfitCenter                                                       as ProfitCenterCode,
  key d.ProfitCenterName                                                   as ProfitCenterName,
  key a.ProductionPlant                                                    as PlantCode,
  key e.PlantName                                                          as PlantName,
  key b.BillOfMaterialItemNumber                                           as SlNo,
  key b.Material                                                           as CompNo,
      g.ProductName                                                        as CompDesc,
      h.ProductGroupName                                                   as CompGrp,
      b.BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      q.CompPlanedQty                                                      as CompPlanedQty,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      q.CompIssuedQty                                                      as CompIssuedQty,
      i.WeightUnit                                                         as WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      i.NetWeight                                                          as CompNetUnitWt,
      cast( ( q.CompIssuedQty * i.NetWeight )  as abap.dec( 19, 3 ) )      as CompNetWt,
      l.MaterialDocument                                                   as MatlDocNo,
      ( case when l.PostingDate <> '00000000'
        then cast( l.PostingDate as abap.dats )
        else cast( '' as abap.dats )
        end )                                                              as MatlDocPostDt,
      q.Currency,
      @Semantics.amount.currencyCode: 'Currency'
      q.AmtinLocCurr                                                       as AmtinLocCurr,
      concat ( k.GoodsMovementType,concat ('-',n.GoodsMovementTypeName ) ) as MovementType,
      concat ( k.DebitCreditCode,concat ('-',o.DebitCreditCodeName ) )     as DrCrIndiCator,
      k.GLAccount                                                          as GlCode,
      p.GLAccountName                                                      as GLName


}
where
  a.ProductionOrderType = 'ZRWK'
