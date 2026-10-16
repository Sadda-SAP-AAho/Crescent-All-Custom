@AbapCatalog.sqlViewName: 'ZSUBCONISSFRSTDT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sub Contracting-Issued Item(1st Date)'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SUBCONISSUFRSTDT
  as select distinct from I_MaterialDocumentItem_2 as a
    inner join            I_ProductText            as b on  b.Product  = a.Material
                                                        and b.Language = 'E'
    inner join            I_Plant                  as c on c.Plant = a.Plant

{
  key a.PurchaseOrder     as PO_No,
  key a.PurchaseOrderItem as PO_Item_No,
  key a.Plant             as Plant_Code,
      a.GoodsMovementType,
      min (a.PostingDate) as First_Issued_Date

}
where
      a.GoodsMovementType = '541'
  and a.DebitCreditCode   = 'H'

group by
  a.PurchaseOrder,
  a.PurchaseOrderItem,
  a.Plant,
  a.GoodsMovementType

union select distinct from I_MaterialDocumentItem_2 as a
    inner join            I_ProductText            as b on  b.Product  = a.Material
                                                        and b.Language = 'E'
    inner join            I_Plant                  as c on c.Plant = a.Plant

{
  key a.PurchaseOrder     as PO_No,
  key a.PurchaseOrderItem as PO_Item_No,
  key a.Plant             as Plant_Code,
      a.GoodsMovementType,
      min (a.PostingDate) as First_Issued_Date

}
where
      a.GoodsMovementType = '544'
  and a.DebitCreditCode   = 'S'

group by
  a.PurchaseOrder,
  a.PurchaseOrderItem,
  a.Plant,
  a.GoodsMovementType  

union select distinct from I_MaterialDocumentItem_2 as a
  inner join               I_ProductText            as b on  b.Product  = a.Material
                                                         and b.Language = 'E'
  inner join               I_Plant                  as c on c.Plant = a.Plant

{
  key a.PurchaseOrder     as PO_No,
  key a.PurchaseOrderItem as PO_Item_No,
  key a.Plant             as Plant_Code,
      a.GoodsMovementType,
      min (a.PostingDate) as First_Issued_Date

}
where
  (
       a.GoodsMovementType = '543'
    or a.GoodsMovementType = '542'
  )
  and  a.DebitCreditCode   = 'H'

group by
  a.PurchaseOrder,
  a.PurchaseOrderItem,
  a.Plant,
  a.GoodsMovementType
