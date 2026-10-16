@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Wise Email Maintain'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_VEND_MAIL 
as projection on ZI_VEND_MAIL
{
    @UI.hidden: true
    key Id,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Vendor'
    Lifnr,
    @UI.hidden: true
    Reflifnr,
    @EndUserText.label: 'Email 1'
    Mail1,
    @EndUserText.label: 'Email 2'
    Mail2,
    @EndUserText.label: 'Email 3'
    Mail3,
    @EndUserText.label: 'Email 4'
    Mail4,
    @EndUserText.label: 'Email 5'
    Mail5,
    @EndUserText.label: 'Copy'
    Copy
}
