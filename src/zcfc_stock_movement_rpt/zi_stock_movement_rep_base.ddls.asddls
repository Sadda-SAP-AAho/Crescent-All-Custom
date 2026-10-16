@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root View For Stock Overview Rep Base'
@Metadata.allowExtensions: true
define  view entity ZI_STOCK_MOVEMENT_REP_BASE
  with parameters
    p_date_low  : zde_date,
    p_date_high : zde_date

  as select from ZR_STOCK_MOVEMENT_REP_BASE(
                 p_date_low  : $parameters.p_date_low,
                 p_date_high : $parameters.p_date_high
                 )
     association [1] to ZR_PRODUCT_GROUP_TEXT as _product_grp_txt on $projection.MaterialGroup = _product_grp_txt.ProductGroup  

{
  @ObjectModel.text.association: '_product_grp_txt'
  key MaterialGroup,
  key Plant,
      open_stk_qty,
      rcvd_po_qty,
      rcvd_mo_qty_unsl,
      rcvd_mo_qty_resl,
      foundary_ret_qty,
      oth_rcv_qty,
      trnsf_in_qty,
      SLS_RET_QTY,
      SLS_DELV_QTY,
      iss_prd_qty,
      oth_iss_QTY,
      RET_PO_QTY,
      trans_out_qty,
      totalrcvdqty,
      totalissueqty,
      closing_stk,
      unit_of_measure,
      _product_grp_txt

}
