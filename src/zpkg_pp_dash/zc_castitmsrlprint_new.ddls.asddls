@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Casted Item Print'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]

@UI.headerInfo: {typeName: 'Casted Item Print'}
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZC_CASTITMSRLPRINT_NEW
  provider contract transactional_query
  as projection on ZI_CASTITMSRLPRINT
{
      @UI.identification: [ { position: 10 }, { type: #FOR_ACTION, dataAction: 'zprintbarcode', label: 'Print', iconUrl: 'sap-icon://close-command-field' } ]
      @Search.defaultSearchElement: true
      @UI.lineItem: [{ position: 10 , label:'FG Item Code' }]
      @EndUserText.label: 'FG Item Code'
      @UI.selectionField: [{ position: 10 }]
  key Shpflrno,
      @UI.lineItem: [{ position: 20 , label:'Plant' }]
      @EndUserText.label: 'Plant'
      @UI.selectionField: [{ position: 20 }]
  key Plant,
      @UI.lineItem: [{ position: 30 , label:'Material' }]
      @EndUserText.label: 'Material'
      @UI.selectionField: [{ position: 30}]
  key Matnr,
      @UI.lineItem: [{ position: 40 , label:'Serial No' }]
      @EndUserText.label: 'Serial No'
      @UI.selectionField: [{ position: 40 }]
  key Serial,

      @EndUserText.label: 'Print Flag1'
      printflag1,
      flag


}
