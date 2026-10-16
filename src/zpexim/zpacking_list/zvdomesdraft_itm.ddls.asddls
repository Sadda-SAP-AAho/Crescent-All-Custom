@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'draft packing list item level fields'
@AbapCatalog.sqlViewName: 'Z_DOMESDRAFTPL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@Metadata.ignorePropagatedAnnotations: true
define view ZVDOMESDRAFT_ITM
  as select distinct from ZI_PACKLIST_HDR as a
  left outer join       I_DeliveryDocument      as b on a.Delivery = b.DeliveryDocument  
  left outer join       ZI_PACKLIST_ITM         as d on a.Id = d.Id
  left outer join       I_DeliveryDocumentItem as c on c.DeliveryDocument = d.Delivery   
                                                    and  c.DeliveryDocumentItem =  d.Posnr                                            
  left outer join       I_SalesOrderItem  as e on e.SalesOrder = c.ReferenceSDDocument 
                                                    and e.SalesOrderItem = c.ReferenceSDDocumentItem
                                                    
  {
   key  c.DeliveryDocument,
   key  a.Revision,
   key  c.DeliveryDocumentItem,
        ceil( cast( d.Packqty as abap.dec( 16,2 ) )) as Packqty,
        d.Priority,
        d.Matnr,
        d.Maktx,
        d.Mateachpkg,
        ceil( cast( d.Qty as abap.dec( 16,2 ) ) ) as Qty,
        ltrim(e.UnderlyingPurchaseOrderItem,'0') as UnderlyingPurchaseOrderItem,
        d.Wtunit,
        @Semantics.quantity.unitOfMeasure: 'Wtunit'
        d.Eachnetwt,
        @Semantics.quantity.unitOfMeasure: 'Wtunit'
        d.Netwt,
        d.Growt,
        d.Eachgrowt,
        d.Meins  
  }
where a.Canind <> 'X'
group by 
c.DeliveryDocument,
a.Revision,
c.DeliveryDocumentItem,
d.Packqty,
d.Priority,
d.Matnr,
d.Maktx,
d.Mateachpkg,
d.Qty,
e.UnderlyingPurchaseOrderItem,
d.Wtunit,        
d.Eachnetwt,
d.Netwt,
d.Growt,
d.Eachgrowt,
d.Meins
