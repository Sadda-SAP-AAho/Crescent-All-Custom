@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FD Outgoing GL'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_FDOUTGL

  as projection on ZR_FDOUTGL
{

  key id,
  key item,
      @EndUserText.label: 'GL Account'
      glaccount,
      @EndUserText.label: 'House Bank ID'
      housebankid,
      @EndUserText.label: 'Account ID'
      accountid,
      @EndUserText.label: 'Bank Reference'
      bankreference,
      /* Associations */
      _head : redirected to parent ZC_FDHEAD

}
