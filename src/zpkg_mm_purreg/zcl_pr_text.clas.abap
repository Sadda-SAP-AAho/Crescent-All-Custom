CLASS zcl_pr_text DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PR_TEXT IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.

    TYPES : BEGIN OF ty_log,
              purchaserequisition     TYPE i_supplier-supplierfullname,
              purchaserequisitionitem TYPE i_supplier-supplierfullname,
              textobjectcategory      TYPE i_supplier-supplierfullname,
              textobjecttype          TYPE i_supplier-supplierfullname,
              language                TYPE i_supplier-supplierfullname,
              plainlongtext           TYPE i_supplier-supplierfullname,
            END OF ty_log.
    DATA : log TYPE TABLE OF ty_log.

    DATA: product TYPE matnr.
    DATA it_inventory_data TYPE STANDARD TABLE OF zc_purchase_reg WITH DEFAULT KEY.
    it_inventory_data  = CORRESPONDING #( it_original_data ).

    CONSTANTS: c_i TYPE char10 VALUE ''''.

    LOOP AT it_inventory_data ASSIGNING FIELD-SYMBOL(<fs_inventory>).
      IF <fs_inventory> IS ASSIGNED.
        IF <fs_inventory>-purchaserequisition IS NOT INITIAL.
          "Get Item Text
          DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).

          lo_factory->query_ca(
            EXPORTING
              is_query = VALUE #( cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZCS_SAP_COM_0102' ) ) ) " Custom Communication Scenario
            IMPORTING
              et_com_arrangement = DATA(lt_comm_arrang) ).

          DATA(lo_comm_arrang) = lt_comm_arrang[ 1 ].

          TRY.
              DATA(lo_destination1) = cl_http_destination_provider=>create_by_comm_arrangement(
                comm_scenario  = CONV #( 'ZCS_SAP_COM_0102' )" Use Custom Communicaiton Scenario, Not standard!
                comm_system_id = lo_comm_arrang->get_comm_system_id( )
                service_id     = CONV #( 'ZOS_PURREQ_REST' )" Outbound Service ID
              ).
            CATCH cx_http_dest_provider_error INTO DATA(lo_error).
              DATA(lv_message) = lo_error->get_longtext( ).
          ENDTRY.

          TRY.
              DATA(eo_client1) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination1 ).
            CATCH cx_web_http_client_error.
          ENDTRY.

          DATA(eo_request1) = eo_client1->get_http_request( ).
          eo_request1->set_content_type( content_type = |application/json| ).

          "DATA(lv_path) = |/PurchaseReqnItem/{ ls_prdata-doc_num }/{ ls_prdata-doc_num_item }/_PurchaseReqnItemText|.
          DATA(lv_path) = |/PurchaseReqnItemText?$filter=PurchaseRequisition eq '{ <fs_inventory>-purchaserequisition }'|.
          eo_request1->set_uri_path( i_uri_path = lv_path ).

          TRY.
              DATA(lo_response) = eo_client1->execute( i_method = if_web_http_client=>get ).
            CATCH cx_web_http_client_error.
          ENDTRY.

          DATA(lv_resp_satus) = lo_response->get_status( ).
          DATA(lv_resp_text) = lo_response->get_text( ).

          SPLIT lv_resp_text AT '"value":' INTO DATA(l_a) DATA(l_b).
          DATA(l_len) = strlen(  l_b ).
          l_len = l_len - 1.
          DATA(l_final) = l_b+0(l_len).
          /ui2/cl_json=>deserialize( EXPORTING json = l_final CHANGING data = log  ).

          DATA(lv_pritem) = |{ <fs_inventory>-purchaserequisitionitem ALPHA = OUT }|.
          READ TABLE log INTO DATA(ls_log) WITH KEY purchaserequisitionitem = lv_pritem "ls_prdata-doc_num_item
                                                    textobjectcategory = 'EBAN' textobjecttype = 'B01' language = 'EN'.
          IF ls_log IS NOT INITIAL.
            <fs_inventory>-prtext = ls_log-plainlongtext.
          ELSE.
            SELECT SINGLE yy1_materiallongtext_pri
                        FROM i_purchaserequisitionitemapi01
                        WHERE purchaserequisition     = @<fs_inventory>-purchaserequisition
                          AND purchaserequisitionitem = @lv_pritem
                        INTO @<fs_inventory>-prtext.
          ENDIF.

          CLEAR : ls_log, lv_pritem.

        ENDIF.

*        IF <fs_inventory>-purchaseorder IS NOT INITIAL.
*          DATA(lo_factory2) = cl_com_arrangement_factory=>create_instance( ).
*
*          lo_factory2->query_ca(
*            EXPORTING
*              is_query = VALUE #( cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZCS_SAP_COM_0053' ) ) ) " Custom Communication Scenario
*            IMPORTING
*              et_com_arrangement = DATA(lt_comm_arrang2) ).
*
*          DATA(lo_comm_arrang2) = lt_comm_arrang2[ 1 ].
*
*          TRY.
*              DATA(lo_destination2) = cl_http_destination_provider=>create_by_comm_arrangement(
*                comm_scenario  = CONV #( 'ZCS_SAP_COM_0053' )" Use Custom Communicaiton Scenario, Not standard!
*                comm_system_id = lo_comm_arrang2->get_comm_system_id( )
*                service_id     = CONV #( 'ZOS_PURORD_REST' )" Outbound Service ID
*              ).
*            CATCH cx_http_dest_provider_error INTO DATA(lo_error2).
*              DATA(lv_message2) = lo_error2->get_longtext( ).
*          ENDTRY.
*
*          TRY.
*              DATA(eo_client2) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination2 ).
*            CATCH cx_web_http_client_error.
*          ENDTRY.
*
*          DATA(eo_request2) = eo_client2->get_http_request( ).
*          eo_request2->set_content_type( content_type = |application/json| ).
*
*         " DATA(lv_path2) = |/PurchaseReqnItemText?$filter=PurchaseRequisition eq '{ <fs_inventory>-purchaserequisition }'|.
*          DATA(lv_path2) = |/A_PurchaseOrderItemNote(PurchaseOrder='{ <fs_inventory>-PurchaseOrder }',PurchaseOrderItem='{ <fs_inventory>-PurchaseOrderItem }',TextObjectType='F03',Language='E')|.
*          eo_request2->set_uri_path( i_uri_path = lv_path2 ).
*
*          TRY.
*              DATA(lo_response2) = eo_client2->execute( i_method = if_web_http_client=>get ).
*            CATCH cx_web_http_client_error.
*          ENDTRY.
*
*          DATA(lv_resp_satus2) = lo_response2->get_status( ).
*          DATA(lv_resp_text2) = lo_response2->get_text( ).
*
*        ENDIF.
      ENDIF.
    ENDLOOP.
    " SORT it_inventory_data BY matn.
    ct_calculated_data = CORRESPONDING #( it_inventory_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
