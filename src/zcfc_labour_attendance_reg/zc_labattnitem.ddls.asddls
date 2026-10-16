@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View for Labour Attendance Register-Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_LABATTNITEM 
  as projection on ZI_LABATTNITEM
{
    @EndUserText.label: 'ID'
    key Id,
    @EndUserText.label: 'Item'
    key Item,
    @EndUserText.label: 'Contractor Code'
    Contcode,
    @EndUserText.label: 'Contractor Name'
    Contname,
    @EndUserText.label: 'Department Code'
    Deptcode,
    @EndUserText.label: 'Department Name'
    Deptname,
    @EndUserText.label: 'Category'
    Category,
    @EndUserText.label: 'Operation Code'
    Oprcode,
    @EndUserText.label: 'Operation Name'
    Oprname,
    @EndUserText.label: 'No. of Heads'
    Noofhead,
    /* Associations */
    _Head : redirected to parent ZC_LABATTNHEAD
}
