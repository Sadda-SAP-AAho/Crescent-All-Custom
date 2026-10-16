@AbapCatalog.sqlViewName: 'Z_CAPCATEGORY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Capacity Category'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_CAPCATEGORY as select from I_UnitOfMeasure as a
{
    key ( case when a.UnitOfMeasure = 'BQG' then 'Box'
               else 'Weight' end ) as Capacity_Category 
}

where ( a.UnitOfMeasure = 'BQG'
or a.UnitOfMeasure = 'BQK' )
