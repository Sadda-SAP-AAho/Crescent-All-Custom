CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TDAT_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZAPPROVALMATRIXFORPA'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'ApprovalMatrixForPa' table = 'ZTMG_APPR_MATRIX' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_APPROVALMATRIXFORPA_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR ApprovalMatrixFoAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION ApprovalMatrixFoAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ApprovalMatrixFoAll
        RESULT result,
      EDIT FOR MODIFY
        IMPORTING
          KEYS FOR ACTION ApprovalMatrixFoAll~edit.
ENDCLASS.

CLASS LHC_ZI_APPROVALMATRIXFORPA_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
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
    IF keys[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = keys[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_ApprovalMatrixForPa = edit_flag
               %FIELD-TransportRequestID = transport_feature
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_ApprovalMatrixForPa_S IN LOCAL MODE
      ENTITY ApprovalMatrixFoAll
        UPDATE FIELDS ( TransportRequestID )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                         ) ).

    READ ENTITIES OF ZI_ApprovalMatrixForPa_S IN LOCAL MODE
      ENTITY ApprovalMatrixFoAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_APPROVALMATRIXFORPA' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
  METHOD EDIT.
    CHECK lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ).
    DATA(transport_request) = lhc_rap_tdat_cts=>get( )->get_transport_request( ).
    IF transport_request IS NOT INITIAL.
      MODIFY ENTITY IN LOCAL MODE ZI_ApprovalMatrixForPa_S
        EXECUTE SelectCustomizingTransptReq FROM VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
                                                            SingletonID = 1
                                                            %PARAM-transportrequestid = transport_request ) ).
      reported-ApprovalMatrixFoAll = VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
                                     SingletonID = 1
                                     %MSG = mbc_cp_api=>message( )->get_transport_selected( transport_request ) ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_APPROVALMATRIXFORPA_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_APPROVALMATRIXFORPA_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-ApprovalMatrixFoAll INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-TransportRequestID
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
  METHOD CLEANUP_FINALIZE ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_APPROVALMATRIXFORPA DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR ApprovalMatrixForPa~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR ApprovalMatrixForPa
        RESULT result,
      DEPRECATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION ApprovalMatrixForPa~Deprecate
        RESULT result,
      INVALIDATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION ApprovalMatrixForPa~Invalidate
        RESULT result,
      COPYAPPROVALMATRIXFORPA FOR MODIFY
        IMPORTING
          KEYS FOR ACTION ApprovalMatrixForPa~CopyApprovalMatrixForPa,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ApprovalMatrixForPa
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR ApprovalMatrixForPa
        RESULT result,
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS_APPROVALMATRIXFORPA FOR ApprovalMatrixForPa~ValidateTransportRequest.
ENDCLASS.

CLASS LHC_ZI_APPROVALMATRIXFORPA IMPLEMENTATION.
  METHOD VALIDATEDATACONSISTENCY.
    READ ENTITIES OF ZI_ApprovalMatrixForPa_S IN LOCAL MODE
      ENTITY ApprovalMatrixForPa
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ApprovalMatrixForPa).
    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( 'ZTMG_APPR_MATRIX' ).
    DATA: BEGIN OF element_check,
            element  TYPE string,
            check    TYPE REF TO if_xco_dp_check,
          END OF element_check,
          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
    LOOP AT ApprovalMatrixForPa ASSIGNING FIELD-SYMBOL(<ApprovalMatrixForPa>).
      element_checks = VALUE #(
        ( element = 'ConfigDeprecationCode' check = table->field( 'CONFIGDEPRECATIONCODE' )->get_value_check( ia_value = <ApprovalMatrixForPa>-ConfigDeprecationCode  ) )
      ).
      LOOP AT element_checks INTO element_check.
        INSERT VALUE #( %TKY        = <ApprovalMatrixForPa>-%TKY
                        %STATE_AREA = |ApprovalMatrixForPa_{ element_check-element }| ) INTO TABLE reported-ApprovalMatrixForPa.
        element_check-check->execute( ).
        CHECK element_check-check->passed = xco_cp=>boolean->false.
        INSERT VALUE #( %TKY        = <ApprovalMatrixForPa>-%TKY ) INTO TABLE failed-ApprovalMatrixForPa.
        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
          INSERT VALUE #( %TKY = <ApprovalMatrixForPa>-%TKY
                          %STATE_AREA = |ApprovalMatrixForPa_{ element_check-element }|
                          %PATH-ApprovalMatrixFoAll-SingletonID = 1
                          %PATH-ApprovalMatrixFoAll-%IS_DRAFT = <ApprovalMatrixForPa>-%IS_DRAFT
                          %msg = mbc_cp_api=>message( )->get_behv_msg_from_value_check( <msg> ) ) INTO TABLE reported-ApprovalMatrixForPa ASSIGNING FIELD-SYMBOL(<rep>).
          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
          <comp> = if_abap_behv=>mk-on.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_op_ctrl VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
  ENDMETHOD.
  METHOD DEPRECATE.
    MODIFY ENTITIES OF ZI_ApprovalMatrixForPa_S IN LOCAL MODE
      ENTITY ApprovalMatrixForPa
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'W'
                         ConfigDeprecationCode_Critlty = 2 ) ).
    READ ENTITIES OF ZI_ApprovalMatrixForPa_S IN LOCAL MODE
      ENTITY ApprovalMatrixForPa
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ApprovalMatrixForPa).
    result = VALUE #( FOR row IN ApprovalMatrixForPa
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-ApprovalMatrixForPa = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Deprecate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_deprecated( )
                                                   %PATH-ApprovalMatrixFoAll-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-ApprovalMatrixFoAll-SingletonID = 1
          ) ).
  ENDMETHOD.
  METHOD INVALIDATE.
    MODIFY ENTITIES OF ZI_ApprovalMatrixForPa_S IN LOCAL MODE
      ENTITY ApprovalMatrixForPa
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'E'
                         ConfigDeprecationCode_Critlty = 1 ) ).
    READ ENTITIES OF ZI_ApprovalMatrixForPa_S IN LOCAL MODE
      ENTITY ApprovalMatrixForPa
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ApprovalMatrixForPa).
    result = VALUE #( FOR row IN ApprovalMatrixForPa
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-ApprovalMatrixForPa = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Invalidate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_invalidated( )
                                                   %PATH-ApprovalMatrixFoAll-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-ApprovalMatrixFoAll-SingletonID = 1
          ) ).
  ENDMETHOD.
  METHOD COPYAPPROVALMATRIXFORPA.
    DATA new_ApprovalMatrixForPa TYPE TABLE FOR CREATE ZI_ApprovalMatrixForPa_S\_ApprovalMatrixForPa.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-ApprovalMatrixForPa = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZI_ApprovalMatrixForPa_S IN LOCAL MODE
      ENTITY ApprovalMatrixForPa
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(ref_ApprovalMatrixForPa)
        FAILED DATA(read_failed).

    IF ref_ApprovalMatrixForPa IS NOT INITIAL.
      ASSIGN ref_ApprovalMatrixForPa[ 1 ] TO FIELD-SYMBOL(<ref_ApprovalMatrixForPa>).
      DATA(key) = keys[ KEY draft %TKY = <ref_ApprovalMatrixForPa>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_ApprovalMatrixForPa>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_ApprovalMatrixForPa>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_ApprovalMatrixForPa> EXCEPT
          SingletonID
          ConfigDeprecationCode
          LastChangedAt
          LocalLastChangedAt
        ) ) )
      ) TO new_ApprovalMatrixForPa ASSIGNING FIELD-SYMBOL(<new_ApprovalMatrixForPa>).
      <new_ApprovalMatrixForPa>-%TARGET[ 1 ]-Companycode = key-%PARAM-Companycode.
      <new_ApprovalMatrixForPa>-%TARGET[ 1 ]-Userid = key-%PARAM-Userid.
      <new_ApprovalMatrixForPa>-%TARGET[ 1 ]-Apprlevel = key-%PARAM-Apprlevel.

      MODIFY ENTITIES OF ZI_ApprovalMatrixForPa_S IN LOCAL MODE
        ENTITY ApprovalMatrixFoAll CREATE BY \_ApprovalMatrixForPa
        FIELDS (
                 Companycode
                 Userid
                 Apprlevel
                 Final
               ) WITH new_ApprovalMatrixForPa
        MAPPED DATA(mapped_create)
        FAILED failed
        REPORTED reported.

      mapped-ApprovalMatrixForPa = mapped_create-ApprovalMatrixForPa.
    ENDIF.

    INSERT LINES OF read_failed-ApprovalMatrixForPa INTO TABLE failed-ApprovalMatrixForPa.

    IF failed-ApprovalMatrixForPa IS INITIAL.
      reported-ApprovalMatrixForPa = VALUE #( FOR created IN mapped-ApprovalMatrixForPa (
                                                 %CID = created-%CID
                                                 %ACTION-CopyApprovalMatrixForPa = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-ApprovalMatrixFoAll-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-ApprovalMatrixFoAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_APPROVALMATRIXFORPA' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-Deprecate = is_authorized.
    result-%ACTION-Invalidate = is_authorized.
    result-%ACTION-CopyApprovalMatrixForPa = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    READ ENTITIES OF ZI_ApprovalMatrixForPa_S IN LOCAL MODE
      ENTITY ApprovalMatrixForPa
      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys )
      RESULT DATA(ApprovalMatrixForPa).
    DATA keys_act LIKE keys.
    LOOP AT keys INTO DATA(key) USING KEY draft WHERE %is_draft = if_abap_behv=>mk-on.
      key-%is_draft = if_abap_behv=>mk-off.
      INSERT key INTO TABLE keys_act.
    ENDLOOP.
    READ ENTITIES OF ZI_ApprovalMatrixForPa_S IN LOCAL MODE
      ENTITY ApprovalMatrixForPa
      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys_act )
      RESULT DATA(ApprovalMatrixForPa_act).
    LOOP AT keys INTO key.
      DATA(delete) = if_abap_behv=>fc-o-disabled.
      DATA(deprecate) = if_abap_behv=>fc-o-disabled.
      DATA(invalidate) = if_abap_behv=>fc-o-disabled.
      DATA(copy) = if_abap_behv=>fc-o-disabled.
      IF key-%IS_DRAFT = if_abap_behv=>mk-on.
        copy = if_abap_behv=>fc-o-enabled.
        READ TABLE ApprovalMatrixForPa WITH KEY draft COMPONENTS %TKY = key-%TKY ASSIGNING FIELD-SYMBOL(<ApprovalMatrixForPa>).
        IF <ApprovalMatrixForPa>-ConfigDeprecationCode = ''.
          deprecate = if_abap_behv=>fc-o-enabled.
          invalidate = if_abap_behv=>fc-o-enabled.
        ELSEIF <ApprovalMatrixForPa>-ConfigDeprecationCode = 'W'.
          invalidate = if_abap_behv=>fc-o-enabled.
        ENDIF.
        IF NOT line_exists( ApprovalMatrixForPa_act[ KEY entity COMPONENTS %KEY = key-%KEY ] ).
          delete = if_abap_behv=>fc-o-enabled.
        ENDIF.
      ENDIF.
      INSERT VALUE #( %TKY = key-%TKY
                      %DELETE = delete
                      %ACTION-CopyApprovalMatrixForPa = copy
                      %ACTION-deprecate = deprecate
                      %ACTION-invalidate = invalidate ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE ZI_ApprovalMatrixForPa_S.
    IF keys_ApprovalMatrixForPa IS NOT INITIAL.
      DATA(is_draft) = keys_ApprovalMatrixForPa[ 1 ]-%IS_DRAFT.
    ELSE.
      RETURN.
    ENDIF.
    READ ENTITY IN LOCAL MODE ZI_ApprovalMatrixForPa_S
    FROM VALUE #( ( %IS_DRAFT = is_draft
                    SingletonID = 1
                    %CONTROL-TransportRequestID = if_abap_behv=>mk-on ) )
    RESULT FINAL(transport_from_singleton).
    lhc_rap_tdat_cts=>get( )->validate_all_changes(
                                transport_request     = VALUE #( transport_from_singleton[ 1 ]-TransportRequestID OPTIONAL )
                                table_validation_keys = VALUE #(
                                                          ( table = 'ZTMG_APPR_MATRIX' keys = REF #( keys_ApprovalMatrixForPa ) )
                                                               )
                                reported              = REF #( reported )
                                failed                = REF #( failed )
                                change                = REF #( change ) ).
  ENDMETHOD.
ENDCLASS.
