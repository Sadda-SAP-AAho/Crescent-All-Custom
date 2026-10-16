@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Doctype view help'
define view entity ZCDS_DOC_F4 
as select distinct from  zdt_ltype 

{
key documenttype,
key loantype
}

