@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Print Queue'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_PRINTQUEUE
  provider contract transactional_query
  as projection on ZR_PRINTQUEUE
{
      @EndUserText.label: 'ID'
  key id,
      @EndUserText.label: 'CB User ID'
      cbuser,
      @EndUserText.label: 'Print Queue Name'
      printque,
      creationdate
}
