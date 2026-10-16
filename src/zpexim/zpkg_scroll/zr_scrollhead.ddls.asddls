@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Scroll Head Dashboard'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_SCROLLHEAD

  as select from zdt_scroll_head

  composition [0..*] of ZR_SCROLLITEM as _item

{

  key id,
      scrollno,
      scrolldate,
      scrolltype,
      post,
      accountingdocdet,
      statuscode,
      statusdesc,
      shippingbill,
      rodtepttl,
      appliedamountttl,
      local_created_by,
      local_created_at,
      local_last_changed_by,
      local_last_changed_at,
      last_changed_at,
      @Semantics.largeObject: { mimeType: 'mimetype', fileName: 'filename', contentDispositionPreference: #INLINE }
      attachment,
      @Semantics.mimeType: true
      mimetype,
      filename,
      _item
}
