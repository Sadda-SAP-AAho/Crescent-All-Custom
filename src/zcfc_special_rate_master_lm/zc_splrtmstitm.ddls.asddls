@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View of Special Rate Master LM - Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_SPLRTMSTITM
  as projection on ZI_SPLRTMSTITM
{
@UI.hidden: true
    key Id,
    @UI.hidden: true
    key Item,
    @EndUserText.label: 'Date From'
    Datefrom,
    @EndUserText.label: 'Date To'
    Dateto,
    @EndUserText.label: 'Currency'
    Currency,
    @EndUserText.label: 'Rate'
    Rate,
    /* Associations */
    _Head : redirected to parent ZC_SPLRTMSTHED
}

