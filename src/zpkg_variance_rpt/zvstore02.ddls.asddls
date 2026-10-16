@AbapCatalog.sqlViewName: 'ZVSTORE002'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hard Coke'
@Metadata.ignorePropagatedAnnotations: true
define view ZVSTORE02
  as select distinct from I_MaterialDocumentItem_2 as a
    inner join            I_Product                as b on a.Material       = b.Product
                                                        and(
                                                          b.ProductGroup    = 'Z004'
                                                          or b.ProductGroup = 'Z016'
                                                          or b.ProductGroup = 'Z020'
                                                          or b.ProductGroup = 'Z030'
                                                          or b.ProductGroup = 'Z031'
                                                          or b.ProductGroup = 'Z032'
                                                          or b.ProductGroup = 'Z034'
                                                          or b.ProductGroup = 'Z039'
                                                        )
    inner join I_CostCenter as d on d.CostCenter = a.CostCenter
    inner join            zdt_costingpl_pc         as c on d.ProfitCenter = c.prctr
{
  key  a.MaterialDocument,
  key  a.MaterialDocumentItem,
  key  concat( substring(a.PostingDate, 5, 2) , substring(a.PostingDate, 1, 4) ) as mmyyyy,
  key  c.prctrclub,
       CompanyCodeCurrency,
       case GoodsMovementType
       when '201' then
       TotalGoodsMvtAmtInCCCrcy
       when '202' then
       TotalGoodsMvtAmtInCCCrcy * -1 end                                         as store
}
where
     a.GoodsMovementType = '201'
  or a.GoodsMovementType = '202'
