@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Details-Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MATDETAILS
  as select from    I_Product                     as a
    inner join      I_ProductPlantBasic           as b on b.Product = a.Product
    inner join      I_Plant                       as c on c.Plant = b.Plant
    left outer join I_ProductStorageLocationBasic as d on  d.Product = a.Product
                                                       and d.Plant   = b.Plant
    left outer join I_ProductValuationBasic       as e on  e.Product       = a.Product
                                                       and e.ValuationArea = b.Plant
    left outer join I_ProductText                 as f on  f.Product  = a.Product
                                                       and f.Language = 'E'
    left outer join I_UnitOfMeasure               as g on g.UnitOfMeasure = a.BaseUnit

{
  key a.Product                     as Material,
  key b.Plant,
  key d.StorageLocation,
      c.SalesOrganization           as CompanyCode,
      e.ValuationArea,
      e.ValuationClass,
      a.ProductType,
      a.ProductGroup,
      a.ExternalProductGroup,
      b.PurchasingGroup,
      f.ProductName                 as MatDesc,
      g.UnitOfMeasure_E             as BaseUoM,
      e.Currency,
      e.InventoryValuationProcedure as PriceControl


}
