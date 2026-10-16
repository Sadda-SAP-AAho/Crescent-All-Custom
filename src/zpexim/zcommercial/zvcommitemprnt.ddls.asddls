@AbapCatalog.sqlViewName: 'Z_VCOMMITM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commercial Print Item'
@Metadata.ignorePropagatedAnnotations: true
define view ZVCOMMITEMPRNT
  as select distinct from ZI_COMM_HED                as a
    left outer join       I_BillingDocument          as b on a.Commid = b.BillingDocument
    left outer join       I_BillingDocumentItem      as d on d.BillingDocument = b.BillingDocument

    left outer join       I_BillingDocumentItemBasic as e on  e.BillingDocument             = a.Commid
                                                          and e.BillingDocumentItem         = d.BillingDocumentItem
                                                          and e.ReferenceSDDocumentCategory = 'J'
    left outer join       I_BillingDocumentItemBasic as f on  f.BillingDocument         = a.Commid
                                                          and f.BillingDocumentItem     = d.BillingDocumentItem
                                                          and f.SalesSDDocumentCategory = 'C'
    left outer join       zdt_deldash_hdr            as c on c.delivery = e.ReferenceSDDocument
    left outer join       ZI_DELDASH_HDR             as k on  k.Delivery                    = d.ReferenceSDDocument
                                                          and d.ReferenceSDDocumentCategory = 'J'

    left outer join       I_SalesOrderItem           as g on  g.SalesOrder = d.SalesDocument
                                                          and g.SalesOrderItem = d.SalesDocumentItem
                                                          and g.Material   = d.Material

    left outer join       I_Customer                 as h on  b.SoldToParty = h.Customer
    left outer join       ZCDS_GSTINV                as i on  i.ReferenceSDDocument = e.ReferenceSDDocument
                                                          and i.ReferenceSDDocumentItem =  e.ReferenceSDDocumentItem
    left outer join       ZI_MATFLD                   as s on d.Product = s.Product
////                                                          and i.ReferenceSDDocumentCategory = 'J'
//    left outer join       I_BillingDocumentItemBasic as i on  i.ReferenceSDDocument         = e.ReferenceSDDocument
//                                                          and i.ReferenceSDDocumentItem =  e.ReferenceSDDocumentItem
////                                                          and i.ReferenceSDDocumentCategory = 'J'
//                                                          and i.BillingDocumentType         = 'F8'
//    left outer join       I_BillingDocument          as j on  j.BillingDocument          =  i.BillingDocument
//                                                          and j.AccountingTransferStatus <> 'E'
{
  key d.BillingDocument,
  key d.BillingDocumentItem,
      f.SalesDocument,
      e.ReferenceSDDocument,
//      g.MaterialByCustomer, "Commented by Infocus on 24th Feb 2026
     d.Product as MaterialByCustomer,
//      d.BillingDocumentItemText,  "Commented by Infocus on 24th Feb 2026
 s.Matlngtxt as BillingDocumentItemText,
      c.shipline,
      c.stuffdt,
      c.contno,
      h.CustomerName,
      g.PurchaseOrderByCustomer,
      g.CustomerPurchaseOrderDate,
      g.UnderlyingPurchaseOrderItem,
      g.PurchaseOrderByShipToParty,
//      i.BillingDocument as bill,
//      i.BillingDocument as gstinv, """"""""""""" Commented by Infocus on 24th Feb 2026 
//      i.CreationDate    as gstinvdt, """""""""""" Commented by Infocus on 24th Feb 2026 
      a.Commid as gstinv,        
      a.Documentdate as gstinvdt,
      k.Salesnoteref,
      d.BillingQuantityUnit,
      @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
      d.BillingQuantity
}
where
  k.Canind <> 'X' and c.canind <> 'X'
