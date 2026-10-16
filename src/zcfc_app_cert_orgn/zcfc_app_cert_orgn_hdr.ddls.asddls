@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header of Appl for Certificate of Origin'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.entitySet.name: 'headerSet'
define view entity ZCFC_APP_CERT_ORGN_HDR
  with parameters
    commercial_no : vbeln
  as select distinct from I_BillingDocument          as _billdoc
    left outer join       I_BillingDocumentItem      as _item        on _billdoc.BillingDocument = _item.BillingDocument
  //left outer join ZI_DELDASH_HDR2 as _deldash on _billdoc.BillingDocument = _deldash.BillingDocument //and _item.BillingDocumentItem = _deldash.BillingDocumentItem
    left outer join       ZI_DELDASH_HDR             as _deldash     on _item.ReferenceSDDocument = _deldash.Delivery
    left outer join       I_BillingDocItemPartner    as _partner     on _billdoc.BillingDocument = _partner.BillingDocument
    left outer join       I_Customer                 as _partnername on _partner.Customer = _partnername.Customer
    left outer join       I_ShippingPoint            as _ship        on _item.ShippingPoint = _ship.ShippingPoint
    left outer join       I_DeliveryDocument         as _shipcond    on _item.ReferenceSDDocument = _shipcond.DeliveryDocument
    left outer join       I_ShippingConditionText    as _condtext    on  _shipcond.ShippingCondition = _condtext.ShippingCondition
                                                                     and _condtext.Language          = 'E'
    left outer join       I_AddrOrgNamePostalAddress as _partneradd  on _partner.AddressID = _partneradd.AddressID
    left outer join       I_AddrOrgNamePostalAddress as _partnercity on _ship.AddressID = _partnercity.AddressID
    left outer join       ZI_COMM_HED                as _hed         on _billdoc.BillingDocument = _hed.Commid

{
  key    _billdoc.BillingDocument,
         @UI.lineItem: [{ position: 10 }]
         @EndUserText.label: 'Goods_consigned_To_Number'
  key    _deldash.Shpprtycode                                   as Goods_consigned_To_Number,
         @UI.lineItem: [{ position: 20 }]
         @EndUserText.label: 'Goods_consigned_To_Name'
         _deldash.Shpprtyname                                   as Goods_consigned_To_Name,
         @UI.lineItem: [{ position: 30 }]
         @EndUserText.label: 'Goods_consigned_To_Address1'
         _deldash.Shpprtyadd1 as Goods_consigned_To_Address1,
         //         concat(
         //             _partneradd.Street,
         //             concat( ' ', _partneradd.StreetName )
         //         )                                                      as Goods_consigned_To_Address1,
         @UI.lineItem: [{ position: 40 }]
         @EndUserText.label: 'Goods_consigned_To_Address2'
         _deldash.Shpprtyadd2 as Goods_consigned_To_Address2,
         //         concat(
         //             _partneradd.CityName,
         //             concat( ' ', _partneradd.DistrictName )
         //         )                                                      as Goods_consigned_To_Address2,
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
         //         )                                                      as Goods_consigned_To_Address3,
         @UI.lineItem: [{ position: 60 }]
         @EndUserText.label: 'Delivery_Mode'
         _condtext.ShippingConditionName                        as Delivery_Mode,
         @UI.lineItem: [{ position: 70 }]
         @EndUserText.label: 'Port_of_Loading'
         //        _partnercity.CityName as Port_Of_Loading,
         _deldash.Pol                                           as Port_of_Loading,
         @UI.lineItem: [{ position: 80 }]
         @EndUserText.label: 'Country_of_Origin'
         _partnercity.Country                                   as Country_of_Origin,
         @UI.lineItem: [{ position: 90 }]
         @EndUserText.label: 'Port_of_Destination'
         //     _partneradd.CityName as Port_of_Destination,
         _deldash.Pod                                           as Port_of_Destination,
         @UI.lineItem: [{ position: 100 }]
         @EndUserText.label: 'Country_of_Destination'
         _partneradd.Country                                    as Country_of_Destination,
         @UI.lineItem: [{ position: 110 }]
         @EndUserText.label: 'Final_Destination'
         //     _partneradd.CityName as Final_Destination,
         _deldash.Findes                                        as Final_Destination,
         @UI.lineItem: [{ position: 120 }]
         @EndUserText.label: 'Pre_Carriage_by'
         _partnercity.CityName                                  as Pre_Carriage_by,
         @UI.lineItem: [{ position: 130 }]
         @EndUserText.label: 'Place_of_Rcpt_by_Pre_carrier'
         _partnercity.CityName                                  as Place_of_Rcpt_by_Pre_carrier,
         @UI.lineItem: [{ position: 140 }]
         @EndUserText.label: 'PLACE OF SHIPMENT BY PRE-CARRIER'
         _deldash.Por                                           as PLACE_OF_SHPMNT_BY_PRE_CARRIER,

         @UI.lineItem: [{ position: 150 }]
         @EndUserText.label: 'Vessel_Flight No'
         _hed.Vesselcode                                        as Vessel_Flight_No,
         @UI.lineItem: [{ position: 160 }]
         @EndUserText.label: 'Marks/Container'
         concat_with_space(_deldash.Cusmar,_deldash.Contno , 1) as MarksContainer
}
where
  (
       _partner.PartnerFunction = 'WE'
    or _partner.PartnerFunction = 'SH'
  )
  and  _deldash.Status          = 'CREATED'
  and  _billdoc.BillingDocument = $parameters.commercial_no;
