@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for ZI_SPO_SES'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_SPO_SES
  provider contract transactional_query
  as projection on ZI_SPO_SES

{
  
@UI.lineItem: [
    {
      position   : 90,
      type       : #FOR_ACTION,
      dataAction : 'ServicePo',
      label      : 'Service PO'
    }
  ]

//key Id,
      @Consumption.valueHelpDefinition: [{
            entity: {
              name: 'ZI_COMM_ID_VH',
              element: 'Commid'
            }
          }]
  key Commid
//      Commdate,
//      servicepobt,
//      poupd,
//      Taxcode,
//      Profitcenter,
//      Costcenter
}
