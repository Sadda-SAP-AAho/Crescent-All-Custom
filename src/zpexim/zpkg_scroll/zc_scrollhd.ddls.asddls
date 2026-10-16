@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Scroll Head Dashboard'
@Metadata.allowExtensions: true
define root view entity ZC_SCROLLHD

  provider contract transactional_query

  as projection on ZR_SCROLLHEAD

{
  key id,
      @EndUserText.label: 'Scroll Number'
      scrollno,
      @EndUserText.label: 'Scroll Date'
      scrolldate,
      @EndUserText.label: 'Scroll Type'
      scrolltype,
      @EndUserText.label: 'Released'
      post,
      @EndUserText.label: 'Accounting Details'
      accountingdocdet,
      @EndUserText.label: 'Status Code'
      statuscode,
      @EndUserText.label: 'Status Description'
      statusdesc,
      @EndUserText.label: 'Choose Shipping Bill'
      shippingbill,
      @EndUserText.label: 'Total RoDTEP/DBK Value'
      rodtepttl,
      @EndUserText.label: 'Total Apply Amount'
      appliedamountttl,
      local_created_by,
      local_created_at,
      local_last_changed_by,
      local_last_changed_at,
      last_changed_at,
      attachment,
      mimetype,
      filename,
      /* Associations */
      _item : redirected to composition child ZC_SCROLLIT

}
