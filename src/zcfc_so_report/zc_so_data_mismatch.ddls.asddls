@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO Data Mismatch'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_SO_DATA_MISMATCH
  provider contract transactional_query
  as projection on ZI_SO_DATA_MISMATCH
{
      @EndUserText.label: 'Sales Order No'
  key SalesOrder,

      @EndUserText.label: 'Sales Order Date'
  key SalesOrderDate,
      
      @EndUserText.label: 'Plant'
  key Plant,

      @EndUserText.label: 'Customer'
  key Customer,

      @EndUserText.label: 'Created By'
  key Createdby,

      @EndUserText.label: 'SO Item No'
  key SalesOrderItem,

      @EndUserText.label: 'Material'
      Material,

      @EndUserText.label: 'Shipping Condition'
      ShippingCond,

      @EndUserText.label: 'Header Incoterms'
      IncoTermsHead,

      @EndUserText.label: 'Item Incoterms'
      IncoTermsItem,

      @EndUserText.label: 'Header Incoterms Location 1'
      IncoTerms1Head,

      @EndUserText.label: 'Item Incoterms Location 1'
      IncoTerms1Item,

      @EndUserText.label: 'Header Payment Terms'
      PayTermsHead,

      @EndUserText.label: 'Item Payment Terms'
      PayTermsItem,
      
      @EndUserText.label: 'Remarks'
      Remarks
}
