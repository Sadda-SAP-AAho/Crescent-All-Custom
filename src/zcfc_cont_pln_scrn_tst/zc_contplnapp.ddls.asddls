@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View of Cont. Planning App'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_CONTPLNAPP
  provider contract transactional_query
  as projection on ZI_CONTPLNAPP
{
      @EndUserText.label: 'ID'
  key ID,
      @EndUserText.label: 'Plant Code'
      Plantcode,
      @EndUserText.label: 'Plant name'
      Plantname,
      @EndUserText.label: 'Final Destination Code'
      FDCode,
      @EndUserText.label: 'Final Destination Name'
      FDName,
      @EndUserText.label: 'Port Entry From Date'
      PrtEntFrmDt,
      @EndUserText.label: 'Port Entry To Date'
      PrtEntToDt,
      @EndUserText.label: 'Vessel Name & Voyage'
      VsslNmVyg,
      @EndUserText.label: 'Customer Code'
      CustCode,
      @EndUserText.label: 'No. of Container Planned'
      NoContPlnnd,
      @EndUserText.label: 'Remarks(Factory)'
      RmrkFact,
      @EndUserText.label: 'Remarks(Logistics)'
      RmrkLogst
}
