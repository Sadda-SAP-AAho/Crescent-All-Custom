@AbapCatalog.sqlViewName: 'ZREJRSNCLDSHT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Cold Shut'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRSNCLDSHT 
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
      ( case when d.Rejrea1 = 'COLD SHUT/SHORT METAL/COLD METAL' then d.Rejqty1 end ) as Total_Qty1_ColdShut,
      ( case when d.Rejrea2 = 'COLD SHUT/SHORT METAL/COLD METAL' then d.Rejqty2 end ) as Total_Qty2_ColdShut,
      ( case when d.Rejrea3 = 'COLD SHUT/SHORT METAL/COLD METAL' then d.Rejqty3 end ) as Total_Qty3_ColdShut,
      ( case when d.Rejrea4 = 'COLD SHUT/SHORT METAL/COLD METAL' then d.Rejqty4 end ) as Total_Qty4_ColdShut,
      ( case when d.Rejrea5 = 'COLD SHUT/SHORT METAL/COLD METAL' then d.Rejqty5 end ) as Total_Qty5_ColdShut,
      ( case when d.Rejrea6 = 'COLD SHUT/SHORT METAL/COLD METAL' then d.Rejqty6 end ) as Total_Qty6_ColdShut,
      ( case when d.Rejrea7 = 'COLD SHUT/SHORT METAL/COLD METAL' then d.Rejqty7 end ) as Total_Qty7_ColdShut,
      ( case when d.Rejrea8 = 'COLD SHUT/SHORT METAL/COLD METAL' then d.Rejqty8 end ) as Total_Qty8_ColdShut,
      ( case when d.Rejrea9 = 'COLD SHUT/SHORT METAL/COLD METAL' then d.Rejqty9 end ) as Total_Qty9_ColdShut
}
