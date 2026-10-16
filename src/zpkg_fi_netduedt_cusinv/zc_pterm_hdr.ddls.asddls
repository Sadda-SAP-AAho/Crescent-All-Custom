@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Payment Terms'
@Metadata.allowExtensions: true
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_PTERM_HDR 
provider contract transactional_query
as projection on ZI_PTERM_HDR
{
    @EndUserText.label: 'ID'
    key Id,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Payment Terms'
    Zterm,
    @EndUserText.label: 'Payment Terms Description'
    Pdesc,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Based on'
    Basis,
    @EndUserText.label: 'Based on Text'
    Basistxt,
    @EndUserText.label: 'No of Days'
    Noofday,
    @EndUserText.label: 'Creation Date'
    Credt,
    @EndUserText.label: 'Last Changed Date'
    Lastchngdt
}
