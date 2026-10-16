@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Licence External No F4'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_LICCENCE_EXT_F4
  as select distinct from zdt_epcg_hdr
{
  key      bukrs,
  key      ecomno,
           licno,
           fileno,
           licdate,
           waers
}
