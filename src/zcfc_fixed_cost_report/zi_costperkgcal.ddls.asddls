@AbapCatalog.sqlViewName: 'ZCOSTPERKGCAL'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cost Per KG Calculation'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_COSTPERKGCAL
  as select from ZI_FIXEDCOST_BASIC
{
  key Hedmaterial,
  key Plant,
      cast ( ( case when ParentNetwt is null then 1
                    else ParentNetwt end ) as abap.dec( 16, 3 ) ) as ParentNetwt,
      sum( FixedCost )                                            as Total_FC1,
      sum( FixedCost2 )                                           as Total_FC2

}

group by
  Hedmaterial,
  Plant,
  ParentNetwt
