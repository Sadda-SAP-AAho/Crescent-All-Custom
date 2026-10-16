@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commercial Customer'
define view entity ZI_EXIMCOMMCUS

  as select from ZEXIM_COMM_CUS

  association to parent ZI_EXIMCOMMHDR as _head on $projection.id = _head.id
  
{
  key id              as Id,
  key item            as Item,
      addresstype     as Addresstype,
      addresstypedesc as Addresstypedesc,
      name1           as Name1,
      name2           as Name2,
      address1        as Address1,
      address2        as Address2,
      address3        as Address3,
      street1         as Street1,
      street2         as Street2,
      country         as Country,
      pincode         as Pincode,

      _head // Make association public
}
