@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Sales Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SALES4 as select from I_BillingDocumentItemPrcgElmnt as A
{
 key A.BillingDocument,
 A.BillingDocumentItem,
 A.PricingProcedureStep,
 A.PricingProcedureCounter,
 case A.ConditionType
            when 'ZPR0' then 'A'
            when 'ZPR1' then 'A' 
//            when 'ZOIG' then 'A' end as Aa,
            when 'ZSPC' then 'A' end as Aa,
 case A.ConditionType  
            when 'ZXIV' then 'B'
            when 'ZXIP' then 'B' 
            when 'ZFIV' then 'B' 
            when 'ZFIP' then 'B' 
            when 'ZPIP' then 'B' 
            when 'ZPIV' then 'B' end as Bb,
 case A.ConditionType
            when 'ZK07' then 'C'
            when 'ZK08' then 'C'
            when 'D100' then 'C' end as Cc,
// case A.ConditionType  
//            when 'ZK07' then 'D'
//            when 'ZK08' then 'D'
//            when 'D100' then 'D' end as Dd,
 case A.ConditionType 
            when 'ZXIV' then 'E'
            when 'ZXIP' then 'E'
            when 'ZFIV' then 'E'
            when 'ZFIP' then 'E'
            when 'ZPIP' then 'E'
            when 'ZPIV' then 'E' end as Ee,
  case A.ConditionType
            when 'ZOIG' then 'F'
            when 'JOIG' then 'F' end as Ff,
  case A.ConditionType
            when 'JOCG' then 'G' end as Gg,
  case A.ConditionType
            when 'JOSG' then 'H'end as ConditionType,
// Added by SP on 16.06.25
  case A.ConditionType
            when 'JTC1' then 'I'
            when 'JTC2' then 'I'
            end as Ii,
// End of Added by SP on 16.06.25            
        A.TransactionCurrency,
        @Semantics.amount.currencyCode: 'TransactionCurrency'    
        A.ConditionAmount   as  ConditionAmnt,
        A.ConditionRateValue  as CondRateValue
            }
            where A.ConditionType = 'ZPR0' or 
                  A.ConditionType = 'ZPR1' or
                  A.ConditionType = 'ZOIG' or
                  A.ConditionType = 'ZSPC' or
                  A.ConditionType = 'ZXIV' or
                  A.ConditionType = 'ZXIP' or
                  A.ConditionType = 'ZFIV' or
                  A.ConditionType = 'ZFIP' or
                  A.ConditionType = 'ZPIP' or
                  A.ConditionType = 'ZPIV' or
                  A.ConditionType = 'ZK07' or
                  A.ConditionType = 'ZK08' or
                  A.ConditionType = 'D100' or
                  A.ConditionType = 'ZK07' or
                  A.ConditionType = 'ZK08' or
                  A.ConditionType = 'JOIG' or
                  A.ConditionType = 'JOCG' or
                  A.ConditionType = 'JOSG' or
                  A.ConditionType = 'JTC1' or
                  A.ConditionType = 'JTC2'// Added by SP on 16.06.25 
