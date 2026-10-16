@AbapCatalog.sqlViewName: 'ZJOBWRKISSUEDITM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Job Work-Issued Item'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_JOBWRKISSUEDITM
  as select distinct from I_MaterialDocumentItem_2   as a
    inner join            I_ProductText              as b  on  b.Product  = a.Material
                                                           and b.Language = 'E'
    inner join            I_MaterialDocumentHeader_2 as a1 on  a.MaterialDocumentYear = a1.MaterialDocumentYear
                                                           and a.MaterialDocument     = a1.MaterialDocument
    inner join            I_Plant                    as c  on c.Plant = a.Plant

    left outer join       I_UnitOfMeasure            as d  on a.MaterialBaseUnit = d.UnitOfMeasure
    left outer join       ZI_BILLINGDOCDATA          as e  on  e.MaterialDocument     = a.MaterialDocument
                                                           and e.MaterialDocumentYear = a.MaterialDocumentYear
                                                           and e.MaterialDocumentItem = a.MaterialDocumentItem
    left outer join       ZI_TAX_VALUE               as f  on  a1.MaterialDocument     = f.MaterialDocument
                                                           and a1.MaterialDocumentYear = f.MaterialDocumentYear
                                                           and a.MaterialDocumentItem  = f.MaterialDocumentItem




{
  key  cast( 'Issued' as abap.char( 10 ) )              as Trans_Type,
  key  a.PurchaseOrder                                  as PO_No,
  key  a.PurchaseOrderItem                              as PO_Item_No,
  key  a1.MaterialDocument,
  key  e.BillingDocument                                as ChallanNo,
  key  a.Plant                                          as Plant_Code,
  key  c.PlantName                                      as Plant_Name,
  key  a.Material                                       as Material_Code,
       b.ProductName                                    as Material_Desc,
       a1.DocumentDate                                  as MatlDocDate,
       a.GoodsMovementType,
       e.BillingDocumentDate                            as ChallanDate,
       e.TransactionCurrency,
       e.NetAmount                                      as MatlValue,
       f.IGST_Value,
       f.CGST_Value,
       f.SGST_Value,
       d.UnitOfMeasure_E                                as Withd_Qty_Unit,
       cast ( a.QuantityInEntryUnit as abap.dec(15,3) ) as Withd_Qty

}
where
      a.GoodsMovementType = '541'
  and a.DebitCreditCode   = 'S'



union

select distinct from I_MaterialDocumentItem_2   as a
  inner join         I_ProductText              as b  on  b.Product  = a.Material
                                                      and b.Language = 'E'
  inner join         I_MaterialDocumentHeader_2 as a1 on  a.MaterialDocumentYear = a1.MaterialDocumentYear
                                                      and a.MaterialDocument     = a1.MaterialDocument
  inner join         I_Plant                    as c  on c.Plant = a.Plant

  left outer join    I_UnitOfMeasure            as d  on a.MaterialBaseUnit = d.UnitOfMeasure
  left outer join    ZI_BILLINGDOCDATA          as e  on  e.MaterialDocument     = a.MaterialDocument
                                                      and e.MaterialDocumentYear = a.MaterialDocumentYear
                                                      and e.MaterialDocumentItem = a.MaterialDocumentItem
  left outer join    ZI_TAX_VALUE               as f  on  a1.MaterialDocument     = f.MaterialDocument
                                                      and a1.MaterialDocumentYear = f.MaterialDocumentYear
                                                      and a.MaterialDocumentItem  = f.MaterialDocumentItem




{
  key  cast( 'Issued' as abap.char( 10 ) )              as Trans_Type,
  key  a.PurchaseOrder                                  as PO_No,
  key  a.PurchaseOrderItem                              as PO_Item_No,
  key  a1.MaterialDocument,
  key  e.BillingDocument                                as ChallanNo,
  key  a.Plant                                          as Plant_Code,
  key  c.PlantName                                      as Plant_Name,
  key  a.Material                                       as Material_Code,
       b.ProductName                                    as Material_Desc,
       a1.DocumentDate                                  as MatlDocDate,
       a.GoodsMovementType,
       e.BillingDocumentDate                            as ChallanDate,
       e.TransactionCurrency,
       e.NetAmount                                      as MatlValue,
       f.IGST_Value,
       f.CGST_Value,
       f.SGST_Value,
       d.UnitOfMeasure_E                                as Withd_Qty_Unit,
       cast ( a.QuantityInEntryUnit as abap.dec(15,3) ) as Withd_Qty

}
where
      a.GoodsMovementType = '544'
  and a.DebitCreditCode   = 'S'



union

select distinct from I_MaterialDocumentItem_2   as a
  inner join         I_ProductText              as b  on  b.Product  = a.Material
                                                      and b.Language = 'E'
  inner join         I_MaterialDocumentHeader_2 as a1 on  a.MaterialDocumentYear = a1.MaterialDocumentYear
                                                      and a.MaterialDocument     = a1.MaterialDocument
  inner join         I_Plant                    as c  on c.Plant = a.Plant

  left outer join    I_UnitOfMeasure            as d  on a.MaterialBaseUnit = d.UnitOfMeasure
  left outer join    ZI_BILLINGDOCDATA          as e  on  e.MaterialDocument     = a.MaterialDocument
                                                      and e.MaterialDocumentYear = a.MaterialDocumentYear
                                                      and e.MaterialDocumentItem = a.MaterialDocumentItem
  left outer join    ZI_TAX_VALUE               as f  on  a1.MaterialDocument     = f.MaterialDocument
                                                      and a1.MaterialDocumentYear = f.MaterialDocumentYear
                                                      and a.MaterialDocumentItem  = f.MaterialDocumentItem




{
  key  cast( 'Issued' as abap.char( 10 ) )              as Trans_Type,
  key  a.PurchaseOrder                                  as PO_No,
  key  a.PurchaseOrderItem                              as PO_Item_No,
  key  a1.MaterialDocument,
  key  e.BillingDocument                                as ChallanNo,
  key  a.Plant                                          as Plant_Code,
  key  c.PlantName                                      as Plant_Name,
  key  a.Material                                       as Material_Code,
       b.ProductName                                    as Material_Desc,
       a1.DocumentDate                                  as MatlDocDate,
       a.GoodsMovementType,
       e.BillingDocumentDate                            as ChallanDate,
       e.TransactionCurrency,
       e.NetAmount                                      as MatlValue,
       f.IGST_Value,
       f.CGST_Value,
       f.SGST_Value,
       d.UnitOfMeasure_E                                as Withd_Qty_Unit,
       cast ( a.QuantityInEntryUnit as abap.dec(15,3) ) as Withd_Qty

}
where
  (
       a.GoodsMovementType = '543'
    or a.GoodsMovementType = '542'
  )
  and  a.DebitCreditCode   = 'H'
