CLASS zcl_http_printcasteditem DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
    INTERFACES if_oo_adt_classrun .
    TYPES:BEGIN OF ty_template_body,
        xdp_Template        TYPE xstring,
        template_Name       TYPE c LENGTH 30,
        description         TYPE c LENGTH 280,
        note                TYPE c LENGTH 280,
        locale              TYPE c LENGTH 6,
        language            TYPE c LENGTH 280,
        master_Language     TYPE c LENGTH 280,
        business_Area       TYPE c LENGTH 280,
        business_Department TYPE c LENGTH 280,
     END OF ty_template_body.
    DATA:
      mo_http_destination TYPE REF TO if_http_destination,
      mv_client           TYPE REF TO if_web_http_client,
      iv_get_binary       TYPE abap_boolean.

    METHODS: handle_printrequest
      IMPORTING
        VALUE(request) TYPE REF TO if_web_http_request
        response       TYPE REF TO if_web_http_response.

    METHODS getCID RETURNING VALUE(cid) TYPE abp_behv_cid.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_HTTP_PRINTCASTEDITEM IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.
    CASE request->get_method( ).
      WHEN CONV string( if_web_http_client=>post ).
        handle_printrequest( request = request response = response ).
      WHEN OTHERS.
        response->set_status( i_code = 405 i_reason = 'Method Not Allowed' ).
        response->set_text( 'Only POST method is supported' ).
    ENDCASE.
  ENDMETHOD.


  METHOD handle_printrequest.

    DATA: request_data TYPE TABLE OF  ty_request_data,
          fgbom        TYPE STRUCTURE FOR CREATE zr_fgbomlist,
          lt_fgboms    TYPE TABLE FOR CREATE zr_fgbomlist,
          rs_template  TYPE ty_template_body.
    DATA :result12 TYPE string,
          lv_xml   TYPE string.
    xco_cp_json=>data->from_string( request->get_text(  ) )->write_to( REF #( request_data ) ).

    DATA(cur_date) = cl_abap_context_info=>get_system_date(  ).

    DATA(lv_initial) =     |<Form>| && |<Items>|.

    LOOP AT request_data INTO DATA(ls_data).

      SELECT SINGLE FROM zr_fgbomlist
      FIELDS fg
      WHERE material = @ls_data-matnr
              AND plant = @ls_data-plant
              AND operation = '0040'
      INTO @DATA(existing_mat).

      SELECT SINGLE FROM zc_castitmsrlprint
      FIELDS shpflrdt
      WHERE matnr = @ls_data-matnr AND plant = @ls_data-plant
      AND serial = @ls_data-serial AND shpflrno = @ls_data-shpflrno
      INTO @DATA(shopfloordate).

      IF existing_mat IS INITIAL.

        fgbom-%cid = getcid(  ).
        fgbom-plant = ls_data-plant.
        fgbom-material = ls_data-matnr.
        fgbom-operation = '0040'.
        fgbom-opno = 1.
        APPEND fgbom TO lt_fgboms.
        CLEAR fgbom.

        DATA(insert_bool) = abap_true.
        WHILE insert_bool EQ abap_true.

          DATA(search_mat) = lt_fgboms[ sy-tabix ]-material.

          SELECT SINGLE FROM i_billofmaterialitemdex_3 AS a
          INNER JOIN i_billofmaterialtp_2 AS b ON a~billofmaterial = b~billofmaterial AND a~billofmaterialvariant = b~billofmaterialvariant
                                    AND a~billofmaterialcategory = b~billofmaterialcategory
          INNER JOIN i_product AS c ON b~material = c~product
          FIELDS b~material, c~productgroup
          WHERE a~billofmaterialcomponent = @search_mat
          AND b~plant = @ls_data-plant
          AND @cur_date BETWEEN a~validitystartdate AND a~validityenddate
          INTO @DATA(component).

          IF sy-subrc EQ 0.
            fgbom-%cid = getcid(  ).
            fgbom-opno = sy-tabix + 1.
            fgbom-material = component-material.
            fgbom-plant = ls_data-plant.

            CASE component-productgroup.
              WHEN 'Z025'.
                fgbom-operation = '0040'.
              WHEN 'Z027'.
                fgbom-operation = '0050'.
              WHEN 'Z026'.
                fgbom-operation = '0060'.
              WHEN 'Z028'.
                fgbom-operation = '0070'.
              WHEN 'Z042'.
              WHEN 'Z003'.
                fgbom-operation = '0080'.
              WHEN OTHERS.
                fgbom-operation = '0000'.
            ENDCASE.
            APPEND fgbom TO lt_fgboms.
            CLEAR fgbom.
          ELSE.
            insert_bool = abap_false.
          ENDIF.
        ENDWHILE.

        LOOP AT lt_fgboms ASSIGNING FIELD-SYMBOL(<fs_fgbom>).
          <fs_fgbom>-fg = lt_fgboms[ lines( lt_fgboms ) ]-material.
        ENDLOOP.
        fgbom = lt_fgboms[ lines( lt_fgboms ) ].

        MODIFY ENTITIES OF zr_fgbomlist
        ENTITY fgbomlist
        CREATE FIELDS ( plant opno fg material operation )
        WITH lt_fgboms
        MAPPED DATA(mapped)
        FAILED DATA(failed)
        REPORTED DATA(reported).


        IF failed IS  INITIAL.

          COMMIT ENTITIES BEGIN
              RESPONSE OF zr_fgbomlist
              FAILED DATA(ls_save_failed)
              REPORTED DATA(ls_save_reported).
          IF ls_save_failed IS NOT INITIAL.
            ROLLBACK ENTITIES.
          ENDIF.
          COMMIT ENTITIES END.


        ELSE.
          " Handle errors
          DATA lv_error TYPE string.

          IF lines( ls_save_reported-fgbomlist ) > 0.
            lv_error = |{ sy-msgid } { sy-msgno }|.
          ENDIF.

          LOOP AT ls_save_reported-fgbomlist ASSIGNING FIELD-SYMBOL(<fs_error>).
            lv_error =  | { <fs_error>-%msg->if_message~get_text( ) } |.
          ENDLOOP.


          LOOP AT reported-fgbomlist ASSIGNING FIELD-SYMBOL(<fs_error1>).
            lv_error = | { <fs_error1>-%msg->if_message~get_text( ) } |.
          ENDLOOP.

        ENDIF.
      ELSE.
        fgbom-material = existing_mat.
      ENDIF.

*    PRINT LOGIC HERE
      SELECT SINGLE FROM i_producttext
      FIELDS productname
      WHERE product = @fgbom-material
            AND language = @sy-langu
       INTO @DATA(product_name).

      lv_xml = lv_xml &&
      |  <Item>| &&
      |  <ItemCode>{ fgbom-material }</ItemCode>| &&
      |  <ItemName>{ product_name }</ItemName>| &&
      |  <CastingDate>{ shopfloordate }</CastingDate>| &&
      |  <Plant>{ ls_data-plant }</Plant>| &&
      |  <SerialNo>{ fgbom-material }:::{ ls_data-serial }</SerialNo>| &&
      |  </Item>|.

      CLEAR:fgbom-material,existing_mat.

    ENDLOOP.

    DATA(lv_end) =  |</Items>| && |</Form>|.

    DATA(final_xml) = lv_initial && lv_xml && lv_end.

    REPLACE ALL OCCURRENCES OF '&' IN final_xml WITH 'and'.

    DATA lc_template_name TYPE string.
    SELECT SINGLE FROM zr_integration
       FIELDS intgpath
       WHERE intgmodule = 'CASTED-BARCODE-PRINT'
       INTO @lc_template_name.

    CALL METHOD zcl_ads_print=>getpdf(
      EXPORTING
        xmldata  = final_xml
        template = lc_template_name
      RECEIVING
        result   = result12 ).

    TRY.
        response->set_header_field( i_name = 'Content-Type' i_value = 'text/html' ).
        response->set_text( result12 ).
      CATCH cx_static_check INTO DATA(er).
        response->set_text( er->get_longtext(  ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD getcid.
    TRY.
        cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DELETE FROM zdt_fgboms.
  ENDMETHOD.
ENDCLASS.
