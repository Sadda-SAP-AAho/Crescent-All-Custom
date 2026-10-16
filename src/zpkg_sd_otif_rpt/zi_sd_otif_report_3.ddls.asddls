@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OTIF Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OTIF_REPORT_3
  as select from I_SalesOrderItem             as a
    inner join   I_SalesDocItemPricingElement as b on  b.SalesDocument     = a.SalesOrder
                                                   and b.SalesDocumentItem = a.SalesOrderItem
{
  key a.SalesOrder,
  key a.SalesOrderItem,
  sum( case when b.ConditionType = 'ZPR0' or b.ConditionType = 'ZPR1' or b.ConditionType = 'ZSPC'
            then cast( b.ConditionRateAmount as abap.dec( 23, 2 ) ) 
            else cast( 0 as abap.dec( 23, 2 ) )  end ) as otfamt,
            
  sum( case when b.ConditionType = 'ZXIV' or b.ConditionType = 'ZXIP'
            then cast( b.ConditionAmount as abap.dec( 23, 2 ) )
            when b.ConditionType = 'ZK08' or b.ConditionType = 'ZK09' or b.ConditionType = 'D100'
            then cast( ( -1 * b.ConditionAmount ) as abap.dec( 23, 2 ) ) 
            else cast( 0 as abap.dec( 23, 2 ) )  end ) as otfamt1          
}
where
     b.ConditionType = 'ZPR0'
  or b.ConditionType = 'ZPR1'
  or b.ConditionType = 'ZSPC'
  or b.ConditionType = 'ZXIV'
  or b.ConditionType = 'ZXIP'
  or b.ConditionType = 'ZK08'
  or b.ConditionType = 'ZK09'
  or b.ConditionType = 'ZD00'
group by
  a.SalesOrder,
  a.SalesOrderItem
