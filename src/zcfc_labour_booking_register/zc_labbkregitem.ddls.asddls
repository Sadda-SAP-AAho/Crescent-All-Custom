@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View for Labour Booking Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_LABBKREGITEM
  as projection on ZI_LABBKREGITEM
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Work Code'
      Workcode,
      @EndUserText.label: 'Work Name'
      Workname,
      @EndUserText.label: 'UoM'
      Uom,
      @EndUserText.label: 'Quantity'
      Quantity,
      @EndUserText.label: 'Rate'
      Rate,
      @EndUserText.label: 'Amount'
      Amount,
      @EndUserText.label: 'Approve Code'
      Aprvcode,
      @EndUserText.label: 'Approve Name'
      Aprvname,
      @EndUserText.label: 'Remark'
      Remark,
      /* Associations */
      _Head : redirected to parent ZC_LABBKREGHEAD
}
