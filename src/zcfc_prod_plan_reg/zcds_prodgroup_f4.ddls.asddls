@AbapCatalog.sqlViewName: 'ZPRODGROUPF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Group-F4'
@Metadata.ignorePropagatedAnnotations: true

define view ZCDS_PRODGROUP_F4
  as select from I_ProductGroupText_2 as a

{
  key a.ProductGroup     as matgrpcode,
      a.ProductGroupName as matgrpname
}

where
  a.Language = 'E'
