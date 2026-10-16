@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Print Queue'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_PRINTQUEUE
  as select from zdt_print_queue
{
  key id,
      cbuser,
      printque,
      creationdate
}
