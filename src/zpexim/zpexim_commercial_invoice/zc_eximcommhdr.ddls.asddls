@EndUserText.label: 'Commercial Invoice Header'
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_EXIMCOMMHDR

  provider contract transactional_query

  as projection on ZI_EXIMCOMMHDR
{

      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Internal Clubbing No.'
      Invclubnointernal,
      @EndUserText.label: 'External Clubbing No.'
      Invclubnoexternal,
      @EndUserText.label: 'External Clubbing Date'
      Invclubnodate,
      @EndUserText.label: 'Created On'
      Invcommdate,
      @EndUserText.label: 'Created By'
      Invcommuser,
      @EndUserText.label: 'Created At'
      Invcommtime,
      @EndUserText.label: 'Date of Discharge'
      Dateofdischarge,
      @EndUserText.label: 'FOB Amount'
      fobamount,
      @EndUserText.label: 'FOB Currency'
      fobcurrency,
      @EndUserText.label: 'Deleted?'
      Deleted,
      @EndUserText.label: 'Released?'
      Released,
      @EndUserText.label: 'Print'
      Tprint,
      @EndUserText.label: 'Status'
      Status,

      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,

      _cus : redirected to composition child ZC_EXIMCOMMCUS,
      _pay : redirected to composition child ZC_EXIMCOMMPAY,
      _shp : redirected to composition child ZC_EXIMCOMMSHP,
      _add : redirected to composition child ZC_EXIMCOMMADD,
      _cnh : redirected to composition child ZC_EXIMCOMMCNH,
      _cni : redirected to composition child ZC_EXIMCOMMCNI,
      _itm : redirected to composition child ZC_EXIMCOMMITM

}
