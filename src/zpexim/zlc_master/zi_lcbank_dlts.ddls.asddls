@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity View for LC Bank Details'
@Metadata.allowExtensions: true
define view entity zi_lcbank_dlts 
as select from zdt_lcbank_dlts
association to parent zi_lchead as _head on $projection.Id = _head.Id
{
    key zdt_lcbank_dlts.id as Id,
    key zdt_lcbank_dlts.item1 as Item1,
    zdt_lcbank_dlts.banktype as Banktype,
    zdt_lcbank_dlts.land1 as Land1,
    zdt_lcbank_dlts.hktid as Hktid,
    zdt_lcbank_dlts.bankl as Bankl,
    zdt_lcbank_dlts.hbkid as Hbkid,
    zdt_lcbank_dlts.banka as Banka,
    zdt_lcbank_dlts.hkont as Hkont,
    zdt_lcbank_dlts.brnch as Brnch,
    zdt_lcbank_dlts.ort01 as Ort01,
    zdt_lcbank_dlts.bezei as Bezei,
    zdt_lcbank_dlts.swift as Swift,
    zdt_lcbank_dlts.locallastchangedat as Locallastchangedat,
    _head // Make association public
}
