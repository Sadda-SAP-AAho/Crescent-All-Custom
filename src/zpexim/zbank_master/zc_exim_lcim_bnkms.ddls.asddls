@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank LC Limit Maintain View'
@Metadata.allowExtensions: true
define root view entity ZC_EXIM_LCIM_BNKMS
  provider contract transactional_query
  as projection on ZI_EXIM_LCIM_BNKMS
{
          @EndUserText.label: 'ID'
          @UI.hidden: true
  key     Internaid,
          @EndUserText.label: 'Company Code'
  key     Bukrs,
          @EndUserText.label: 'Bank Keys'
  key     Bankl,
          @EndUserText.label: 'House Bank'
  key     Hbkid,
          @EndUserText.label: 'Bank ID'
  key     Hktid,
          @EndUserText.label: 'Fiscal Year'
  key     Gjahr,
          @EndUserText.label: 'Swift Code'
  key     Zswift,
          @EndUserText.label: 'Account No'
  key     Zaccno,
          @EndUserText.label: 'Country'
          Zland1,
          @EndUserText.label: 'IFSC Code'
          Zifsccode,
          @EndUserText.label: 'Bank Code'
          Zbank,
          @EndUserText.label: 'Branch'
          Zbranch,
          @EndUserText.label: 'Address'
          Zaddress,
          @EndUserText.label: 'Address1'
          Zaddress1,
          @EndUserText.label: 'Address2'
          Zaddress2,
          @EndUserText.label: 'Address3'
          Zaddress3,
          @EndUserText.label: 'Code'
          Zadcode,
          @EndUserText.label: 'State Code'
          Zstate,
          @EndUserText.label: 'Commission Interest'
          Commissionint,
          @EndUserText.label: 'Discounting interest'
          Discountinginterest,
          @EndUserText.label: 'Currency'
          Waers,
          @EndUserText.label: 'Buyer Credit Limit'
          Bclimit,
          @EndUserText.label: 'BC Clean Utilised'
          Bccleanutilised,
          @EndUserText.label: 'BC Clean Available'
          Bccleanavailable,
          @EndUserText.label: 'BG Clean Limit'
          Bglimit,
          @EndUserText.label: 'BG Pledge Limit'
          Bgpledgelimit,
          @EndUserText.label: 'BG Clean Utilised'
          Bgutilised,
          @EndUserText.label: 'BG Clean Available'
          Bgavailable,
          @EndUserText.label: 'LC Clean limit'
          Lclimit,
          @EndUserText.label: 'LC Clean Utilised'
          Lcutilised,
          @EndUserText.label: 'LC Clean Available'
          lcavailable,
          @EndUserText.label: 'LC Pledge Limit'
          Lcpledgelimit,
          @EndUserText.label: 'Pledge Limit'
          Pledgelimit,
          @EndUserText.label: 'Non Fund Based Limit'
          TotalnonfundBased,
          @EndUserText.label: 'Fund Based Limit'
          Fundbasedlimit,
          @EndUserText.label: 'Total Limit'
          Totallimit,
          @EndUserText.label: 'Interchangeability'
          interchangeability,
          @EndUserText.label: 'Cash Credit'
          Cashc,
          @EndUserText.label: 'Cash Credit Utilised'
          cashcutilised,
          @EndUserText.label: 'FCNR'
          Fcnr,
          @EndUserText.label: 'FCNR Utilised'
          fcnrutilised,
          @EndUserText.label: 'WCDC'
          Wcdc,
          @EndUserText.label: 'WCDC Utilised'
          wcdcutilised,
          @EndUserText.label: 'Packing Credit'
          Packcredit,
          @EndUserText.label: 'Packing Credit Utilised'
          packcreditutilised,
          @EndUserText.label: 'Supplier'
          Lifnr,
          @EndUserText.label: 'Incoming GL'
          Icgl,
          @EndUserText.label: 'Outgoing GL'
          Oggl,
          @EndUserText.label: 'Refresh'
          ref,
          Locallastchangedat
}
