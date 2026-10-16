@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Monthly Budget-Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_MONTHBUD_ITM
  as projection on ZI_MONTHBUD_ITM
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Cost Center Code'
      Cstcntrcd,
      @EndUserText.label: 'Cost Center Name'
      Cstcntrnam,
      @EndUserText.label: 'GL Code'
      Glcode,
      @EndUserText.label: 'GL Name'
      Glname,
      @EndUserText.label: 'April'
      Aprilamt,
      @EndUserText.label: 'May'
      Mayamt,
      @EndUserText.label: 'June'
      Juneamt,
      @EndUserText.label: 'July'
      Julyamt,
      @EndUserText.label: 'August'
      Augamt,
      @EndUserText.label: 'September'
      Septamt,
      @EndUserText.label: 'October'
      Octamt,
      @EndUserText.label: 'November'
      Novamt,
      @EndUserText.label: 'December'
      Decamt,
      @EndUserText.label: 'January'
      Janamt,
      @EndUserText.label: 'February'
      Febamt,
      @EndUserText.label: 'March'
      Marchamt,
      /* Associations */
      _Head : redirected to parent ZC_MONTHBUD_HED
}
