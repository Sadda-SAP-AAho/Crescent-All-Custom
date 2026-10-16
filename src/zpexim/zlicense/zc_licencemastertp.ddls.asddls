@Search.searchable: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'License Master'
define root view entity ZC_LicenceMasterTP

  provider contract transactional_query
  as projection on ZR_LicenceMasterTP

{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
  key InternalLicencenumber,
  
  
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @EndUserText.quickInfo: 'Licence Number'
      @EndUserText.label: 'Licence Number'
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'ZI_LICENSE_F4',
          element: 'Licencenumber'
        }
      } ]

      Licencenumber,

      @EndUserText.quickInfo: 'Licence Type'
      @EndUserText.label: 'Licence Type'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Consumption.valueHelpDefinition: [{
        entity: {
            name: 'ZI_LICENCE_TYPE_F4',
            element: 'value_low' },
        distinctValues: true
      } ]
      Licencetype,

      @EndUserText.quickInfo: 'Licence Date'
      @EndUserText.label: 'Licence Date'
      Licencedate,

      @EndUserText.quickInfo: 'Import Valid From'
      @EndUserText.label: 'Import Valid From'
      Importvalidfrom,

      @EndUserText.quickInfo: 'Import Valid To'
      @EndUserText.label: 'Import Valid To'
      Importvalidto,

      @EndUserText.quickInfo: 'Import Exchange Rate'
      @EndUserText.label: 'Import Exchange Rate'
      Importexchangerate,

      @EndUserText.quickInfo: 'Duty Saved USD'
      @EndUserText.label: 'Duty Saved USD'
      @Semantics.amount.currencyCode: 'ImportvalueusdC'
      ImportvalueusdV,

      @EndUserText.label: 'Duty Saved USD'
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
      ImportvalueusdC,

      @EndUserText.quickInfo: 'Duty Saved INR'
      @EndUserText.label: 'Duty Saved INR'
      @Semantics.amount.currencyCode: 'ImportvalueinrC'
      ImportvalueinrV,

      @EndUserText.label: 'Duty Saved INR'
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
      ImportvalueinrC,

      @EndUserText.label: 'BOE Usage'
      BOEUsage,

      @EndUserText.quickInfo: 'Export Valid From'
      @EndUserText.label: 'Export Valid From'
      Exportvalidfrom,

      @EndUserText.quickInfo: 'Export Valid To'
      @EndUserText.label: 'Export Valid To'
      Exportvalidto,

      @EndUserText.quickInfo: 'Export Exchange Rate'
      @EndUserText.label: 'Export Exchange Rate'
      Exportexchangerate,

      @EndUserText.quickInfo: 'Export Value USD'
      @EndUserText.label: 'Export Value USD'
      @Semantics.amount.currencyCode: 'ExportvalueusdC'
      ExportvalueusdV,

      @EndUserText.label: 'Export Value USD'
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
      ExportvalueusdC,

      @EndUserText.quickInfo: 'Export Value INR'
      @EndUserText.label: 'Export Value INR'
      @Semantics.amount.currencyCode: 'ExportvalueinrC'
      ExportvalueinrV,

      @EndUserText.label: 'Export Value INR'
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
      ExportvalueinrC,

      @EndUserText.label: 'Shipping Usage'
      ShipUsage,

      @Semantics.systemDateTime.createdAt: true
      @EndUserText.quickInfo: 'Created On'
      @EndUserText.label: 'Created On'
      CreatedAt,

      @Semantics.user.createdBy: true
      @EndUserText.quickInfo: 'Created By'
      @EndUserText.label: 'Created By'
      CreatedBy,

      @Semantics.user.lastChangedBy: true
      @EndUserText.quickInfo: 'Last Changed By'
      @EndUserText.label: 'Last Changed By'
      LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      @EndUserText.quickInfo: 'Last Changed On'
      @EndUserText.label: 'Last Changed On'
      LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt
}

