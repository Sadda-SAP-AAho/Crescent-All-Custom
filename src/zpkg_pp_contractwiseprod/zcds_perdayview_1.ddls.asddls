@AbapCatalog.sqlViewName: 'ZVIEW3'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Per Day View-1'
@Metadata.ignorePropagatedAnnotations: true

define view ZCDS_PERDAYVIEW_1

  as select distinct from ZCDS_POSTINGDATE           as f

    inner join            zdt_confpost_hdr           as a  on f.shpflrno = a.shpflrno

    inner join            zdt_confpost_itm           as b  on b.id = a.id

    inner join            I_Productplantqtmanagement as b1 on  b.matnr                           = b1.Product
                                                           and a.plant                           = b1.Plant
                                                           and b1.ProductPlantHasInspectionSetup = 'X'

    inner join            ZI_INSPQUALITYQTY          as h1 on  b.matnr       = h1.Product
                                                           and f.PostingDate = h1.QltyMatDocDate
                                                           and a.cont        = h1.Cont
                                                           and a.plant       = h1.Plant


{
  key '321'         as Type,
  key f.PostingDate as shpflrdt,
  key a.opr         as opr,
  key a.plant       as plant,
  key a.dept        as dept,
  key a.cont        as cont,
  key h1.Product    as matnr,

      h1.MaterialBaseUnit,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      h1.QltyQty    as ReqQty
}

where
  h1.MaterialBaseUnit is not initial


union all


select distinct from ZCDS_POSTINGDATE           as f

  inner join         zdt_confpost_hdr           as a  on f.shpflrno = a.shpflrno

  inner join         zdt_confpost_itm           as b  on b.id = a.id

  inner join         I_Productplantqtmanagement as b1 on  b.matnr                           =  b1.Product
                                                      and a.plant                           =  b1.Plant
                                                      and b1.ProductPlantHasInspectionSetup <> 'X'

  inner join         ZI_GRQTY                   as j  on  b.matnr       = j.Product
                                                      and f.PostingDate = j.MatlDocDate
                                                      and a.cont        = j.Cont
                                                      and a.plant       = j.Plant

{
  key '101'         as Type,
  key f.PostingDate as shpflrdt,
  key a.opr         as opr,
  key a.plant       as plant,
  key a.dept        as dept,
  key a.cont        as cont,
  key j.Product     as matnr,

      j.MaterialBaseUnit,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      j.GRQty       as ReqQty
}

where
  j.MaterialBaseUnit is not initial
