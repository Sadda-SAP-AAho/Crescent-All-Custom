@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EXIM Club Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_EXIMCLUBHDR

  provider contract transactional_query

  as projection on ZI_EXIMCLUBHDR

{
      @EndUserText.label: 'ID'
  key id,
      @EndUserText.label: 'SAP Clubbing No.'
      clubnointernal,
      @EndUserText.label: 'External Clubbing No.'
      clubnoexternal,
      @EndUserText.label: 'Comments'
      clubcomment,
      @EndUserText.label: 'EXIM Doc. Type'
      documenttype,
      @EndUserText.label: 'EXIM Doc. Type Desc.'
      documenttypedesc,
      @EndUserText.label: 'Created On'
      cdate,
      @EndUserText.label: 'Created At'
      ctime,      
      @EndUserText.label: 'Created By'
      cuser,
      @EndUserText.label: 'FOB Amount'
      @Semantics.amount.currencyCode: 'fobcurrency'
      fobamount,
      @EndUserText.label: 'FOB Currency'
      fobcurrency,
      @EndUserText.label: 'Deleted?'
      deleted,
      @EndUserText.label: 'Released?'      
      released,
      local_created_by,
      local_created_at,
      local_last_changed_by,
      local_last_changed_at,
      last_changed_at,
      /* Associations */
      _item : redirected to composition child ZC_EXIMCLUBITM
}
