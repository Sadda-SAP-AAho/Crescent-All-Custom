@EndUserText.label: 'Enhancement Check Validation'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_EnhancementCheckVal
  as select from zdt_enhcheck
  association to parent ZI_EnhancementCheckVal_S as _EnhancementCheckAll on $projection.SingletonID = _EnhancementCheckAll.SingletonID
{
      @EndUserText.label: 'Enhancement Id'
  key enhid    as Enhid,
      @EndUserText.label: 'Enhancement Text'
      enhtext  as Enhtext,
      @EndUserText.label: 'De-Active Check '
      deactive as Deactive,
      @Consumption.hidden: true
      1        as SingletonID,
      _EnhancementCheckAll

}
