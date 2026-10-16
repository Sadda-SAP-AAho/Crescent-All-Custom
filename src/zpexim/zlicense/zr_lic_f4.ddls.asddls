@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'License No F4'
define view entity ZR_LIC_F4
  as select distinct from ZI_LICCENCE_EXT_F4
{
      @EndUserText.label : 'Company Code'
  key bukrs,
      @EndUserText.label : 'Licence No'
  key ecomno,
      @EndUserText.label : 'Licence No External'
      licno,
      @EndUserText.label : 'Licence File No'
      fileno,
      @EndUserText.label : 'Licence Date'
      licdate,
      @EndUserText.label : 'Currency'
      waers
}
