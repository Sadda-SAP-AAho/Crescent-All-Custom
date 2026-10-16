@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO Data Mismatch-1'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_SO_DATA_MISMATCH_1
  as select distinct from I_SalesOrder            as a
    left outer join       I_SalesOrderItem        as b on a.SalesOrder = b.SalesOrder
    left outer join       I_BusinessUserBasic     as c on c.UserID = a.CreatedByUser
    left outer join       I_ShippingConditionText as d on  a.ShippingCondition = d.ShippingCondition
                                                       and d.Language          = 'E'
    left outer join       ZCDS_SOPENSO_DELQTY1    as e on  e.ReferenceSDDocument     = b.SalesOrder
                                                       and e.ReferenceSDDocumentItem = b.SalesOrderItem
    left outer join       ZCDS_REJECTION_REASON   as f on  f.SalesDocument     = b.SalesOrder
                                                       and f.SalesDocumentItem = b.SalesOrderItem
{

  key cast( a.SalesOrder as abap.char(10) ) as SalesOrder,
  key a.CreationDate                        as SalesOrderDate,
  key b.Plant,
  key a.SoldToParty                         as Customer,
  key c.PersonFullName                      as Createdby,
  key b.SalesOrderItem,
      b.Material,
      d.ShippingConditionName               as ShippingCond,
      a.IncotermsClassification             as IncoTermsHead,
      b.IncotermsClassification             as IncoTermsItem,
      a.IncotermsLocation1                  as IncoTerms1Head,
      b.IncotermsLocation1                  as IncoTerms1Item,
      a.CustomerPaymentTerms                as PayTermsHead,
      b.CustomerPaymentTerms                as PayTermsItem,
      concat(
      case
        when a.ShippingCondition <> '01'
        then 'Mismatch in Shipping Condition'
        else ''
      end,

      concat(
        case
            when a.IncotermsClassification <> b.IncotermsClassification
            then
                concat(
                    case
                        when a.ShippingCondition <> '01'
                        then ' / '
                        else ''
                    end,
                    'Mismatch in Inco Terms'
                )
            else ''
        end,

        concat(
            case
                when a.IncotermsLocation1 <> b.IncotermsLocation1
                then
                    concat(
                        case
                            when a.ShippingCondition <> '01'
                              or a.IncotermsClassification <> b.IncotermsClassification
                            then ' / '
                            else ''
                        end,
                        'Mismatch in Inco Terms-1'
                    )
                else ''
            end,

            case
                when a.CustomerPaymentTerms <> b.CustomerPaymentTerms
                then
                    concat(
                        case
                            when a.ShippingCondition <> '01'
                              or a.IncotermsClassification <> b.IncotermsClassification
                              or a.IncotermsLocation1 <> b.IncotermsLocation1
                            then ' / '
                            else ''
                        end,
                        'Mismatch in Pay Terms'
                    )
                else ''
            end
        )
      )
      )                                     as Remarks




}

where
      b.Plant                       <> '2000'
  and e.balanceqty                  >  0
  and f.SalesDocumentRjcnReasonName is null
