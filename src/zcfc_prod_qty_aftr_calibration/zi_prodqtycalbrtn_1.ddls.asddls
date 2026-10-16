@AbapCatalog.sqlViewName: 'ZPRODQTYCALBRTN1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Qty after Calibration(Basic)'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_PRODQTYCALBRTN_1
  as select from    ZI_CONFPOST_HDR            as a
    inner join      I_MaterialDocumentHeader_2 as b on  a.Shpflrno                 = b.MaterialDocumentHeaderText
                                                    and b.InventoryTransactionType = 'WF'
                                                    and b.Plant                    = a.Plant

    inner join      I_MaterialDocumentItem_2   as c on  b.MaterialDocument  = c.MaterialDocument
                                                    and c.GoodsMovementType = '101'
                                                    and c.Plant             = b.Plant

    inner join      I_Product                  as g on c.Material = g.Product

    inner join      I_ProductText              as e on  e.Product  = g.Product
                                                    and e.Language = 'E'

    left outer join zdt_pp_matinffld           as h on c.Material = h.product
{
  key c.Material                                 as Material,
  key e.ProductName                              as Material_Desc,
  key c.Plant                                    as Plant,
      h.moc                                      as MOC,
      h.cuscode                                  as Customer,
      h.calibdate                                as Calibration_Dt,
      h.qtyperbox                                as Qtyperbox,
      g.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      g.NetWeight                                as Unit_Wt,
      c.EntryUnit,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      sum( c.QuantityInEntryUnit )               as Total_Qty,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      sum( c.QuantityInEntryUnit ) * g.NetWeight as Total_Wt
}

where
       h.calibdate    is not initial
  and  b.PostingDate  between h.calibdate and $session.system_date
  and(
       g.ProductGroup =       'Z025'
    or g.ProductGroup =       'Z027'
  )

group by
  c.Material,
  e.ProductName,
  c.Plant,
  h.moc,
  h.cuscode,
  h.calibdate,
  h.qtyperbox,
  g.WeightUnit,
  g.NetWeight,
  c.EntryUnit
