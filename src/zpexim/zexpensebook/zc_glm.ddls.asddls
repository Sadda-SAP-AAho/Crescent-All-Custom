@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header details'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_GLM
provider contract transactional_query
as projection on ZI_GLM
{
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Expense Type'
    key Exptyp,
    @EndUserText.label: 'Description'
    key Descr,
    @UI.hidden: true
    @EndUserText.label: 'per Container / Shipment'
    key Psc,
    @UI.hidden: true
    @EndUserText.label: 'GL Details'
    key Gla,
    @UI.hidden: true
    @EndUserText.label: 'GL Code (SAP B1)'
    key Glc1,
    @EndUserText.label: 'GL Code (SAP HANA)'
    key Glc2
}
