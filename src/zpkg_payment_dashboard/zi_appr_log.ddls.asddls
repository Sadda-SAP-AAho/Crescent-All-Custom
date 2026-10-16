@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Appr Log'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_APPR_LOG
  as select from zdt_appr_log
  association to parent ZI_PAYMENT_HEAD as _Head on  $projection.Companycode   = _Head.Companycode
                                                 and $projection.Accountingdoc = _Head.Accountingdoc
                                                 and $projection.Fiscalyear    = _Head.Fiscalyear
{
  key accountingdoc as Accountingdoc,
  key fiscalyear    as Fiscalyear,
  key companycode   as Companycode,
  key apprlevel     as Apprlevel,
      actionedby    as Actionedby,
      actionedon    as Actionedon,
      actionedat    as Actionedat,
      action        as Action,
      apprcomment   as Apprcomment,
      _Head // Make association public
}
