@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Variance GL'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_VARIANCE_GL
  as projection on ZI_VARIANCE_GL
{
      @EndUserText.label: 'SI No.'
  key id,
      @EndUserText.label: 'Parameter'
  key Prefix,
      @EndUserText.label: 'GL Account'
      Glaccount
}
