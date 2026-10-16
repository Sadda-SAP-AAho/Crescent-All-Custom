@AbapCatalog.sqlViewName: 'ZMKTUSERF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Marketing User-F4'
@Metadata.ignorePropagatedAnnotations: true

define view ZCDS_MKTUSER_F4
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDM_MKTUSER')
{

      @Semantics.text: true
  key text as Marketing_User
}
