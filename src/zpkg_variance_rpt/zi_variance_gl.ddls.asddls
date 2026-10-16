@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Variance GL'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZI_VARIANCE_GL
  as select from zdt_variance_gl
{
      @EndUserText.label: 'SI No.'
  key id        as id,
      @EndUserText.label: 'Parameter'
  key prefix    as Prefix,
      @EndUserText.label: 'GL Account'
      glaccount as Glaccount

}
