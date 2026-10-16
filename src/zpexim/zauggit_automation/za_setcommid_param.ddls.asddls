@EndUserText.label: 'Parameter for commid'
define abstract entity ZA_SETCOMMID_PARAM
  
{
  @EndUserText.label: 'Commercial Invoice'
  @Consumption.valueHelpDefinition: [{
    entity    : {
      name    : 'ZI_COMM_ID_VH',
      element : 'Commid'
    },
    useForValidation: true
  }]
  NewCommID : abap.char(10);

}
