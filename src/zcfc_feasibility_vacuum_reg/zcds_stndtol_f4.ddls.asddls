@AbapCatalog.sqlViewName: 'ZSTNDTOLF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Marketing User-F4'
@Metadata.ignorePropagatedAnnotations: true

define view ZCDS_STNDTOL_F4
 as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDM_TOLSTD')
{
          @Semantics.text: true
  key text as CT_Standard
}
