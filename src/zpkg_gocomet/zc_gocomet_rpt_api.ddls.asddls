@AbapCatalog.sqlViewName: 'ZCGOCOMETAPI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GoComet Report - API'
@Metadata.allowExtensions: true

define view ZC_GOCOMET_RPT_API
  as select from ZI_GOCOMET_RPT_API
{
      @EndUserText.label: 'Mode'
  key Delmode,

      @EndUserText.label: 'Reference No'
  key Refno,

      @EndUserText.label: 'Tracking Number'
  key Trackno,

      @EndUserText.label: 'Carrier'
      Carrier,

      @EndUserText.label: 'Container Numbers'
      Carnum,

      @EndUserText.label: 'Factory Dispatch Date'
      factDisdate,

      @EndUserText.label: 'Origin (POL)'
      Pol,

      @EndUserText.label: 'Destination (POD)'
      Pod,

      @EndUserText.label: 'Star/Mark as Priority'
      Markcap,

      @EndUserText.label: 'Client Group Code'
      Clntgrpcode,

      @EndUserText.label: 'Consignee Group Code'
      Consgrpcode,

      @EndUserText.label: 'Consignee Group Codes'
      Consgrpcodes,

      @EndUserText.label: 'Carrier Code'
      Carcode,

      @EndUserText.label: 'Share With'
      Sharewith,

      @EndUserText.label: 'Vessel Name'
      Vesname,

      @EndUserText.label: 'Container Size'
      Consize,

      @EndUserText.label: 'Container Type'
      Contype,

      @EndUserText.label: 'Currency'
      Currency,

      @EndUserText.label: 'Destination Detention Charges'
      Destdetnchrg,

      @EndUserText.label: 'Destination Detention Free Days'
      Destdetnfreedays,

      @EndUserText.label: 'Detention Start Date'
      Deststrtdate,

      @EndUserText.label: 'Detention End Date'
      Destenddate,

      @EndUserText.label: 'Destination Demurrage Charges'
      Destdemrgchrg,

      @EndUserText.label: 'Destination Demurrage Free Days'
      Destdemrgfreedays,

      @EndUserText.label: 'Demurrage Start Date'
      Demrgstrtdate,

      @EndUserText.label: 'Demurrage End Date'
      Demrgenddate,

      @EndUserText.label: 'Destination Combined Charges'
      Destcombchrg,

      @EndUserText.label: 'Destination Combined Free Days'
      Destcombfreedays,

      @EndUserText.label: 'Combined Start Date'
      Combstrtdate,

      @EndUserText.label: 'Combined End Date'
      Combenddate,

      @EndUserText.label: 'Auto Detect Carrier?'
      Autodetctcarr,

      @EndUserText.label: 'Delivery Date'
      Deldate,

      @EndUserText.label: 'Invoice No'
      Invno,

      @EndUserText.label: 'Invoice Date'
      Invdt
}
