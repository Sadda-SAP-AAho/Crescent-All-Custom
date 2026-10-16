@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Product Sync'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PRODUCT_SYNC 
  as select from    I_ProductPlantBasic        as A
    inner join I_ProductDescription_2 as B on A.Product = B.Product and B.Language = $session.system_language
    inner join I_ProductValuationBasic as C on A.Product = C.Product and A.Plant = C.ValuationArea
    left outer join I_Product as E on A.Product = E.Product
    left outer join I_ProductTypeText_2 as D on E.ProductType = D.ProductType and D.Language = $session.system_language
    left outer join I_ProductGroupText_2 as F on E.ProductGroup = F.ProductGroup and F.Language = $session.system_language
    left outer join I_UnitOfMeasureText as G on A.BaseUnit = G.UnitOfMeasure and G.Language = $session.system_language
    
{
  key A.Product                 ,
  key A.Plant                   ,
      concat( concat( A.Product, '-' ), A.Plant )                    as SyncKey,
      B.ProductDescription      ,
      A._Plant.PlantName        ,
      A.BaseUnit                ,
      G.UnitOfMeasureName,
      D.ProductType,
      D.ProductTypeName,
      F.ProductGroup,
      F.ProductGroupText,
      C.ValuationClass,
      C.Currency,
      A.MRPType,
      @Semantics.amount.currencyCode: 'Currency'
      C.StandardPrice,
      C.PriceDeterminationControl,
      tstmpl_to_utcl( A._Product.LastChangeDateTime, 'NULL', 'NULL' )                          as UpdatedAt,
      tstmpl_to_utcl( A._Product.CreationDateTime  , 'NULL', 'NULL' )                          as CreatedAt
}
