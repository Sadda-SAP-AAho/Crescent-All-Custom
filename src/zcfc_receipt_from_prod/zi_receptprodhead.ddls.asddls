@AbapCatalog.sqlViewName: 'ZRECEPTPRODHEAD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Rcpt from Prod-Header'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_RECEPTPRODHEAD
  as select from ZI_CONFPOST_HDR            as a
    inner join            I_MaterialDocumentHeader_2 as b on a.Shpflrno = b.MaterialDocumentHeaderText

    inner join            I_MaterialDocumentItem_2   as c on  b.MaterialDocument  = c.MaterialDocument
                                                          and c.GoodsMovementType = '101'

    left outer join       I_Plant                    as d on  c.Plant    = d.Plant
                                                          and d.Language = 'E'

    inner join            I_ProductPlantBasic        as e on  c.Material = e.Product
                                                          and a.Plant    = e.Plant

    left outer join       I_ProfitCenterText         as f on e.ProfitCenter = f.ProfitCenter

    left outer join       I_Product                  as g on c.Material = g.Product

    left outer join       zdt_pp_matinffld           as h on c.Material = h.product

    left outer join       I_UnitOfMeasure            as i on c.Material = i.UnitOfMeasure

    left outer join       ZI_CONFPOST_ITM            as j on  a.Shpflrno = j.Shpflrno
                                                          and j.Shpflrno = b.MaterialDocumentHeaderText
                                                          and a.Id       = j.Id
                                                          and a.Refid    = j.Refid
                                                          and j.Matnr    = c.Material
{
  key b.MaterialDocument                                                                                                                                     as RcptfrmPrdNo,
  key j.Refitem                                                                                                                                              as Item_Sl_No,
  key a.Id,
  key a.Refid,
      b.PostingDate                                                                                                                                          as RcptfrmPrdDt,
      b.CreationDate,
      a.Opr                                                                                                                                                  as Opr_Code,
      a.Oprname                                                                                                                                              as Opr_Name,
      a.Dept                                                                                                                                                 as Dept_Code,
      a.Deptname                                                                                                                                             as Dept_Name,
      a.Cont                                                                                                                                                 as Cont_Code,
      a.Contname                                                                                                                                             as Cont_Name,
      a.Plant                                                                                                                                                as Plant_Code,
      d.PlantName                                                                                                                                            as Plant_Name,
      c.Material                                                                                                                                             as Mat_Code,
      j.Maktx                                                                                                                                                as Mat_Name,
      f.ProfitCenterName                                                                                                                                     as Profit_Center,
      h.typeofmould,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      g.NetWeight                                                                                                                                            as Std_Wt,
      g.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      j.Actwt                                                                                                                                                as Act_Wt,
      h.qtyperbox                                                                                                                                            as Qty_Box,
      j.Meins,

      ( case when c.StorageLocation not like '%RJ'
             then ( case when h.qtyperbox = 0.000
                    then cast( c.QuantityInEntryUnit as abap.dec( 13, 3) )
                    else cast( division(cast( c.QuantityInEntryUnit as abap.dec( 13, 3) ) , cast( h.qtyperbox as abap.dec( 13, 3) ) , 3 ) as abap.dec( 13, 3 ) ) end )
             else cast( 0 as abap.dec( 13, 3 ) ) end )                                                                                                                                as Box_Prod,

      (case when c.StorageLocation not like '%RJ' then cast( coalesce( c.QuantityInEntryUnit,0) as abap.dec( 13, 3) ) else cast(0 as abap.dec( 13, 3)) end ) as Good_Cast_Qty,

      (case when c.StorageLocation like '%RJ' then cast( coalesce( c.QuantityInEntryUnit,0) as abap.dec( 13, 3) ) else cast(0 as abap.dec( 13, 3)) end )     as Rej_Qty,

      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      g.GrossWeight,

      a.Shpflrno                                                                                                                                             as Shop_floor_No,
      a.Shpflrdt                                                                                                                                             as Shop_floor_Dt
}
