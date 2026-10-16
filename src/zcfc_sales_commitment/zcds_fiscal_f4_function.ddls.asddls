@EndUserText.label: 'CDS Function for Fiscal Year F4'
@ClientHandling.clientSafe: true
@ClientHandling.algorithm: #SESSION_VARIABLE
@ClientHandling.type: #CLIENT_DEPENDENT
define table function ZCDS_Fiscal_F4_Function
//with parameters  
//@Environment.systemField: #CLIENT
//P_clnt : abap.clnt
returns {
Client : abap.clnt;
Fiscal_Year : abap.char(10);
  
}
implemented by method zamdp_fiscal_year=>GET_YEAR;