@AbapCatalog.sqlViewName: 'ZVHARDCOKE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hard Coke'
@Metadata.ignorePropagatedAnnotations: true
define view ZVHARDCOKEDI
  as select distinct from I_MaterialDocumentItem_2 as a
    inner join            I_Product                as b on a.Material       = b.Product
                                                        and(
                                                          b.ProductGroup    = 'Z018'
                                                          or b.ProductGroup = 'Z019'
                                                        )
    inner join I_CostCenter as d on d.CostCenter = a.CostCenter
    inner join            zdt_costingpl_pc         as c on d.ProfitCenter = c.prctr
{
  key  MaterialDocument,
  key  MaterialDocumentItem,
  key  concat( substring(a.PostingDate, 5, 2) , substring(a.PostingDate, 1, 4) ) as mmyyyy,
  key  prctrclub,
       CompanyCodeCurrency,
       case GoodsMovementType
       when '201' then
       TotalGoodsMvtAmtInCCCrcy
       when '202' then
       TotalGoodsMvtAmtInCCCrcy * -1 end                                         as hardcoke
}
where
     a.GoodsMovementType = '201'
  or a.GoodsMovementType = '202'
