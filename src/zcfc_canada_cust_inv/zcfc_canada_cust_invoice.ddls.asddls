@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Canada Customer Invoice'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.entitySet.name: 'headSet'
define view entity ZCFC_Canada_Cust_Invoice
  as select distinct from   I_BillingDocument          as _head
    left outer join I_BillingDocumentItem      as _item     on _head.BillingDocument = _item.BillingDocument
    left outer join I_ShippingPoint            as _shipoint on _item.ShippingPoint = _shipoint.ShippingPoint
    left outer join I_AddrOrgNamePostalAddress as _shipadd  on _shipoint.AddressID = _shipadd.AddressID
    left outer join I_BillingDocItemPartner    as _partner  on _head.BillingDocument = _partner.BillingDocument
    left outer join I_Customer                 as _custname on _partner.Customer = _custname.Customer
    left outer join I_AddrOrgNamePostalAddress as _address  on _partner.AddressID = _address.AddressID
    left outer join ZI_COMM_HED                as _comm     on _head.BillingDocument = _comm.Commid
    left outer join ZI_DELDASH_HDR            as _deldash  on _item.ReferenceSDDocument = _deldash.Delivery

    left outer join I_DeliveryDocument         as _shipcond on _item.ReferenceSDDocument = _shipcond.DeliveryDocument
    left outer join I_ShippingConditionText    as _condtext on _shipcond.ShippingCondition = _condtext.ShippingCondition and _condtext.Language = 'E'
{
  @UI.selectionField: [{ position: 10 }]
 key _head.BillingDocument                                                             as Commercial_no,
  _head.BillingDocumentDate                                                         as Document_date,
  _partner.Customer                                                                 as Goods_consigned_To_Number,
  _custname.CustomerName                                                            as Goods_consigned_To_Name,
  concat_with_space( _address.Street,
  concat_with_space( _address.StreetName,
  concat_with_space( _address.CityName,
  concat_with_space( _address.DistrictName,
  concat_with_space( _address.Region,
  concat_with_space( _address.Country, _address.PostalCode,  1), 1), 1), 1), 1), 1) as Goods_consigned_To_Address,
  _condtext.ShippingConditionName                                                   as Delivery_Mode,
  _deldash.Pol                                                                      as Port_Of_Loading,
  _shipadd.Country                                                                  as Country_of_Origin,
  _deldash.Pod                                                                      as Port_of_Destination,
  _address.Country                                                                  as Country_of_Destination,
  _deldash.Findes                                                                   as Final_Destination,
  _deldash.Cusmar                                                                   as Marked,
  _deldash.Shiptype                                                                 as Shipment_type,
  _item.TransactionCurrency                                                         as Billing_Document_Currency,
  _shipadd.CityName                                                                 as Pre_Carriage_by,
  _address.CityName                                                                 as Place_of_Receipt_by_Precarrier,
  _comm.Vesselcode                                                                  as Vessel_Flight_No,
      _comm.Descgoods1              as GoodsDescription1,
      _comm.Descgoods2              as GoodsDescription2

}
where
     ( _partner.PartnerFunction = 'WE'
  or _partner.PartnerFunction = 'SH' ) and  _deldash.Status          = 'CREATED';
