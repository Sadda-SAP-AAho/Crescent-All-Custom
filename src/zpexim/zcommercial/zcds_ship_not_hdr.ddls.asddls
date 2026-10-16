@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'shipping notification print data'
define view entity ZCDS_SHIP_NOT_HDR
  as select distinct from ZI_COMM_HED                as a
    left outer join       I_BillingDocument          as b on a.Commid = b.BillingDocument
    left outer join       zdt_mm_pc_tmg              as c on b.CompanyCode = c.cocode
    left outer join       I_Customer                 as d on b.SoldToParty = d.Customer
    left outer join       I_BillingDocumentItemBasic as e on  e.BillingDocument             = a.Commid
                                                          and e.ReferenceSDDocumentCategory = 'J'
                                                          and e.BillingDocumentType         = 'F8'
    left outer join       I_BillingDocument          as f on  f.BillingDocument          =  e.BillingDocument
                                                          and f.AccountingTransferStatus <> 'E'
    left outer join       I_SalesOrderItem           as g on g.SalesOrder = a.Sono
{ 
  key b.BillingDocument as billingdoc,
   b.CreationDate,
   b.CreationTime,
   f.BillingDocument as gstinv,
   f.CreationDate as gstinvdt,
   c.caddress1,
   c.caddress2,
   c.name,
   d.CustomerFullName,
   g.PurchaseOrderByCustomer,
   g.CustomerPurchaseOrderDate,
   g.UnderlyingPurchaseOrderItem,
   g.ExternalItemID
   
  }
