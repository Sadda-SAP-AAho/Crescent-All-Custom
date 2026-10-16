@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table function for Metal Crate'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FCTN_METALCRATE1
with parameters 
    @Environment.systemField: #CLIENT
    mandt : abap.clnt
returns
{
 key mandt                : abap.clnt;
 key itemcode             : vbeln;
 key billofmaterialcategory : abap.char(1);             
 key billofmaterial       : abap.char(8);
 key BillOfMaterialVariant : abap.char(2);
 key BillOfMaterialVersion : abap.char(4);
 key BillOfMaterialItemNodeNumber : abap.char(8);
 key HeaderChangeDocument : abap.char(12);
 key material   : matnr;
 key plant       : werks_d;
 BillOfMaterialItemQuantity : abap.dec(13,3); 
 
  
}
implemented by method zcl_metal_crate_rpt=>get_data;