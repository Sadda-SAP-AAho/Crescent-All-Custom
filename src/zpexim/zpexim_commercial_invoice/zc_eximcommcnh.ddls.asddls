@EndUserText.label: 'Commercial Container Header'
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_EXIMCOMMCNH

  as projection on ZI_EXIMCOMMCNH

{

      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Authorized Person'
      Authorizedperson,
      @EndUserText.label: 'Contact No.'
      Contactno,
      @EndUserText.label: 'Designation'
      Designation,
      @EndUserText.label: 'Weighbridge No.'
      Weighbridgeno,
      @EndUserText.label: 'Weighbridge Slip No.'
      Weighbridgeslipno,
      @EndUserText.label: 'Weighbridge-In Slip Date'
      Weighbridgedatein,
      @EndUserText.label: 'Weighbridge-In Slip Time'
      Weighbridgetimein,
      @EndUserText.label: 'Weighbridge-Out Slip Date'
      Weighbridgedateout,
      @EndUserText.label: 'Weighbridge-Out Slip Time'
      Weighbridgetimeout,
      @EndUserText.label: 'Max. Permit Weight'
      Maxpermitweight,
      @EndUserText.label: 'Booking No.'
      Bookingno,
      @EndUserText.label: 'Color'
      Color,
      @EndUserText.label: 'Ex/Stuffing Start Date'
      Exstuffingstartdate,
      @EndUserText.label: 'Ex/Stuffing Start Time'
      Exstuffingstarttime,
      @EndUserText.label: 'Ex/Stuffing End Date'
      Exstuffingenddate,
      @EndUserText.label: 'Ex/Stuffing End Time'
      Exstuffingendtime,
      @EndUserText.label: 'Ex/Stuffing Total Time'
      Exstuffingtotaltime,
      @EndUserText.label: 'Shipper Reg. No.'
      Shipperregno,

      /* Associations */
      _head : redirected to parent ZC_EXIMCOMMHDR

}
