@EndUserText.label: 'Recursive BOM Components for SO'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ClientHandling.clientSafe: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define table function ZTF_SOCompBOM
  with parameters
    //  @Environment.systemField: #CLIENT
    //    p_clnt : mandt,
    p_so : abap.numc(10)
returns
{
  key client                        : mandt;
  key SalesOrderNo                  : vbeln;
  key SORowNumber                   : posnr;
  key Level                         : int4;
  key ComponentMaterial             : matnr;
      componentmaterialname         : abap.char(40);
      MaterialNo                    : matnr;
      Plant                         : werks_d;
      soqty                         : menge_d;
      ComponentQty                  : menge_d;
      ComponentUnit                 : meins;
      ProductGroup                  : abap.char(4);
      ProductType                   : abap.char(4);
      Component_Material_Group_Name : abap.char(40);
      Component_Stock               : menge_d;
      MaterialBaseUnit              : meins;
      purchaserequisition           : banfn;
      purchaserequisitionitem       : bnfpo;
      pr_creationdate               : datum;
      pr_qty                        : menge_d;
      BaseUnit                      : bamei;
      ordered_quantity              : bsmng;
      purchaseorder                 : bstnr;
      purchaseorderitem             : bstpo;
      quantityinbaseunit            : menge_d;
      open_po_qty                   : bsmng;
      open_pr_qty                   : bsmng;
      IsFinalComponent              : abap_boolean;
      Pallet_PCD_Box_Size           : abap.char(100);
      BOLT_SIZE                     : abap.char(100);
      Qty_of_Pallet_PCD_Box         : abap.dec(13,3);
      Std_No_of_Pcs_Pack            : abap.dec(13,3);
      Qty_of_Bolt                   : abap.dec(13,3);
      Bolt_Reqd                     : menge_d;
      Pallet_Reqd                   : menge_d;
      shop_floor_no                 : abap.char(10);

}
implemented by method
  zcl_amdp_so_bom=>get_bom_explosion;