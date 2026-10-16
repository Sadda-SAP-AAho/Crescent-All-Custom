CLASS zcl_bom_components_job DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'BOMCOMP'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'BOM Comp'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_DEMO_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_DEMO_ALOG_01'.

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



CLASS ZCL_BOM_COMPONENTS_JOB IMPLEMENTATION.


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
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_BOMCOM_02_LOG'
                                                                      subobject   = 'ZAPP_BOMCOM_02_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    DATA: lt_bomdet TYPE TABLE OF zdt_bomdet,
          lv_level  TYPE i VALUE '1'.

    DATA: lv_count TYPE i .
*---------------------------------------------------------------------------------------*
    SELECT * FROM zdt_bomdet INTO TABLE @DATA(lt_test).
    DELETE zdt_bomdet FROM TABLE @lt_test.
***    SELECT DISTINCT
***         plant, material
***         FROM i_billofmaterialitemtp_2
***         INTO TABLE @DATA(lt_bomcomt).
*//- Get All FG &SFG Material
    SELECT plant, material
         FROM i_productionversion
         INTO TABLE @DATA(lt_bomcomt) .
*//- Get All Component Material
    SELECT DISTINCT
         plant, billofmaterialcomponent AS material
         FROM i_billofmaterialitemtp_2
        WHERE isassembly = 'X'
         APPENDING CORRESPONDING FIELDS OF TABLE @lt_bomcomt.

    CHECK lt_bomcomt IS NOT INITIAL .
    SORT lt_bomcomt BY plant material .
    DELETE ADJACENT DUPLICATES FROM lt_bomcomt COMPARING plant material .

    LOOP AT lt_bomcomt INTO DATA(ls_bomcomt).
      lv_level = 1.

      SELECT
                   a~material,
                   a~plant                          AS plant,
                   b~bomheaderquantityinbaseunit    AS bomheaderqty,
                   b~bomheaderbaseunit              AS bomheaderqtyunit,
                   CAST( @lv_level AS INT1 )        AS bomlevel,
                   a~material                       AS parent,
                   a~billofmaterialcomponent        AS component,
                   a~billofmaterialitemquantity     AS bomitemqty,
                   a~billofmaterialitemunit         AS bomitemqtyunit,
                   _product~productgroup            AS productgroup,
                   BOMHeaderQuantityInBaseUnit      as BOMHeaderQuantityInBaseUnit

      FROM i_billofmaterialitemtp_2 AS a
              INNER JOIN i_billofmaterialheaderdex_2 AS b ON a~billofmaterial         = b~billofmaterial
                                                         AND a~billofmaterialcategory = b~billofmaterialcategory
              INNER JOIN  i_product AS _product        ON _product~product = a~billofmaterialcomponent
      WHERE a~material = @ls_bomcomt-material AND a~plant = @ls_bomcomt-plant
      INTO TABLE @DATA(lt_root).

*pass the selected BOM data into OUT_BOM
      DATA(lt_out_bom) = lt_root .
*select the components from the 1st Level BOM
      SELECT a~component, a~plant FROM @lt_root AS a INTO TABLE @DATA(lt_component).
*select the count of components from the 1st Level BOM
      lv_count = lines( lt_component ) .

*if the components are found, check for next level BOM data
      WHILE lv_count > 0 .
*increment the BOM level
        lv_level = lv_level + 1.
*select the data for the BOM of components

        SELECT
                    a~material,
                    a~plant                          AS plant,
                    b~bomheaderquantityinbaseunit    AS bomheaderqty,
                    b~bomheaderbaseunit              AS bomheaderqtyunit,
                    CAST( @lv_level AS INT1 )        AS bomlevel,
                    a~material                       AS parent,
                    a~billofmaterialcomponent        AS component,
                    a~billofmaterialitemquantity     AS bomitemqty,
                    a~billofmaterialitemunit         AS bomitemqtyunit,
                    _product~productgroup            AS productgroup,
                    BOMHeaderQuantityInBaseUnit      as BOMHeaderQuantityInBaseUnit

       FROM i_billofmaterialitemtp_2 AS a
               INNER JOIN i_billofmaterialheaderdex_2 AS b ON a~billofmaterial         = b~billofmaterial
                                                          AND a~billofmaterialcategory = b~billofmaterialcategory
               INNER JOIN  i_product AS _product          ON _product~product = a~billofmaterialcomponent
               INNER JOIN  @lt_component AS            c ON c~component = a~material AND c~plant = a~plant
       INTO TABLE @DATA(lt_child_bom).

        APPEND LINES OF lt_child_bom TO lt_out_bom.
        CLEAR lt_component[].
*select the components from the above selected child BOM
        SELECT a~component, a~plant FROM @lt_child_bom AS a INTO TABLE @lt_component.
*select the count of components from the 1st Level BOM
        lv_count = lines( lt_component ) .

      ENDWHILE .

*---
      LOOP AT lt_out_bom INTO DATA(ls_bomcomp).

        APPEND INITIAL LINE TO lt_bomdet ASSIGNING FIELD-SYMBOL(<fs_bomdet>) .

        MOVE-CORRESPONDING ls_bomcomp TO <fs_bomdet> .
*        TRY.
*            <fs_bomdet>-id =  cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
*          CATCH cx_uuid_error.
*        ENDTRY.
        <fs_bomdet>-hedmaterial = ls_bomcomt-material.
        <fs_bomdet>-parentqty = 100.

        IF ls_bomcomp-bomlevel = 1 .
          <fs_bomdet>-childqty  = 100 * ( <fs_bomdet>-bomitemqty / ls_bomcomp-BOMHeaderQuantityInBaseUnit ). "100 * <fs_bomdet>-bomitemqty.
          <fs_bomdet>-childqty1  = 100 * ( <fs_bomdet>-bomitemqty / ls_bomcomp-BOMHeaderQuantityInBaseUnit ).
        ELSE.
          lv_level = ls_bomcomp-bomlevel - 1 .
          READ TABLE lt_bomdet INTO DATA(ls_parentqty) WITH KEY bomlevel    = lv_level
                                                                component   = ls_bomcomp-parent
                                                                hedmaterial = ls_bomcomt-material.
          IF sy-subrc = 0 .
*                      <fs_bomdet>-childqty  = ls_parentqty-childqty * <fs_bomdet>-bomitemqty.
            DATA(lv_quantity) = REDUCE menge_d( INIT lv_value TYPE menge_d
                                                          FOR ls_bomdet_parent IN lt_bomdet
                                                          WHERE ( bomlevel    = lv_level AND
                                                                  component   = ls_bomcomp-parent AND
                                                                  hedmaterial = ls_bomcomt-material )
                                                          NEXT lv_value = lv_value + ls_bomdet_parent-childqty ).

            <fs_bomdet>-childqty   = lv_quantity * (  <fs_bomdet>-bomitemqty / ls_bomcomp-BOMHeaderQuantityInBaseUnit ). "lv_quantity * <fs_bomdet>-bomitemqty.
            <fs_bomdet>-childqty1  = lv_quantity * (  <fs_bomdet>-bomitemqty / ls_bomcomp-BOMHeaderQuantityInBaseUnit ).
          ENDIF.
        ENDIF.

      ENDLOOP.


      IF lt_bomdet IS NOT INITIAL.
        COMMIT ENTITIES BEGIN.
        MODIFY zdt_bomdet FROM TABLE @lt_bomdet .
        COMMIT ENTITIES END.
      ENDIF.

      CLEAR: lt_out_bom[],lt_bomdet[].
    ENDLOOP.

***    SELECT * FROM zr_bomproductionversion INTO TABLE @DATA(lt_hedmaterial) .
***    CHECK sy-subrc EQ 0 .
***
***    LOOP AT lt_hedmaterial INTO DATA(ls_hedmaterial) .
***
***      SELECT * FROM zr_bom_components( p_matnr = @ls_hedmaterial-material, p_werks = @ls_hedmaterial-plant )
***                INTO TABLE @DATA(lt_bomcomp).
***      IF sy-subrc EQ 0.
***
***        LOOP AT lt_bomcomp INTO DATA(ls_bomcomp).
***
***          APPEND INITIAL LINE TO lt_bomdet ASSIGNING FIELD-SYMBOL(<fs_bomdet>) .
***
***          MOVE-CORRESPONDING ls_bomcomp TO <fs_bomdet> .
***          <fs_bomdet>-hedmaterial = ls_hedmaterial-material.
***          <fs_bomdet>-parentqty = 100.
***
***          IF ls_bomcomp-bomlevel = 1 .
***            <fs_bomdet>-childqty  = 100 * <fs_bomdet>-bomitemqty.
***          ELSE.
***            lv_level = ls_bomcomp-bomlevel - 1 .
***            READ TABLE lt_bomdet INTO DATA(ls_parentqty) WITH KEY bomlevel    = lv_level
***                                                                  component   = ls_bomcomp-parent
***                                                                  hedmaterial = ls_hedmaterial-material.
***            IF sy-subrc = 0 .
***              <fs_bomdet>-childqty  = ls_parentqty-childqty * <fs_bomdet>-bomitemqty.
***            ENDIF.
***          ENDIF.
***
***        ENDLOOP.
***
***
***        IF lt_bomdet IS NOT INITIAL.
***          COMMIT ENTITIES BEGIN.
***          MODIFY zdt_bomdet FROM TABLE @lt_bomdet .
***          COMMIT ENTITIES END.
***        ENDIF.
***
***      ENDIF.
***    ENDLOOP.

***    IF lt_bomdet IS NOT INITIAL.
***      COMMIT ENTITIES BEGIN.
***      MODIFY zdt_bomdet FROM TABLE @lt_bomdet .
***      COMMIT ENTITIES END.
***    ENDIF.


  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
      CATCH cx_root INTO FINAL(job_scheduling_exception).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
