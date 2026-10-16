@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'loan type F4 view'
define view entity ZCDS_LOANTYPE 
as select from zdt_ltype
{

  key loantype
  }
group by loantype
       
