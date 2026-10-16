@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption for Spcl Price for M/L Head'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_SPCLPRCEMLH 
provider contract transactional_query
as projection on ZI_SPCLPRCEMLH
{
  @EndUserText.label: 'ID'
  key Id,
  @EndUserText.label: 'Plant Code'
  Loctncd,
  @EndUserText.label: 'Plant Name'
  Loctnnm,
  @EndUserText.label: 'Cost Code'
  Costcd,
  @EndUserText.label: 'Cost Name'
  Costnm,
  /* Associations */
  _Item : redirected to composition child ZC_SPCLPRCEMLL
}
