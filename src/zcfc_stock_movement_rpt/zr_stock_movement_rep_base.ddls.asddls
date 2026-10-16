@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base CDS View for Stock Movement Report'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_STOCK_MOVEMENT_REP_BASE
  with parameters
    p_date_low  : zde_date,
    p_date_high : zde_date


  as select from    ZR_MATGRP_MASTER as _matgrp



    left outer join ZR_OPENING_STOCK_CALC(
                    p_date_low  : $parameters.p_date_low,
                    p_date_high : $parameters.p_date_high
                    )                as _open_stock_calc on  _matgrp.MaterialGroup = _open_stock_calc.ProductGroup
                                                         and _matgrp.Plant         = _open_stock_calc.Plant


    left outer join ZR_RCVD_PO_QTY(
                    p_date_low  : $parameters.p_date_low,
                    p_date_high : $parameters.p_date_high
                    )                as _rcvd_po_qty     on  _matgrp.MaterialGroup = _rcvd_po_qty.ProductGroup
                                                         and _matgrp.Plant         = _rcvd_po_qty.Plant


    left outer join ZR_RCVD_PROD_QTY_UNSL(
                    p_date_low  : $parameters.p_date_low,
                    p_date_high : $parameters.p_date_high
                    )                as _prod_qty_unsl   on  _matgrp.MaterialGroup = _prod_qty_unsl.ProductGroup
                                                         and _matgrp.Plant         = _prod_qty_unsl.Plant


    left outer join ZR_RCVD_PROD_QTY_RESL(
                    p_date_low  : $parameters.p_date_low,
                    p_date_high : $parameters.p_date_high
                    )                as _prod_qty_resl   on  _matgrp.MaterialGroup = _prod_qty_resl.ProductGroup
                                                         and _matgrp.Plant         = _prod_qty_resl.Plant

    left outer join ZR_FOUNDARY_RET_CALC(
                    p_date_low  : $parameters.p_date_low,
                    p_date_high : $parameters.p_date_high
                    )                as _found_ret_qty   on  _matgrp.MaterialGroup = _found_ret_qty.ProductGroup
                                                         and _matgrp.Plant         = _found_ret_qty.Plant

    left outer join ZR_OTH_RCVD_QTY(
                    p_date_low  : $parameters.p_date_low,
                    p_date_high : $parameters.p_date_high
                    )                as _oth_rcv_qty     on  _matgrp.MaterialGroup = _oth_rcv_qty.ProductGroup
                                                         and _matgrp.Plant         = _oth_rcv_qty.Plant

    left outer join ZR_TRNSF_QTY(
                    p_date_low  : $parameters.p_date_low,
                    p_date_high : $parameters.p_date_high
                    )                as _trnsf_in_qty    on  _matgrp.MaterialGroup = _trnsf_in_qty.ProductGroup
                                                         and _matgrp.Plant         = _trnsf_in_qty.Plant


    left outer join ZR_SLS_RET_QTY(
                    p_date_low  : $parameters.p_date_low,
                    p_date_high : $parameters.p_date_high
                    )                as _SLS_RET_QTY     on  _matgrp.MaterialGroup = _SLS_RET_QTY.ProductGroup
                                                         and _matgrp.Plant         = _SLS_RET_QTY.Plant


    left outer join ZR_SLS_DELV_QTY(
                    p_date_low  : $parameters.p_date_low,
                    p_date_high : $parameters.p_date_high
                    )                as _SLS_DELV_QTY    on  _matgrp.MaterialGroup = _SLS_DELV_QTY.ProductGroup
                                                         and _matgrp.Plant         = _SLS_DELV_QTY.Plant


    left outer join ZR_ISS_PROD_QTY(
                    p_date_low  : $parameters.p_date_low,
                    p_date_high : $parameters.p_date_high
                    )                as _iss_prd_qty     on  _matgrp.MaterialGroup = _iss_prd_qty.ProductGroup
                                                         and _matgrp.Plant         = _iss_prd_qty.Plant


    left outer join ZR_OTH_ISS_QTY(
                    p_date_low  : $parameters.p_date_low,
                    p_date_high : $parameters.p_date_high
                    )                as _oth_iss_QTY     on  _matgrp.MaterialGroup = _oth_iss_QTY.ProductGroup
                                                         and _matgrp.Plant         = _oth_iss_QTY.Plant


    left outer join ZR_RET_AGNST_PO_QTY(
                    p_date_low  : $parameters.p_date_low,
                    p_date_high : $parameters.p_date_high
                    )                as _RET_PO_QTY      on  _matgrp.MaterialGroup = _RET_PO_QTY.ProductGroup
                                                         and _matgrp.Plant         = _RET_PO_QTY.Plant

    left outer join ZR_TRNSF_OUT_QTY(
                    p_date_low  : $parameters.p_date_low,
                    p_date_high : $parameters.p_date_high
                    )                as _TRNSF_OUT_QTY   on  _matgrp.MaterialGroup = _TRNSF_OUT_QTY.ProductGroup
                                                         and _matgrp.Plant         = _TRNSF_OUT_QTY.Plant



{


  key _matgrp.MaterialGroup,
  key _matgrp.Plant,
      _open_stock_calc.openstock              as open_stk_qty,
      _rcvd_po_qty.rcvd_po_qty                as rcvd_po_qty,
      _prod_qty_unsl.rcvd_mo_qty_unsl         as rcvd_mo_qty_unsl,
      _prod_qty_resl.rcvd_mo_qty_resl         as rcvd_mo_qty_resl,
      _found_ret_qty.foundary_ret_qty         as foundary_ret_qty,
      _oth_rcv_qty.oth_rcvd_qty               as oth_rcv_qty,
      _trnsf_in_qty.transf_qty                as trnsf_in_qty,
      _SLS_RET_QTY.sls_ret_qty                as SLS_RET_QTY,
      _SLS_DELV_QTY.sls_delv_qty              as SLS_DELV_QTY,
      _iss_prd_qty.iss_prod_qty               as iss_prd_qty,
      _oth_iss_QTY.oth_iss_qty                as oth_iss_QTY,
      _RET_PO_QTY.ret_po_qty                  as RET_PO_QTY,
      _TRNSF_OUT_QTY.transf_qty               as trans_out_qty,
      //( _oth_rcv_qty.oth_rcvd_qty + _prod_qty_unsl.rcvd_mo_qty_unsl + _prod_qty_resl.rcvd_mo_qty_resl ) as totalrcvdqty,
      (
      coalesce(_oth_rcv_qty.oth_rcvd_qty, 0) +
      coalesce(_prod_qty_unsl.rcvd_mo_qty_unsl, 0) +
      coalesce(_prod_qty_resl.rcvd_mo_qty_resl, 0) +
      coalesce(_rcvd_po_qty.rcvd_po_qty, 0) +
      coalesce(_trnsf_in_qty.transf_qty, 0) +
      coalesce(_SLS_RET_QTY.sls_ret_qty, 0)
      )                                       as totalrcvdqty,
      //( _iss_prd_qty.iss_prod_qty + _oth_iss_QTY.oth_iss_qty ) as totalissueqty
      (
      coalesce(_iss_prd_qty.iss_prod_qty, 0) +
      coalesce(_oth_iss_QTY.oth_iss_qty, 0) +
      coalesce(_SLS_DELV_QTY.sls_delv_qty, 0) +
      coalesce(_TRNSF_OUT_QTY.transf_qty  , 0) + 
      coalesce(_RET_PO_QTY.ret_po_qty, 0)
      )                                       as totalissueqty,

      ( coalesce( _open_stock_calc.openstock,0) + coalesce(_oth_rcv_qty.oth_rcvd_qty, 0) +
      coalesce(_prod_qty_unsl.rcvd_mo_qty_unsl, 0) + coalesce(_prod_qty_resl.rcvd_mo_qty_resl, 0) +
             coalesce(_rcvd_po_qty.rcvd_po_qty, 0) +
      coalesce(_trnsf_in_qty.transf_qty, 0) +
      coalesce(_SLS_RET_QTY.sls_ret_qty, 0) -
      coalesce(_iss_prd_qty.iss_prod_qty, 0) -
      coalesce(_oth_iss_QTY.oth_iss_qty, 0) -       coalesce(_SLS_DELV_QTY.sls_delv_qty, 0) -
      coalesce(_TRNSF_OUT_QTY.transf_qty  , 0) - 
      coalesce(_RET_PO_QTY.ret_po_qty, 0) ) as closing_stk,

      cast( 'KG' as msehi )                   as unit_of_measure

}
