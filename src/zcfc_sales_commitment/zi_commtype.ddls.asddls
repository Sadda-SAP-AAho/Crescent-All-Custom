@AbapCatalog.sqlViewName: 'ZCOMMTYPE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Comittment Type'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_COMMTYPE 
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T (p_domain_name : 'ZDM_COMMTYPE')
{
    @Semantics.text: true
    key text as commtype
}
