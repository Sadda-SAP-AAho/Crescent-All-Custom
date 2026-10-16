CLASS zcl_sales_cus DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_sal_cusdet.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SALES_CUS IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                       FOR HDB
                       LANGUAGE SQLSCRIPT
                       OPTIONS READ-ONLY
                      USING z_I_Sales_order z_i_sales_ord_partner z_i_customer Z_I_CountryText Z_I_businesspartner Z_I_regiontext.

*i_salesorder
    lt_item = select session_context( 'CLIENT' ) as Mandt, a.salesorder, b.customer, b.partnerfunction as pfunc, d.customername as cusname,
                     concat( c.streetname,
                     concat( case when c.streetsuffixname <> ''
                                  then concat(', ',c.streetsuffixname)
                                  ELSE '' END,
                     concat( CASE when c.additionalstreetsuffixname <> ''
                                  then concat(', ',c.additionalstreetsuffixname)
                                  ELSE '' END,
                     concat( CASE when c.postalcode <> ''
                                  then concat(', ',c.postalcode)
                                  ELSE '' END,
                     concat( CASE when c.cityname <> ''
                                  then concat(', ',c.cityname)
                                  ELSE '' END,
                     concat( CASE when f.regionname <> ''
                                  then concat(', ',f.regionname)
                                  ELSE '' END,
                     concat( ', ', e.countryname ) ) ) ) ) ) ) as address,
                     c.streetname, concat( c.postalcode, concat( ' ,', concat( c.cityname, concat( ' ,', c.country ) ) ) ) as shipinsadd,
                     c.country, e.countryname, c.region
              from z_i_sales_order as a
              inner join  z_i_sales_ord_partner                      as b on a.salesorder = b.salesorder
              left outer join Z_I_businesspartner as c on c.businesspartner = b.customer
                                                          and c.addressnumber   = b.addressid
              left outer join z_i_customer                   as d on d.customer = b.customer
              left outer join Z_I_CountryText               as e on e.country = c.country and e.language = 'E'
              left outer join Z_I_regiontext                as f ON f.country = c.country and f.language = 'E'
                                                                   and f.region = c.region
              where b.customer <> '';

      return  select *
        from :lt_item
      order by salesorder asc;

  endmethod.
ENDCLASS.
