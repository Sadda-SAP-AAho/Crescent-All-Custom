CLASS zcl_draftpl_batch DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'DRAFT PL'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'DRAFT PL DATA'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_DEMO_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_DEMO_ALOGS_01'.

    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.
    METHODS constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS add_text_to_app_log_or_console
      IMPORTING i_text TYPE cl_bali_free_text_setter=>ty_text
      RAISING   cx_bali_runtime.

    DATA out             TYPE REF TO if_oo_adt_classrun_out.
    DATA application_log TYPE REF TO if_bali_log.
ENDCLASS.



CLASS ZCL_DRAFTPL_BATCH IMPLEMENTATION.


  METHOD add_text_to_app_log_or_console.
    IF sy-batch = abap_true.
      FINAL(application_log_free_text) = cl_bali_free_text_setter=>create(
        severity = if_bali_constants=>c_severity_status
        text     = i_text ).
      application_log_free_text->set_detail_level( detail_level = '1' ).
      application_log->add_item( item = application_log_free_text ).
      cl_bali_log_db=>get_instance( )->save_log( log = application_log
*                                                 assign_to_current_appl_job = abap_true
                                                 ).
    ELSE.
      out->write( |sy-batch = abap_false | ).
      out->write( i_text ).
    ENDIF.
  ENDMETHOD.


  METHOD constructor.
    TRY.
        application_log = cl_bali_log=>create_with_header(
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_DRAFTPR_01_LOG'
                                                                      subobject   = 'ZAPP_DRAFTPR_01_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


   METHOD if_apj_rt_exec_object~execute.

   DATA: lt_tab TYPE standard TABLE OF zdt_drfatpl_det.
  SELECT a~delivery, c~streetname ,c~postalcode,c~cityname,c~region,
  c~country,d~customername,b~customer,f~customer as customersalespl ,n~customer as customerdeltax,
  e~countryname , i~countryname as counbuyersalespl,h~customername as customernamesalesbp,
  g~streetname as streetname1 ,g~postalcode as postalcode1 ,g~cityname as cityname1,
  g~country as country1,g~region as regionsalesbp,m~customername as customernamedeltax,
  l~streetname as streetname2 ,l~postalcode as postalcode2 ,l~cityname as cityname2,
  l~country as country2,l~region as regiondeltax,p~countryname as coundeltax
  from zi_packlist_hdr as a
  INNER JOIN zi_packlist_itm as y on y~id = a~id
  left outer join I_OutboundDeliveryPartnerTP as b on a~delivery = b~OutboundDelivery
                                              and b~PartnerFunction = 'WE'
  left outer join I_BusinessPartnerAddressTP_3 as c on c~BusinessPartner = b~Customer
                                                     and c~AddressNumber = b~AddressID
  left outer join I_CUSTOMER                   as d on d~Customer = b~Customer
  left outer join I_CountryText                as e on e~Country = c~Country
                                                    and e~Language = 'E'
   left outer join I_DELIVERYDOCUMENTITEM       as j on j~deliverydocument = a~Delivery and j~DeliveryDocumentItem = y~Posnr
   left outer join I_SALESORDERITEM             as k on k~SalesOrder = j~ReferenceSDDocument
                                                    and k~SalesOrderItem = j~ReferenceSDDocumentItem
   left outer join I_SALESORDERPARTNER      as f on k~SalesOrder = f~salesorder
                                                    and f~PartnerFunction = 'RE'
   left outer join I_BusinessPartnerAddressTP_3  as g on g~BusinessPartner = f~Customer
                                                      and g~AddressNumber = f~AddressID
   left outer join I_Customer                   as h on h~Customer = f~Customer
   left outer join I_CountryText                as i on i~Country = g~Country
                                                     and i~Language = 'E'
   left outer join I_BillingDocumentItem        as z on  z~ReferenceSDDocument = a~delivery
                                                     and z~ReferenceSDDocumentItem = y~Posnr
                                                     and z~ReferenceSDDocumentCategory = 'J'
                                                     and z~BillingDocumentType = 'F8'
   left outer join I_BILLINGDOCUMENTPARTNER   as n on n~BillingDocument = z~BillingDocument
                                                     and n~Customer = z~BillToParty
                                                     and n~PartnerFunction = 'RE'
   left outer join I_BusinessPartnerAddressTP_3 as l on l~BusinessPartner = n~Customer
                                                     and l~AddressNumber = n~AddressID
   left outer join I_Customer                   as m on m~Customer = n~Customer
   left outer join I_CountryText                as p on i~Country = g~Country
                                                     and i~Language = 'E'

  where a~canind <> 'X'
  into table @DATA(lt_tab1).

     LOOP AT lt_tab1  INTO DATA(ls_table).
      APPEND VALUE #(
          customername    = |{ ls_table-CustomerName }|
          address         = |{ ls_table-StreetName } ,{ ls_table-PostalCode } ,{ ls_table-CityName },{ ls_table-Country }|
          addressbp       = |{ ls_table-streetname1 } ,{ ls_table-postalcode1 } ,{ ls_table-cityname1 },{ ls_table-country1 }|
          customernamebp  = |{ ls_table-customernamesalesbp }|
          customer        = |{ ls_table-Customer }|
          streetname      = |{ ls_table-StreetName }|
          shipinsadd1     = |{ ls_table-PostalCode } ,{ ls_table-CityName },{ ls_table-Country }|
          customer1       = |{ ls_table-customersalespl }|
          counbuyer       = |{ ls_table-counbuyersalespl }|
          counconsignee   = |{ ls_table-CountryName }|
          regionbp       = |{ ls_table-regionsalesbp }|
          regionsh       = |{ ls_table-region }|
          addressdeltax  = |{ ls_table-streetname2 } ,{ ls_table-postalcode2 } ,{ ls_table-cityname2 },{ ls_table-country2 }|
          customernamedeltax  = |{ ls_table-customernamedeltax }|
          customer2        = |{ ls_table-customerdeltax }|
          regiondeltax     = |{ ls_table-regiondeltax }|
          coundeltax       = |{ ls_table-coundeltax }|
        ) TO lt_tab.

    ENDLOOP.
    IF lt_tab IS NOT INITIAL.
      COMMIT ENTITIES BEGIN.
      MODIFY zdt_drfatpl_det FROM TABLE @lt_tab.
      COMMIT WORK AND WAIT.
      COMMIT ENTITIES END.
    ENDIF.

ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.

    TRY.
        "
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
        "
      CATCH cx_root INTO FINAL(job_scheduling_exception). " TODO: variable is assigned but only used in commented-out code (ABAP cleaner) " TODO: variable is assigned but never used (ABAP cleaner)
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
