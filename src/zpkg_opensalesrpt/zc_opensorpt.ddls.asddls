@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Open Sales Order Report'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_OPENSORPT
  provider contract transactional_query
  as projection on ZI_OPENSORPT

{
               //      @UI.facet: [{ purpose: #STANDARD ,type:#IDENTIFICATION_REFERENCE, position: 10 , label: 'Open Sales Order'}]
               @EndUserText.label: 'Sales Order No'
  key          SalesOrder,
               @EndUserText.label: 'Sales Order Item'
  key          SalesOrderItem,
               //               @EndUserText.label: 'Schedule Line'
               //  key          ScheduleLine,
               //               @EndUserText.label: 'Draft Outbound Delivery No.'
               //  key          DeliveryDocument,
               //  key          DeliveryDocumentItem,
               @EndUserText.label: 'Sales Order Date'
               salesdate,
               @EndUserText.label: 'Sales Contract No'
               SalesContract,
               @EndUserText.label: 'Cust Reqd Dt-Header'
               reqdeldate,
               @EndUserText.label: 'Customer Code'
               SoldToParty,
               //@EndUserText.label: 'Currency'
               //TransactionCurrency,
               //@EndUserText.label: 'Document Exchange Rate'
               //exchrate,
               @EndUserText.label: 'Pay Term'
               CustomerPaymentTermsName,
               @EndUserText.label: 'Delivery Term'
               IncotermsClassification,
               @EndUserText.label: 'Plant'
               Plant,
               @EndUserText.label: 'Plant Name'
               PlantName,
               @EndUserText.label: 'Customer PO No'
               PurchaseOrderByCustomer,
               @EndUserText.label: 'Customer PO Date'
               CustomerPurchaseOrderDate,
               @EndUserText.label: 'Our Commited Del Date'
               CommittedDeliveryDate,
               @EndUserText.label: 'PO Line No'
               UnderlyingPurchaseOrderItem,
               @EndUserText.label: 'Material Code'
               Product,
               @EndUserText.label: 'Material Description'
               SalesOrderItemText,
               @EndUserText.label: 'Customer Description'
               MaterialByCustomer,
               @EndUserText.label: 'BOM Item'
               BOM_Item,
               @UI.hidden: true
               OrderQuantityUnit,
               @EndUserText.label: 'Order Quantity'
               @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
               OrderQuantity,
               @EndUserText.label: 'Profit Centre'
               ProfitCenter,
               @EndUserText.label: 'Cust Reqd Dt-Line'
               custreqdeldate,
               @EndUserText.label: 'Country Of Destination'
               YY1_CountryofDestinat_SDH,
               @EndUserText.label: 'Final Destination'
               YY1_FinalDestination_SDH,
               @EndUserText.label: 'Port Of Discharge'
               YY1_PortofDischarge1_SDH,
               @EndUserText.label: 'Port Of Loading'
               YY1_PortOfLoading1_SDH,
               //               @EndUserText.label: 'Draft Outbound Delivery Qty.'
               //               @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
               //               ActualDeliveryQuantity,
               //@EndUserText.label: 'Customer Name'
               //CustomerName,
               @EndUserText.label: 'Sales Employee'
               SalesPersonName,
               //               @EndUserText.label: 'Delivery Date'
               //               ActualGoodsMovementDate,
               @EndUserText.label: 'HSN'
               ConsumptionTaxCtrlCode,
               @UI.hidden: true
               WeightUnit,
               @EndUserText.label: 'STD Unit Wt'
               @Semantics.quantity.unitOfMeasure: 'WeightUnit'
               NetWeight,
               @EndUserText.label: 'Delivered Qty'
               @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
               delqty,
               @EndUserText.label: 'Balance Qty'
               @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
               balanceqty,
               @EndUserText.label: 'Balance Weight'
               @Semantics.quantity.unitOfMeasure: 'WeightUnit'
               balancewt,
               //@EndUserText.label: 'Unit Price'
               //unitprice,
               //@EndUserText.label: 'Balance Value In DC'
               //balancevaldc,
               //@EndUserText.label: 'Balance Value In LC'
               //balancevallc,
               @EndUserText.label: 'Revision No'
               AdditionalMaterialGroup1Name,
               @EndUserText.label: 'Price Type'
               pricetype,
               @EndUserText.label: 'Sales Contract Date'
               contractdate,
               @EndUserText.label: 'Item Paint Info'
               materialpaintinfo,
               //               @EndUserText.label: 'Hold Order'
               //               holdorderstatus,
               @EndUserText.label: 'Approval Status'
               holdstatus,
               @EndUserText.label: 'Container Freight In USD'
               contfreight,
               @EndUserText.label: 'SO Wt-KG'
               salesorderweight,
               //               @EndUserText.label: 'Pilot Production Approved'
               //               pilotprdapp,
               //               @EndUserText.label: 'Pattern Approved'
               //               ptnapp
               //
               @EndUserText.label: 'Hold Status'
               soholdstat,
               @EndUserText.label: 'Hold by Marketing'
               HoldbyMakt,
               @EndUserText.label: 'Order Reason'
               SDDocumentReasonText,
               @EndUserText.label: 'MOC'
               moc,
               @EndUserText.label: 'Pattern Approved'
               ptnapp,
               @EndUserText.label: 'Pilot Prodn Approved'
               pilotprdapp,
               MaterialBaseUnit,
               @EndUserText.label: 'Stock'
               @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
               stockqty,
               @EndUserText.label: 'Packing List No'
               packinglist,
               @EndUserText.label: 'Packing List Date'
               Createdon,
               Meins,
               @EndUserText.label: 'Packing List Total Quantity'
               @Semantics.quantity.unitOfMeasure: 'Meins'
               qtysum,
               @EndUserText.label: 'Rejection Reason'
               SalesDocumentRjcnReasonName,
               @EndUserText.label: 'PO Entry Mail Recd Date'
               YY1_POEntryMailRecdDat_SDH,
               @EndUserText.label: 'SO Transfer Mail Recd Date'
               YY1_SOTransferMailRecd_SDH,
               @EndUserText.label: 'Production Plant'
               production_plant


}
