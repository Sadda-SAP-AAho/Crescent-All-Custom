@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Status log'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_bank_stat_log as select from zdt_appr_log
  association to parent ZI_bank_stat_HEAD as _Head on  $projection.Companycode   = _Head.Companycode
                                                  and $projection.Accountingdoc = _Head.Accountingdoc
                                                  and $projection.Fiscalyear    = _Head.Fiscalyear
{
    key accountingdoc as Accountingdoc,
    key fiscalyear as Fiscalyear,
    key companycode as Companycode,
    key apprlevel as Apprlevel,
    supplier as Supplier,
    actionedby as Actionedby,
    actionedon as Actionedon,
    actionedat as Actionedat,
    action as Action,
    apprcomment as Apprcomment,
     _Head // Make association public
}
