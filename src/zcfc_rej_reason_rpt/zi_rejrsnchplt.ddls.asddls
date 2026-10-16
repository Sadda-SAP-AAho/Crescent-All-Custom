@AbapCatalog.sqlViewName: 'ZREJRSNCHPLT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Chaplet High'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRSNCHPLT 
  as select distinct from ZI_REJRSNHEAD              as a

    inner join            I_MaterialDocumentHeader_2 as b on a.Shop_floor_No = b.MaterialDocumentHeaderText

    inner join            I_MaterialDocumentItem_2   as c on  b.MaterialDocument  = c.MaterialDocument
                                                          and c.GoodsMovementType = '101'

    left outer join       ZI_CONFPOST_ITM            as d on  a.Shop_floor_No = d.Shpflrno
                                                          and a.Refid         = d.Refid
                                                          and d.Matnr         = c.Material
{
  key a.RcptfrmPrdNo,
  key a.RcptfrmPrdDt,
  key a.Item_Sl_No,
  key a.Refid,
  key a.Shop_floor_No,
  key a.Shop_floor_Dt,
  key a.Opr_Code,
  key a.Opr_Name,
  key a.Dept_Code,
  key a.Dept_Name,
  key a.Cont_Code,
  key a.Cont_Name,
  key a.Plant_Code,
  key a.Plant_Name,
  key a.Mat_Code,
      a.Mat_Name,
      ( case when d.Rejrea1 = 'CHAPLET HIGH' then d.Rejqty1 end ) as Total_Qty1_Chaplet,
      ( case when d.Rejrea2 = 'CHAPLET HIGH' then d.Rejqty2 end ) as Total_Qty2_Chaplet,
      ( case when d.Rejrea3 = 'CHAPLET HIGH' then d.Rejqty3 end ) as Total_Qty3_Chaplet,
      ( case when d.Rejrea4 = 'CHAPLET HIGH' then d.Rejqty4 end ) as Total_Qty4_Chaplet,
      ( case when d.Rejrea5 = 'CHAPLET HIGH' then d.Rejqty5 end ) as Total_Qty5_Chaplet,
      ( case when d.Rejrea6 = 'CHAPLET HIGH' then d.Rejqty6 end ) as Total_Qty6_Chaplet,
      ( case when d.Rejrea7 = 'CHAPLET HIGH' then d.Rejqty7 end ) as Total_Qty7_Chaplet,
      ( case when d.Rejrea8 = 'CHAPLET HIGH' then d.Rejqty8 end ) as Total_Qty8_Chaplet,
      ( case when d.Rejrea9 = 'CHAPLET HIGH' then d.Rejqty9 end ) as Total_Qty9_Chaplet
}
