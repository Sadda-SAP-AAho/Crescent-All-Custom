CLASS zcl_salenoteno DEFINITION
   PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztabl_salenoteno.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SALENOTENO IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                        FOR HDB
                        LANGUAGE SQLSCRIPT
                        OPTIONS READ-ONLY
                        USING  zi_billdoc zi_deldash_hdr  .

    it_item = select DISTINCT a.aclient as mandt , a.billingdocument , a.referencesddocument, b.salesnoteref
    from zi_billdoc as a inner join zi_deldash_hdr as b on a.referencesddocument = b.delivery
*    where a.aclient = :client
    ;

      it_item2 = select mandt , billingdocument , count ( salesnoteref ) as num
                       from :it_item
                       group by  billingdocument , mandt;

      it_item3 = select a.mandt, a.billingdocument ,
      case
      when a.num <= 1
      then
      string_agg( b.salesnoteref , '' )
      else
      string_agg( b.salesnoteref , ' , ' )
      end as salesnoteref
      from :it_item2 as a inner join :it_item as b on a.billingdocument = b.billingdocument
      group by a.billingdocument , a.num,a.mandt;

      RETURN SELECT mandt as client ,
      billingdocument as billdoc,
      cast(salesnoteref as nvarchar (100) ) as salenoteno
      from :it_item3;

  endmethod.
ENDCLASS.
