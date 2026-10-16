@AbapCatalog.sqlViewName: 'Z_TYPEOFMOULD2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 help for Type of Moulding'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_TYPEOFMOULD1
   as select distinct from zdt_mould as a
{
  key a.mould as TypofMld

}
