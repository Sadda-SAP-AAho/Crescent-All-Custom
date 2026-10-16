@AbapCatalog.sqlViewName: 'Z_TYPEOFMOULD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Type of Moulding'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_TYPEOFMOULD
  as select distinct from zdt_mould as a
{
  key a.mould as Type_of_Mould,
      a.mould as Type_of_Mould_Name
}
