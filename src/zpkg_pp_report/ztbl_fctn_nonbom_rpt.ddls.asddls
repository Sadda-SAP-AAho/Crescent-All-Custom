@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_NONBOM_RPT

returns
{
  key mandt              : mandt;
  key postingdate        : sydate;
  key plant              : werks_d;
  key costcenter         : kostl;
  key material           : matnr;
  key ProductDescription : abap.char( 40 );
  key GLAccount          : hkont;
  key Conbase            : abap.char( 10 );
//      conqty             : abap.quan( 13,3 );
//      MaterialBaseUnit1  : meins;
//      issqty             : abap.quan( 13,3 );
//      MaterialBaseUnit2  : meins; 
      actissval          : abap.curr( 23, 2);
      currency           : waers;

}
implemented by method
  zcl_pp_nonbom=>get_data;