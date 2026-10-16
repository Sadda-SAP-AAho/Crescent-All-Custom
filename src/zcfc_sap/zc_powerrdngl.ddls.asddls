@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'CONSUMPTION FOR POWER READING LINE'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_POWERRDNGL as projection on ZI_POWERRDNGL
{
    @EndUserText.label: 'ID'
    key Id,
    @EndUserText.label: 'Item'
    key Item,
    @EndUserText.label: 'Sub Head Code'
    Subhdcd,
    @EndUserText.label: 'Sub Head Name'
    Subhdnm,
    @EndUserText.label: 'Head Code'
    Headcd,
    @EndUserText.label: 'Head Name'
    Headnm,
    @EndUserText.label: 'Meter Type'
    Metertyp,
    @EndUserText.label: 'Meter Reading'
    Meterrdng,
    /* Associations */
    _Head : redirected to parent ZC_POWERRDNGH 
}
