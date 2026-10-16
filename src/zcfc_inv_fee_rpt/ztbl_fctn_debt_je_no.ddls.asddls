@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function of Debtors JE No'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_DEBT_JE_NO
returns
{
  key mandt        : mandt;
  key jeno : abap.char(10);
  key debtjeno     : abap.char(255);

}

implemented by method
  zcl_dbt_je_no=>GET_DATA;