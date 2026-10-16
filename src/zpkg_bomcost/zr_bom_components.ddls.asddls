@EndUserText.label: 'CDS for BOM_Components'
@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZR_BOM_Components
  with parameters
    @Environment.systemField: #CLIENT
    mandt   : abap.clnt,
    p_matnr : matnr,
    p_werks : werks_d
returns
{
  key Mandt             : abap.clnt;
  key Material          : matnr;
      Plant             : werks_d;
//      ProductionVersion : verid;
      ValidityStartDate : abap.dats;
      ValidityEndDate   : abap.dats;
      BOMHeaderQty      : basmn;
      BOMHeaderQtyUnit  : meins;
      BOMLevel          : abap.int4;
      Parent            : matnr;
      Component         : matnr;
      BOMItemQty        : menge_d;
      BOMItemQtyUnit    : meins;
//      BaseUnit          : meins;
//      CoProduct         : matnr;
      productgroup      : matkl;

}
implemented by method
  ZCL_GET_BOM_COMPONENTS=>get_bom_component;