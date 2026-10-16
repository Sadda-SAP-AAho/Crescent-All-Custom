@AbapCatalog.sqlViewName: 'ZSUBCONRECLASTDT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sub Contracting-Received Item(Latest Date)'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SUBCONRECVLASTDT
  as select distinct from I_PurchaseOrderItemAPI01 as a
    inner join            I_ProductText            as b on  b.Product  = a.Material
                                                        and b.Language = 'E'
    inner join            I_Plant                  as c on c.Plant = a.Plant
    left outer join       I_MaterialDocumentItem_2 as d on  d.PurchaseOrder     = a.PurchaseOrder
                                                        and d.PurchaseOrderItem = a.PurchaseOrderItem
                                                        and d.GoodsMovementType = '101'
                                                        and d.DebitCreditCode   = 'S'
                                                        
{
  key a.PurchaseOrder      as PO_No,
  key a.PurchaseOrderItem  as PO_Item_No,
      a.Material           as Material_Code,
      b.ProductName        as Material_Desc,
      a.Plant              as Plant_Code,
      max( d.PostingDate ) as Latest_Received_Date
}

where d.PostingDate is not null

group by
  a.PurchaseOrder,
  a.PurchaseOrderItem,
  a.Material,
  b.ProductName,
  a.Plant
