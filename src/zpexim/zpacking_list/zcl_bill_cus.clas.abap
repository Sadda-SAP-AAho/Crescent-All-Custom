CLASS zcl_bill_cus DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb .
  CLASS-METHODS get_data FOR TABLE FUNCTION ZTBL_FCTN_BILL_CUSDET.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BILL_CUS IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                     USING zI_billingdocument zI_BILLINGDOCUMENTPARTNER zp_BusinessPartnerAddressTP_3 zi_CUSTOMER zi_CountryText zp_RegionText.


   lt_item = select a.mandt, a.billingdocument, b.customer, b.PartnerFunction as pfunc, d.customername as cusname,
                    concat( c.StreetName,
                      concat( case when c.streetsuffixname <> ''
                                  then concat(', ',c.streetsuffixname)
                                  else '' END,
                     concat( CASE when c.additionalstreetsuffixname <> ''
                                  then concat(', ',c.additionalstreetsuffixname)
                                  else '' END,
                     concat( CASE when c.postalcode <> ''
                                  then concat(', ',c.postalcode)
                                  else '' END,
                     concat( CASE when c.cityname <> ''
                                  then concat(', ',c.cityname)
                                  else '' END,
                     concat( CASE when f.regionname <> ''
                                  then concat(', ',f.regionname)
                                  else '' END,
                     concat( ', ', e.countryname ) ) ) ) ) ) ) as address,
                    c.streetname, concat( c.PostalCode, Concat( ' ,', concat( c.CityName, concat( ' ,', c.country ) ) ) ) as shipinsadd,
                    c.country, e.countryname, c.region
             from zI_billingdocument as a
             inner join zI_BILLINGDOCUMENTPARTNER          as b on a.billingdocument = b.billingdocument
             left outer join zp_BusinessPartnerAddressTP_3 as c on c.BusinessPartner = b.Customer
                                                         and c.AddressNumber   = b.AddressID
             left outer join zi_CUSTOMER                   as d on d.Customer = b.Customer
             left outer join zi_CountryText                as e on e.Country = c.Country and e.Language = 'E'
             left outer join zp_RegionText                 as f on f.country = c.country and f.language = 'E'
                                                                  and f.region = c.region
             WHERE b.customer <> '';



     RETURN  select *
       from :lt_item
     ORDER BY billingdocument ASC;


  ENDMETHOD.
ENDCLASS.
