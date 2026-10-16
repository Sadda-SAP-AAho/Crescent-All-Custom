@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_NONBOM_RPT_2
  as select from    ZCDS_PP_NONBOM_RPT   as a
    left outer join ZCDS_PP_NONBOM_RPT_1 as b on  b.PostingDate = a.PostingDate
                                              and b.consbase    = a.consbase
                                              and b.Plant       = a.Plant //new
                                              and b.Cctype      = a.cctype
                                              
  // and b.Dept        = a.CostCenter //new
{
  key a.MaterialDocument,
  key a.MaterialDocumentYear,
  key a.PostingDate,
  key a.Material,
  key a.Plant,
  key a.consbase,
  key a.CostCenter,
  key a.GLAccount,
  key b.typeofmould,
  key a.typeofmould               as typeofmould1,
      a.ProductName,
      a.MaterialGroup,
      a.MaterialGroupName,
      //      a.CostCenterDescription,
      a.GLAccountLongName,
      a.qtyperbox,
      //a.typeofmould,
      a.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.actissue,
      b.MaterialBaseUnit          as MaterialBaseUnit1,
      @Semantics.amount.currencyCode: 'currency'
      a.actissval,
      a.currency,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      b.production,
      cast( case
      when a.consbase = 'MELTING'
      then cast( b.production as abap.dec( 13, 3 ) )
      when a.Plant = '1100' or a.Plant = '1400' then
        case
        when a.consbase = 'CASTING'
        then cast( ( cast( b.production as abap.dec( 13, 3 ) ) * cast( b.NetWeight as abap.dec( 13,3 ) ) ) as abap.dec( 13, 3 ) )
        else cast( 0 as abap.dec( 13, 3 ) ) end

      when a.Plant = '1200' then
        case
        when ( a.consbase = 'CASTING' and ( b.typeofmould = 'SMALL VACUUM' or b.typeofmould = 'Small Vacuum' ) and b.qtyperbox is not initial )
        then cast( division(cast( b.production as abap.dec( 13, 3 ) ), cast( b.qtyperbox as abap.dec( 13, 3 ) ), 3) as abap.dec( 13, 3 ) )

        when ( a.consbase = 'CASTING' and ( b.typeofmould = 'BIG VACUUM' or b.typeofmould = 'Big Vacuum' ) and b.qtyperbox is not initial )
        then cast( division(cast( b.production * 2 as abap.dec( 13, 3 ) ), cast( b.qtyperbox as abap.dec( 13, 3 ) ), 3) as abap.dec( 13, 3 ) )

        else cast( 0 as abap.quan( 13, 3 ) ) end

      when a.Plant = '1300' then
        case
        when ( a.consbase = 'CASTING' and ( b.typeofmould = 'SMALL VACUUM' or b.typeofmould = 'Small Vacuum' ) and b.qtyperbox is not initial )
        then cast( division(cast( b.production as abap.dec( 13, 3 ) ), cast( b.qtyperbox as abap.dec( 13, 3 ) ), 3) as abap.dec( 13, 3 ) )

        when ( a.consbase = 'CASTING' and ( b.typeofmould = 'BIG VACUUM' or b.typeofmould = 'Big Vacuum' ) and b.qtyperbox is not initial )
        then cast( division(cast( b.production * 2 as abap.dec( 13, 3 ) ), cast( b.qtyperbox as abap.dec( 13, 3 ) ), 3) as abap.dec( 13, 3 ) )

        when ( a.consbase = 'CASTING' and ( b.typeofmould = 'MANIPULATOR' or b.typeofmould = 'Manipulator' ) and b.qtyperbox is not initial )
        then cast( division(cast( ( b.production * cast( 3.5 as abap.dec( 13, 3 ) ) ) as abap.dec( 13, 3 ) ), cast( ( b.qtyperbox ) as abap.dec( 13, 3 ) ), 3) as abap.dec( 13, 3 ) )

        when ( a.consbase = 'CASTING' and ( b.typeofmould = 'FLEXILINE' or b.typeofmould = 'Flexiline' ) and b.qtyperbox is not initial )
        then cast( division(cast( ( b.production * cast( 5.5  as abap.dec( 13, 3 ) ) ) as abap.dec( 13, 3 ) ), cast( ( b.qtyperbox ) as abap.dec( 13, 3 ) ), 3) as abap.dec( 13, 3 ) )

        else cast( 0 as abap.dec( 13, 3 ) ) end
       else cast( 0 as abap.dec( 13, 3 ) )
       end as abap.dec( 13, 3 ) ) as QuantityInBaseUnit,

      a.conqty
}
