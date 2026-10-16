@AbapCatalog.sqlViewName: 'ZTEST1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TEST-1'
@Metadata.ignorePropagatedAnnotations: true

define view ZI_CFC_TEST
  as select distinct from ZCDS_POSTINGDATE           as f

    inner join            zdt_confpost_hdr           as a  on f.shpflrno = a.shpflrno

    inner join            zdt_confpost_itm           as b  on b.id = a.id

//    inner join            I_Productplantqtmanagement as b1 on  b.matnr                           = b1.Product
//                                                           and a.plant                           = b1.Plant
//                                                           and b1.ProductPlantHasInspectionSetup = 'X'
//
//    inner join            ZI_INSPQUALITYQTY          as h1 on  b.matnr       = h1.Product
//                                                           and f.PostingDate = h1.QltyMatDocDate
//                                                           and a.cont        = h1.Cont
//                                                           and a.plant       = h1.Plant

{
  key '321'         as Type,
  key f.PostingDate as shpflrdt,
  key a.opr         as opr,
//  key h1.Plant      as plant,
  key a.plant,
  key a.dept        as dept,
  key a.cont        as cont,
//  key h1.Product    as matnr,
  key b.matnr

//      h1.MaterialBaseUnit,

//      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
//      h1.QltyQty    as ReqQty
}

//where
//  h1.MaterialBaseUnit is not initial
