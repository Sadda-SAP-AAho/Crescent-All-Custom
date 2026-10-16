@AbapCatalog.sqlViewName: 'ZVSHPPRD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shop Floor vs Actual production Report'
define view ZCDS_PP_SHPFLR_VS_PROD
  as select from    zdt_conf_hdr             as a
    inner join      zdt_conf_itm             as b on b.id = a.id
    left outer join I_Product                as d on d.Product = b.matnr
    left outer join ZCDS_SHPFLR_REC_1        as c on  c.refid    = b.id
                                                  and c.refitem  = b.item
                                                  and a.shpflrno = b.shpflrno
                                                  and c.matnr    = b.matnr
    left outer join ZCDS_PP_SHPFLR_VS_PROD_1 as e on  e.id   = b.id
                                                  and e.item = b.item
    left outer join I_Plant                  as f on a.plant = f.Plant
    left outer join zdt_pp_matinffld         as g on b.matnr = g.product
{
  key a.id,
  key b.item,
      a.dept,
      a.deptname,
      a.opr,
      a.oprname,
      a.plant,
      f.PlantName,
      b.matnr,
      b.maktx,
      b.meins,
      //      ( case when ( b.qtyperbox is null or b.qtyperbox = 0 ) then g.qtyperbox else b.qtyperbox end ) as qtyperbox,
      g.qtyperbox                                                        as qtyperbox,
      b.goodcast,
      e.appqty                                                           as simqty,
      a.shpflrno,
      ( b.rejqty1 + b. rejqty2 + b.rejqty3 + b.rejqty4 + b.rejqty5
        + b.rejqty6 + b.rejqty7 + b.rejqty8 + b.rejqty9 )                as rejqty,
      e.Rejqty                                                           as simrejqty,
      a.shpflrdt,
      a.contname,
      c.recqty,
      c.rejrecqty,
      case when c.recqty is not initial then b.goodcast - c.recqty
           else b.goodcast end                                           as castdif,
      case when c.rejrecqty is not initial then ( b.rejqty1 + b. rejqty2 + b.rejqty3 + b.rejqty4 + b.rejqty5
                                               + b.rejqty6 + b.rejqty7 + b.rejqty8 + b.rejqty9  ) - c.rejrecqty
           else ( b.rejqty1 + b. rejqty2 + b.rejqty3 + b.rejqty4 + b.rejqty5
                  + b.rejqty6 + b.rejqty7 + b.rejqty8 + b.rejqty9  ) end as rejdif,
      case when c.recqty is not initial then e.appqty - c.recqty
           else e.appqty end                                             as simdif,
      case when c.rejrecqty is not initial then e.Rejqty - c.rejrecqty
           else e.Rejqty end                                             as simrejdif,
      d.NetWeight                                                        as netwt,
      d.GrossWeight                                                      as grossWt,
      d.WeightUnit                                                       as wtunit
}
