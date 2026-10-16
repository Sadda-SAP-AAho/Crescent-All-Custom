@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_NONBOM_RPT_3


  as select distinct from ZCDS_PP_NONBOM_RPT_5 as a //ZCDS_PP_NONBOM_RPT_4

  //    left outer join       ZTBL_FCTN_NONBOM_RPT( mandt : $session.client ) as c on  c.postingdate = a.PostingDate
  //                                                                               and c.plant       = a.Plant
  //                                                                               and c.costcenter  = a.CostCenter
  //                                                                               and c.material    = a.Material
  //                                                                               and c.GLAccount   = a.GLAccount
  //                                                                               and c.Conbase     = a.consbase
{
  key a.PostingDate,
  key a.Material,
  key a.Plant,
  key a.consbase,
  key a.CostCenter,
  key a.GLAccount,
      a.ProductName,
      a.MaterialGroup,
      a.MaterialGroupName,
//     a.CostCenterDescription,
      a.GLAccountLongName,
      a.qtyperbox,
      a.typeofmould,
      a.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.actissue,
      a.MaterialBaseUnit1,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      a.QuantityInBaseUnit,
      @Semantics.amount.currencyCode: 'Currency'
      a.actissval,
      a.currency,
      a.conqty,
      cast( division( cast( ( a.QuantityInBaseUnit * a.conqty ) as abap.dec(13,3) ), cast( 1000 as abap.dec(13,3) ), 3 ) as abap.dec( 13, 3 ) ) as stdissue,
      //( case when a.actissue is not initial then cast( division( cast( a.actissval as abap.dec( 23, 2 ) ), cast( a.actissue as abap.dec( 13, 3 ) ), 2 ) as abap.dec( 23, 2) )
      ( case when a.actissue is not initial then cast( division( cast( a.actissval as abap.dec( 23, 3 ) ), cast( a.actissue as abap.dec( 13, 3) ), 3 ) as abap.dec( 23, 2) )
             else cast( 0 as abap.dec( 23, 2) ) end )                  as lastpurprice
}


