@AbapCatalog.sqlViewName: 'ZCDS_PO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Details for LC'

define view ZCDS_PO_DETAILS
  as select from    I_PurchaseOrderAPI01 as a
    left outer join I_Supplier           as b on a.Supplier = b.Supplier
    left outer join I_Plant              as c on a.SupplyingPlant = c.Plant
    left outer join I_CompanyCode        as d on a.CompanyCode = d.CompanyCode

{
  key a.PurchaseOrder,
      a.PurchasingOrganization,
      a.Supplier,
      a.ExchangeRate,
      b.SupplierFullName,
      c.PlantName,
      d.CompanyCodeName

}
