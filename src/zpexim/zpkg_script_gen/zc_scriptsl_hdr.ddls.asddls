@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View of Script Sales Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity zc_scriptsl_hdr
  provider contract transactional_query
  as projection on zi_scriptsl_hdr
{
  key id,
      @EndUserText.label: 'Company Code'
      companycode,
      @EndUserText.label: 'Invoice Origin From'
      bupla,
      @EndUserText.label: 'Script Sales Number'
      scriptsalesno,
      @EndUserText.label: 'Document Date'
      scriptsalesdate,
      @EndUserText.label: 'Script Number'
      scriptno,
      @EndUserText.label: 'SAC Code'
      saccode,
      @EndUserText.label: 'Customer Code'
      customer,
      @EndUserText.label: 'Customer Name'
      customername,
      @EndUserText.label: 'Account Document Number'
      accdocno,
      @EndUserText.label: 'Document Year'
      docyear,
      @EndUserText.label: 'Doc Refno'
      accpostref,
      @EndUserText.label: 'GL Account No.'
      glno,
      @EndUserText.label: 'Status'
      status,
      currency,
      @Semantics.amount.currencyCode : 'currency'
      @EndUserText.label: 'Total Realization Amount'
      sum_realizationamt,
      @Semantics.amount.currencyCode : 'currency'
      @EndUserText.label: 'Total Sealable Value'
      sum_saleablevalue,
      local_created_by,
      local_created_on,
      local_created_at,
      local_last_changed_by,
      local_last_changed_on,
      local_last_changed_at,
      last_changed_at,
      @EndUserText.label: 'Post'
      post,
      @EndUserText.label: 'Account Update'
      accupd,
      printsi,
      flag,
      /* Associations */
      _Item : redirected to composition child zc_scriptsl_itm
}
