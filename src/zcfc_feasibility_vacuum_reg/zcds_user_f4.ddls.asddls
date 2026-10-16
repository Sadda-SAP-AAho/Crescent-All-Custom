@AbapCatalog.sqlViewName: 'ZUSERF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PD User-F4'
@Metadata.ignorePropagatedAnnotations: true

define view ZCDS_USER_F4
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDM_PDUSER')
{

      @Semantics.text: true
  key text as PD_User
}
