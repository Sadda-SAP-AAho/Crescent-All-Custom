@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'License Header'
define root view entity ZC_LICENCE_HDR
  provider contract transactional_query
  as projection on ZI_LICENCE_HDR
{
      @EndUserText.label: 'ID'
  key Id,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'License No Int'
      @Consumption.valueHelpDefinition: [{ entity:{ element: 'ecomno', name:'ZR_LIC_F4' },
                                     distinctValues: true,
                                     useForValidation: true  }]
      Licenceint,
      @EndUserText.label: 'License No Ext'
      Licenceext,
      @EndUserText.label: 'License Type'
      Licencetype,
      @EndUserText.label: 'Currency'
      Liccurrency,
      @EndUserText.label: 'License Date'
      Licencedate,
      @EndUserText.label: 'License Status'
      Licencestatus,
      @EndUserText.label: 'Company Code'
      Companycode,
      @EndUserText.label: 'Export FC'
      Exportfc,
      @EndUserText.label: 'Import Fc'
      Importfc,
      @EndUserText.label: 'License Val'
      Licenceval,
      @EndUserText.label: 'Plan Duty Save'
      Plandutysaveinr,
      @EndUserText.label: 'Actual Duty Save'
      Actualdutysaveinr,
      @EndUserText.label: 'Remain Duty Save'
      Remaindutysave,
      @EndUserText.label: 'Date Valid From'
      Importvalidfrom,
      @EndUserText.label: 'Date Valid To'
      Importvalidto,
      @EndUserText.label: 'Import Exchange Rate'
      Importexchangerate,
      @EndUserText.label: 'Date Valid From'
      Exportvalidfrom,
      @EndUserText.label: 'Date Valid To '
      Exportvalidto,
      @EndUserText.label: 'Date Valid From(4y)'
      Exportvalid4yfrom,
      @EndUserText.label: 'Date Valid To(4y)'
      Exportvalid4yto,
      @EndUserText.label: 'Date Valid From(2y)'
      Exportvalid2yfrom,
      @EndUserText.label: 'Date Valid To(2y)'
      Exportvalid2yto,
      @EndUserText.label: 'Export Obligation(INR)'
      Expobigationinr,
      @EndUserText.label: 'Export Exchange Rate'
      Exportexchangerate,
      @EndUserText.label: 'Export Obligation(FC)'
      Expobigationfc,
      @EndUserText.label: 'Explicit Utilised(INR)'
      Explicutilisedinr,
      @EndUserText.label: 'Explicit Utilised(FC)'
      Explicutilisedfc,
      @EndUserText.label: 'Explicit Remain(INR)'
      Explicremaininr,
      @EndUserText.label: 'Explicit Remain(FC)'
      Explicremainfc,
      @EndUserText.label: 'Create Date'
      Createdat,
      @EndUserText.label: 'Created By'
      Createdby,
      Lastchangedby,
      Lastchangedat,
      Locallastchangedat,
      @EndUserText.label: 'Calculate'
      cal
}
