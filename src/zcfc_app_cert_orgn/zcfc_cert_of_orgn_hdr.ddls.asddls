@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header of Certificate of Origin'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.entitySet.name: 'headerSet'
define view entity ZCFC_CERT_OF_ORGN_HDR
  with parameters
    commercial_no : vbeln
  as select distinct from I_BillingDocument          as _billdoc
  //left outer join ZI_DELDASH_HDR2 as _deldash on _billdoc.BillingDocument = _deldash.BillingDocument
    left outer join       I_BillingDocumentItem      as _item        on _billdoc.BillingDocument = _item.BillingDocument
    left outer join       ZI_DELDASH_HDR             as _deldash     on _deldash.Delivery = _item.ReferenceSDDocument
    left outer join       I_BillingDocItemPartner    as _partner     on _billdoc.BillingDocument = _partner.BillingDocument
    left outer join       I_Customer                 as _partnername on _partner.Customer = _partnername.Customer
    left outer join       I_ShippingPoint            as _ship        on _item.ShippingPoint = _ship.ShippingPoint
    left outer join       I_DeliveryDocument         as _shipcond    on _item.ReferenceSDDocument = _shipcond.DeliveryDocument
    left outer join       I_ShippingConditionText    as _condtext    on  _shipcond.ShippingCondition = _condtext.ShippingCondition
                                                                     and _condtext.Language          = 'E'
    left outer join       I_AddrOrgNamePostalAddress as _partneradd  on _partner.AddressID = _partneradd.AddressID
    left outer join       I_AddrOrgNamePostalAddress as _partnercity on _ship.AddressID = _partnercity.AddressID
{
  key    _billdoc.BillingDocument,
         @UI.lineItem: [{ position: 10 }]
         @EndUserText.label: 'Goods_consigned_To_Number'
  key    _deldash.Shpprtycode as Goods_consigned_To_Number,
         @UI.lineItem: [{ position: 20 }]
         @EndUserText.label: 'Goods_consigned_To_Name'
         _deldash.Shpprtyname as Goods_consigned_To_Name,
         @UI.lineItem: [{ position: 30 }]
         @EndUserText.label: 'Goods_consigned_To_Address1'
         _deldash.Shpprtyadd1 as Goods_consigned_To_Address1,
         //         concat(
         //             _partneradd.Street,
         //             concat( ' ', _partneradd.StreetName )
         //         )                         as Goods_consigned_To_Address1,
         @UI.lineItem: [{ position: 40 }]
         @EndUserText.label: 'Goods_consigned_To_Address2'
         _deldash.Shpprtyadd2 as Goods_consigned_To_Address2,
         //         concat(
         //             _partneradd.CityName,
         //             concat( ' ', _partneradd.DistrictName )
         //         )                         as Goods_consigned_To_Address2,
         //         @UI.lineItem: [{ position: 50 }]
         //         @EndUserText.label: 'Goods_consigned_To_Address3'
         //         concat(
         //             _partneradd.Region,
         //             concat(
         //                 ' ',
         //                 concat(
         //                     _partneradd.Country,
         //                     concat( ' ', _partneradd.PostalCode )
         //                 )
         //             )
         //         )                         as Goods_consigned_To_Address3,
         @UI.lineItem: [{ position: 60 }]
         @EndUserText.label: 'Delivery_Mode'
         //     _condtext.ShippingConditionName as Delivery_Mode,
         _deldash.Delmode     as Delivery_Mode,
         @UI.lineItem: [{ position: 70 }]
         @EndUserText.label: 'Port_of_Loading'
         //        _partnercity.CityName as Port_Of_Loading,
         _deldash.Pol         as Port_of_Loading,
         @UI.lineItem: [{ position: 80 }]
         @EndUserText.label: 'Country_of_Origin'
         //         _partnercity.Country as Country_of_Origin,
         _deldash.Coo         as Country_of_Origin,
         @UI.lineItem: [{ position: 90 }]
         @EndUserText.label: 'Port_of_Destination'
         //     _partneradd.CityName as Port_of_Destination,
         _deldash.Pod         as Port_of_Destination,
         @UI.lineItem: [{ position: 100 }]
         @EndUserText.label: 'Country_of_Destination'
         //     _partneradd.Country as Country_of_Destination
         _deldash.Cod         as Country_of_Destination,
         @UI.lineItem: [{ position: 110 }]
         @EndUserText.label: 'MarksContainer'
         _deldash.Cusmar      as MarksContainer
}
where
  (
       _partner.PartnerFunction = 'WE'
    or _partner.PartnerFunction = 'SH'
  )
  and  _deldash.Status          = 'CREATED'
  and  _billdoc.BillingDocument = $parameters.commercial_no;
