@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO Data Mismatch'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_SO_DATA_MISMATCH
  as select distinct from ZC_SO_DATA_MISMATCH_1

{
  key SalesOrder,
  key SalesOrderDate,
  key Plant,
  key Customer,
  key Createdby,
  key SalesOrderItem,
      Material,
      ShippingCond,
      IncoTermsHead,
      IncoTermsItem,
      IncoTerms1Head,
      IncoTerms1Item,
      PayTermsHead,
      PayTermsItem,
      Remarks
}

where
  Remarks is not initial
