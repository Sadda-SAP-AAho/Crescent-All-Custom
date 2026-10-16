@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Casted Item Print'
@Metadata.ignorePropagatedAnnotations: true
@UI.headerInfo: {typeName: 'Quality Inspection Report'}
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define view entity ZC_CASTITMSRLPRINT
  as select from ZI_CONF_ORD
{
 @Search.defaultSearchElement: true
      @UI.lineItem: [{ position: 10 , label:'Shop Floor Number' }]
      @EndUserText.label: 'Shop Floor Number'
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
    @UI.lineItem: [{ position: 40 , label:'Shop Floor Date' }]
      @EndUserText.label: 'Shop Floor Date'
      @UI.selectionField: [{ position: 50 }]
      _Head.Shpflrdt
}

where _Head.Opr = '0040'
