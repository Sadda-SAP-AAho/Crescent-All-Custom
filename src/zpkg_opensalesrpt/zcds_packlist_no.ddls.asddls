@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for packing list related fields'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_PACKLIST_NO
  as select distinct from I_SalesOrderItem       as c
    left outer join       I_DeliveryDocumentItem as a on  c.SalesOrder     = a.ReferenceSDDocument
                                                      and c.SalesOrderItem = a.ReferenceSDDocumentItem
    left outer join       I_DeliveryDocument     as d on d.DeliveryDocument = a.DeliveryDocument                                                   
    left outer join       ZI_PACKLIST_HDR        as b on b.Delivery = a.DeliveryDocument


{
  c.SalesOrder     as ReferenceSDDocument,
  c.SalesOrderItem as ReferenceSDDocumentItem,
  b.Createdon,
  b.Changedat,
  concat(b.Createdon,b.Changedat) as zdatetime,
  b.Packinglist
}
where
  b.Canind <> 'X'
  and d.OverallGoodsMovementStatus = 'A'
