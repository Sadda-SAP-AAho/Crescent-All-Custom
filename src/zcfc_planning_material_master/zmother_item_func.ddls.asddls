@EndUserText.label: 'Table Function for Mother Item'
define table function ZMother_Item_func
with parameters 
@Environment.systemField: #CLIENT
P_Clnt : abap.clnt
returns {
 Client : abap.clnt;
 Mother_Item : abap.char(3);
 Child_Item : abap.char(3);
  
}
implemented by method zfunc_mother_item=>GET_MOTHER;