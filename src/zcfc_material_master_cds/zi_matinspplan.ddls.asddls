@AbapCatalog.sqlViewName: 'ZMATINSPPLAN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Insp Plan of Material'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_MATINSPPLAN
  as select from    I_Product                    as a
    left outer join I_ProductPlantBasic          as b on a.Product = b.Product
    left outer join I_InspPlnMatlAssgmtVersion_2 as c on  a.Product   =  c.Material
                                                      and b.Plant     =  c.Plant
                                                      and c.IsDeleted <> 'X'
{
  key a.Product,
  key b.Plant,
      max ( c.InspectionPlanGroup ) as InspPlanGrp
}

group by
  a.Product,
  b.Plant
