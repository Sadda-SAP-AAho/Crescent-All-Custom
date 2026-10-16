@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Delivery Dash Head'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_DELDASH_HDR
  provider contract transactional_query
  as projection on ZI_DELDASH_HDR
{
      @EndUserText.label: 'ID'
  key Id,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Delivery'
      Delivery,
      @EndUserText.label: 'Revision'
      Revision,
      @EndUserText.label: 'CHA Name'
      Chaname,
      @EndUserText.label: 'Packing Mark'
      Pacmark,
      @EndUserText.label: 'Packing Released To Factory'
      Packrelfac,
      @EndUserText.label: 'Scomet Decl.'
      Scomdec,
      @EndUserText.label: 'Fema Declaration'
      Femadec,
      @EndUserText.label: 'LC No'
      Lcno,
      @EndUserText.label: 'LC Date'
      Lcdt,
      @EndUserText.label: 'LC Issuing Bank Name'
      Issbnkname,
      @EndUserText.label: 'Container S'
      Consize,
      @EndUserText.label: 'Container Size '
      Consizen,
      @EndUserText.label: 'Document Release to CHA Date'
      Docrelchadt,
      @EndUserText.label: 'Container Lifting Date'
      Conliftdt,
      @EndUserText.label: 'Container Factory In Date'
      Confacindt,
      @EndUserText.label: 'Container Pick Up Validity Dt'
      Conpckvaldt,
      @EndUserText.label: 'Container Pick Up Letter Dt'
      Conpckletdt,
      @EndUserText.label: 'Shipp. Bill No'
      Shipbillno,
      @EndUserText.label: 'Shipping Bill Date'
      Shpbilldt,
      @EndUserText.label: 'Carting Order Received On'
      Cartordrecdt,
      @EndUserText.label: 'Vessel/flight No'
      Vesselno,
      @EndUserText.label: 'Cont. No'
      Contno,
      @EndUserText.label: 'Stuffing Date'
      Stuffdt,
      @EndUserText.label: 'Booking No.'
      Bookingno,
      @EndUserText.label: 'Port Of Transhipment'
      Porttrans,
      @EndUserText.label: 'LORRY No.'
      Lorryno,
      @EndUserText.label: 'Script Date'
      Scriptdt,
      @EndUserText.label: 'RFID Seal No.'
      Rfidsealno,
      @EndUserText.label: 'Delivery Mode'
      Delmode,
      @EndUserText.label: 'Late Carting Ord Recd Remarks'
      Latordrecrem,
      @EndUserText.label: 'Late Container Dock In Remarks'
      Latcondocrem,
      @EndUserText.label: 'Pre-Carriage By'
      Precarby,
      @EndUserText.label: 'Place of Receipt by pre carg'
      Por,
      @EndUserText.label: 'Carrier Seal No '
      Carsealno,
      @EndUserText.label: 'Shipping Line'
      Shipline,
      @EndUserText.label: 'Container Name'
      Conname,
      @EndUserText.label: 'Carting Order Applied On Dt'
      Carordappdt,
      @EndUserText.label: 'ETA Date'
      Etadt,
      @EndUserText.label: 'Container Cut Off Dt'
      Concutoffdt,
      @EndUserText.label: 'ETD Date'
      Etddt,
      @EndUserText.label: 'VGM'
      Finalseal,
      @EndUserText.label: 'Detail Recd from CHA for SI Dt'
      Detrecchadt,
      @EndUserText.label: 'SI Sent On Date'
      Sisentdt,
      @EndUserText.label: 'Container Dock In Date'
      Condockindt,
      @EndUserText.label: 'Shipment Type'
      Shiptype,
      @EndUserText.label: 'Empty Return Date'
      Empretdt,
      @EndUserText.label: 'Third Party Forwarder'
      Thrdprtyfor,
      @EndUserText.label: 'Forwarder'
      forwarder,
      @EndUserText.label: 'Forwarder Name'
      forwardernam,
      @EndUserText.label: 'Ship-to-Party Code'
      Shpprtycode,
      @EndUserText.label: 'Ship-to-Party Name'
      Shpprtyname,
      @EndUserText.label: 'Ship-to-Party Address 1'
      Shpprtyadd1,
      @EndUserText.label: 'Ship-to-Party Address 2'
      Shpprtyadd2,
      @EndUserText.label: 'LUT/IGST'
      Lutigst,
      @EndUserText.label: 'Port Of Loading'
      Pol,
      @EndUserText.label: 'Port of Destination'
      Pod,
      @EndUserText.label: 'Final Destination'
      Findes,
      @EndUserText.label: 'Country of Origin'
      Coo,
      @EndUserText.label: 'Country of Destination'
      Cod,
      @EndUserText.label: 'Customer Marks'
      Cusmar,
      @EndUserText.label: 'Description of Goods 1'
      Descgoods,
      @EndUserText.label: 'Description of Goods 2'
      Descgoods1,
      @EndUserText.label: 'Vessel Tentative Sailing Date'
      Vessaildt,
      @EndUserText.label: 'Origin/Departure Actual Date'
      Ordepdt,
      @EndUserText.label: 'ATA Date'
      Atadt,
      @EndUserText.label: 'Sale Note reference number'
      Salesnoteref,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Print Proforma Invoice'
      Invprint,
      @EndUserText.label: 'Place Of Delivery'
      Placedel,
      @EndUserText.label: 'IMO No.'
      Imono,
      @EndUserText.label: 'Status'
      Status,
      @EndUserText.label: 'Cancel'
      Cancel,
      @EndUserText.label: 'Cancel Indictor'
      Canind,
      @EndUserText.label: 'Cancel By'
      Cancelby,
      @EndUserText.label: 'Cancel On'
      Cancelon,
      @EndUserText.label: 'Text Field 1'
      Textfield1,
      @EndUserText.label: 'Text Field 2'
      Textfield2,
      @EndUserText.label: 'Freight Remarks'
      Freightremarks,
      @EndUserText.label: 'Container Dispatched from Factory'
      Contdisfact,
      @EndUserText.label: 'Container Pick up from'
      Contpickfrm,
      @EndUserText.label: 'Leo Date'
      leodate,
      Flag,
      /* Associations */
      _Item : redirected to composition child ZC_DELDASH_ITM

}
