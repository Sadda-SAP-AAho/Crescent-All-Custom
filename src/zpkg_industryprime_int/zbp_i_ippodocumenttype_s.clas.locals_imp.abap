CLASS lhc_rap_tdat_cts DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      get
        RETURNING
          VALUE(result) TYPE REF TO if_mbc_cp_rap_tdat_cts.

ENDCLASS.

CLASS lhc_rap_tdat_cts IMPLEMENTATION.
  METHOD get.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZIPPODOCUMENTTYPE'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'IpPoDocumentType' table = 'ZDT_IP_DOC_TMG' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS lhc_zi_ippodocumenttype_s DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING
                  keys   REQUEST requested_features FOR ippodocumenttypeall
        RESULT    result,
      selectcustomizingtransptreq FOR MODIFY
        IMPORTING
                  keys   FOR ACTION ippodocumenttypeall~selectcustomizingtransptreq
        RESULT    result,
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ippodocumenttypeall
        RESULT result,
      edit FOR MODIFY
        IMPORTING
          keys FOR ACTION ippodocumenttypeall~edit.
ENDCLASS.

CLASS lhc_zi_ippodocumenttype_s IMPLEMENTATION.
  METHOD get_instance_features.
    DATA: edit_flag            TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled
         ,transport_feature    TYPE abp_behv_field_ctrl VALUE if_abap_behv=>fc-f-mandatory
         ,selecttransport_flag TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ) = abap_false.
      transport_feature = if_abap_behv=>fc-f-unrestricted.
    ENDIF.
    result = VALUE #( FOR key IN keys (
               %tky = key-%tky
               %action-edit = edit_flag
               %assoc-_ippodocumenttype = edit_flag
               %field-transportrequestid = transport_feature
               %ACTION-SelectCustomizingTransptReq = COND #( WHEN key-%IS_DRAFT = if_abap_behv=>mk-off
                                                             THEN if_abap_behv=>fc-o-disabled
                                                             ELSE selecttransport_flag )
                                                             ) ).
  ENDMETHOD.
  METHOD selectcustomizingtransptreq.
    MODIFY ENTITIES OF ZI_IpPoDocumentType_S IN LOCAL MODE
      ENTITY IpPoDocumentTypeAll
        UPDATE FIELDS ( TransportRequestID )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                         ) ).

    READ ENTITIES OF ZI_IpPoDocumentType_S IN LOCAL MODE
      ENTITY IpPoDocumentTypeAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD get_global_authorizations.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_IPPODOCUMENTTYPE' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%update      = is_authorized.
    result-%action-edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
  METHOD edit.
    CHECK lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ).
    DATA(transport_request) = lhc_rap_tdat_cts=>get( )->get_transport_request( ).
    IF transport_request IS NOT INITIAL.
      MODIFY ENTITY IN LOCAL MODE ZI_IpPoDocumentType_S
        EXECUTE SelectCustomizingTransptReq FROM VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
                                                            SingletonID = 1
                                                            %PARAM-transportrequestid = transport_request ) ).
      reported-IpPoDocumentTypeAll = VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
                                     SingletonID = 1
                                     %MSG = mbc_cp_api=>message( )->get_transport_selected( transport_request ) ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS lsc_zi_ippodocumenttype_s DEFINITION FINAL INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS:
      save_modified REDEFINITION.
ENDCLASS.

CLASS lsc_zi_ippodocumenttype_s IMPLEMENTATION.
  METHOD save_modified.
    DATA(transport_from_singleton) = VALUE #( update-ippodocumenttypeall[ 1 ]-transportrequestid OPTIONAL ).
    IF transport_from_singleton IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = transport_from_singleton
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) )->update_last_changed_date_time( view_entity_name   = 'ZI_IPPODOCUMENTTYPE'
                                                                                                        maintenance_object = 'ZIPPODOCUMENTTYPE' ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS lhc_zi_ippodocumenttype DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_features FOR GLOBAL FEATURES
        IMPORTING
        REQUEST requested_features FOR ippodocumenttype
        RESULT result,
      validatetransportrequest FOR VALIDATE ON SAVE
        IMPORTING
          keys_ippodocumenttypeall FOR ippodocumenttypeall~validatetransportrequest
          keys_ippodocumenttype    FOR ippodocumenttype~validatetransportrequest.
ENDCLASS.

CLASS lhc_zi_ippodocumenttype IMPLEMENTATION.
  METHOD get_global_features.
    DATA edit_flag TYPE abp_behv_op_ctrl VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%update = edit_flag.
    result-%delete = edit_flag.
  ENDMETHOD.
  METHOD validatetransportrequest.
    CHECK keys_IpPoDocumentType IS NOT INITIAL.
    DATA change TYPE REQUEST FOR CHANGE ZI_IpPoDocumentType_S.
    READ ENTITY IN LOCAL MODE ZI_IpPoDocumentType_S
    FIELDS ( TransportRequestID ) WITH CORRESPONDING #( keys_IpPoDocumentTypeAll )
    RESULT FINAL(transport_from_singleton).
    lhc_rap_tdat_cts=>get( )->validate_all_changes(
                                transport_request     = VALUE #( transport_from_singleton[ 1 ]-TransportRequestID OPTIONAL )
                                table_validation_keys = VALUE #(
                                                          ( table = 'ZDT_IP_DOC_TMG' keys = REF #( keys_IpPoDocumentType ) )
                                                               )
                                reported              = REF #( reported )
                                failed                = REF #( failed )
                                change                = REF #( change ) ).
  ENDMETHOD.
ENDCLASS.
