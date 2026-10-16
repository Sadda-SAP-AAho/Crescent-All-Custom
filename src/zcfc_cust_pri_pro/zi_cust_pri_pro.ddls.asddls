@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Cutomer Pricing Procedure'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_CUST_PRI_PRO
  as select from    I_CustomerSalesArea           as a

    inner join      I_Customer                    as b   on b.Customer = a.Customer

    left outer join I_CustomerAccountGroupText    as d   on  d.CustomerAccountGroup = b.CustomerAccountGroup
                                                         and d.Language             = 'E'

    left outer join I_PaymentTermsText            as e   on  e.PaymentTerms = a.CustomerPaymentTerms
                                                         and e.Language     = 'E'


    left outer join I_IncotermsClassificationText as inc on  inc.IncotermsClassification = a.IncotermsClassification
                                                         and inc.Language                = 'E'

    left outer join ZI_CUST_PRI_PRO_1             as f   on  f.Customer            = a.Customer
                                                         and f.SalesOrganization   = a.SalesOrganization
                                                         and f.DistributionChannel = a.DistributionChannel
                                                         and f.Division            = a.Division


    left outer join ZI_CUST_ADD                   as g   on g.Customer = f.BPCustomerNumber



    left outer join I_BusinessPartnerBank         as j   on j.BusinessPartner = a.Customer


{
  key a.Customer,
  key a.SalesOrganization,
  key a.DistributionChannel,
  key a.Division,
  key f.PartnerCounter,
  key cast(f.PartnerFunction as abap.char(2))as CustomerPartnerFunction,


      b.CustomerName,

      // Bill-To Address
      case
        when f.PartnerFunction = 'RE' then
            concat(
               concat(
                 concat(g.StreetName, ', '),
                 g.CityName
               ),
               concat(concat(', ', g.Country),
               concat(' - ' ,g.PostalCode))

             )   end         as BillToParty,

      // Ship-To Address

      case
        when f.PartnerFunction = 'WE' then
            concat(
               concat(
                 concat(g.StreetName, ', '),
                 g.CityName
               ),
               concat(concat(', ', g.Country),
               concat(' - ' , g.PostalCode))
             )     end     as ShipToParty,


      inc.IncotermsClassification     as IncoTerms,

      inc.IncotermsClassificationName as IncoTermsDescription,


      a.CustomerPaymentTerms                  as PaymentTerms,
      e.PaymentTermsName              as PaymentTermsDescription,

      a.CustomerPricingProcedure      as PricingCode,

      case
        when a.CustomerPricingProcedure = '01' then 'Price list Domestic'
        when a.CustomerPricingProcedure = '02' then 'Price list Export'
        when a.CustomerPricingProcedure = 'Z1' then 'Manual Pricing-Export'
        when a.CustomerPricingProcedure = 'Z2' then 'Manual Pricing-Domestic'
        else ''
      end                             as PricingDescription,

      a.Currency,
      b.CustomerAccountGroup,
      d.AccountGroupName,
      j.BankName

}
