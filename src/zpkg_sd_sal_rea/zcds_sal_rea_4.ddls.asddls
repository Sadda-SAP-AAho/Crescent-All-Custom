@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Pricing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_4 
as select from I_SalesDocItemPricingElement
{
    SalesDocument,
    SalesDocumentItem,
    cast( sum( case when ( ConditionType = 'ZPR0' or ConditionType = 'ZPR1' )
                    then cast( ConditionRateAmount as abap.dec( 23, 2 ) )
                    else cast( 0 as abap.dec( 23, 2 ) )
                    end ) as abap.dec( 23, 2 ) ) as Baseprice,
   cast( sum( case when ( ConditionType = 'ZSPC' )
                    then cast( ConditionRateAmount as abap.dec( 23, 2 ) )
                    else cast( 0 as abap.dec( 23, 2 ) )
                    end ) as abap.dec( 23, 2 ) ) as matprice,
   cast( sum( case when ( ConditionType = 'ZEXR' )
                    then cast( ConditionRateValue as abap.dec( 23, 2 ) )
                    else cast( 0 as abap.dec( 23, 2 ) )
                    end ) as abap.dec( 23, 2 ) ) as rate, 
   cast( sum( case when ( ConditionType = 'ZRAW' )
                    then cast( ConditionRateAmount as abap.dec( 23, 2 ) )
                    else cast( 0 as abap.dec( 23, 2 ) )
                    end ) as abap.dec( 23, 2 ) ) as metalprice,      
   cast( sum( case when ( ConditionType = 'ZXIV' )
                    then cast( ConditionAmount as abap.dec( 23, 2 ) )
                    else cast( 0 as abap.dec( 23, 2 ) )
                    end ) as abap.dec( 23, 2 ) ) as frtprice,
  cast( sum( case when ( ConditionType = 'ZOIG' )
                    then cast( ConditionAmount as abap.dec( 23, 2 ) )
                    else cast( 0 as abap.dec( 23, 2 ) )
                    end ) as abap.dec( 23, 2 ) ) as zoig,
  cast( sum( case when ( ConditionType = 'ZXIV' or ConditionType = 'ZXIP' or ConditionType = 'ZFIV' or
                         ConditionType = 'ZFIP' or ConditionType = 'ZPIP' or ConditionType = 'ZPIV' )
                    then cast( ConditionAmount as abap.dec( 23, 2 ) )
                    else cast( 0 as abap.dec( 23, 2 ) )
                    end ) as abap.dec( 23, 2 ) ) as frt,
  cast( sum( case when ( ConditionType = 'ZK07' or ConditionType = 'ZK08' or ConditionType = 'D100' )
                    then cast( ConditionAmount as abap.dec( 23, 2 ) )
                    else cast( 0 as abap.dec( 23, 2 ) )
                    end ) as abap.dec( 23, 2 ) ) as disc                                                                                                                   
}
where SalesDocumentItem is not initial
  and ( ConditionType = 'ZPR0' or ConditionType = 'ZPR1' or ConditionType = 'ZSPC' or ConditionType = 'ZEXR' or
        ConditionType = 'ZOIG' or ConditionType = 'ZXIV' or ConditionType = 'ZXIP' or ConditionType = 'ZFIV' or
        ConditionType = 'ZFIP' or ConditionType = 'ZPIP' or ConditionType = 'ZPIV' or ConditionType = 'ZK07' or
        ConditionType = 'ZK08' or ConditionType = 'D100' or ConditionType = 'ZRAW' )
group by
SalesDocument,
SalesDocumentItem  
