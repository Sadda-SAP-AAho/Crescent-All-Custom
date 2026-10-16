CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TDAT_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZTABLEFORSHIPMENTMOD'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'TableForShipmentMod' table = 'ZDT_SHIP_MODE' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_TABLEFORSHIPMENTMOD_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TableForShipmentAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TableForShipmentAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TableForShipmentAll
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_TABLEFORSHIPMENTMOD_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF ZI_TableForShipmentMod_S IN LOCAL MODE
    ENTITY TableForShipmentAll
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_TableForShipmentMod = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_TableForShipmentMod_S IN LOCAL MODE
      ENTITY TableForShipmentAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF ZI_TableForShipmentMod_S IN LOCAL MODE
      ENTITY TableForShipmentAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_TABLEFORSHIPMENTMOD' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_TABLEFORSHIPMENTMOD_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_TABLEFORSHIPMENTMOD_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-TableForShipmentAll INDEX 1 INTO DATA(all).
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
CLASS LHC_ZI_TABLEFORSHIPMENTMOD DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TableForShipmentMod~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR TableForShipmentMod
        RESULT result,
      DEPRECATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TableForShipmentMod~Deprecate
        RESULT result,
      INVALIDATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TableForShipmentMod~Invalidate
        RESULT result,
      COPYTABLEFORSHIPMENTMOD FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TableForShipmentMod~CopyTableForShipmentMod,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TableForShipmentMod
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TableForShipmentMod
        RESULT result,
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS_TABLEFORSHIPMENTMOD FOR TableForShipmentMod~ValidateTransportRequest.
ENDCLASS.

CLASS LHC_ZI_TABLEFORSHIPMENTMOD IMPLEMENTATION.
  METHOD VALIDATEDATACONSISTENCY.
    READ ENTITIES OF ZI_TableForShipmentMod_S IN LOCAL MODE
      ENTITY TableForShipmentMod
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(TableForShipmentMod).
    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( 'ZDT_SHIP_MODE' ).
    DATA: BEGIN OF element_check,
            element  TYPE string,
            check    TYPE REF TO if_xco_dp_check,
          END OF element_check,
          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
    LOOP AT TableForShipmentMod ASSIGNING FIELD-SYMBOL(<TableForShipmentMod>).
      element_checks = VALUE #(
        ( element = 'ConfigDeprecationCode' check = table->field( 'CONFIGDEPRECATIONCODE' )->get_value_check( ia_value = <TableForShipmentMod>-ConfigDeprecationCode  ) )
      ).
      LOOP AT element_checks INTO element_check.
        INSERT VALUE #( %TKY        = <TableForShipmentMod>-%TKY
                        %STATE_AREA = |TableForShipmentMod_{ element_check-element }| ) INTO TABLE reported-TableForShipmentMod.
        element_check-check->execute( ).
        CHECK element_check-check->passed = xco_cp=>boolean->false.
        INSERT VALUE #( %TKY        = <TableForShipmentMod>-%TKY ) INTO TABLE failed-TableForShipmentMod.
        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
          INSERT VALUE #( %TKY = <TableForShipmentMod>-%TKY
                          %STATE_AREA = |TableForShipmentMod_{ element_check-element }|
                          %PATH-TableForShipmentAll-SingletonID = 1
                          %PATH-TableForShipmentAll-%IS_DRAFT = <TableForShipmentMod>-%IS_DRAFT
                          %msg = mbc_cp_api=>message( )->get_behv_msg_from_value_check( <msg> ) ) INTO TABLE reported-TableForShipmentMod ASSIGNING FIELD-SYMBOL(<rep>).
          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
          <comp> = if_abap_behv=>mk-on.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
  ENDMETHOD.
  METHOD DEPRECATE.
    MODIFY ENTITIES OF ZI_TableForShipmentMod_S IN LOCAL MODE
      ENTITY TableForShipmentMod
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'W'
                         ConfigDeprecationCode_Critlty = 2 ) ).
    READ ENTITIES OF ZI_TableForShipmentMod_S IN LOCAL MODE
      ENTITY TableForShipmentMod
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(TableForShipmentMod).
    result = VALUE #( FOR row IN TableForShipmentMod
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-TableForShipmentMod = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Deprecate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_deprecated( )
                                                   %PATH-TableForShipmentAll-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-TableForShipmentAll-SingletonID = 1
          ) ).
  ENDMETHOD.
  METHOD INVALIDATE.
    MODIFY ENTITIES OF ZI_TableForShipmentMod_S IN LOCAL MODE
      ENTITY TableForShipmentMod
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'E'
                         ConfigDeprecationCode_Critlty = 1 ) ).
    READ ENTITIES OF ZI_TableForShipmentMod_S IN LOCAL MODE
      ENTITY TableForShipmentMod
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(TableForShipmentMod).
    result = VALUE #( FOR row IN TableForShipmentMod
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-TableForShipmentMod = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Invalidate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_invalidated( )
                                                   %PATH-TableForShipmentAll-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-TableForShipmentAll-SingletonID = 1
          ) ).
  ENDMETHOD.
  METHOD COPYTABLEFORSHIPMENTMOD.
    DATA new_TableForShipmentMod TYPE TABLE FOR CREATE ZI_TableForShipmentMod_S\_TableForShipmentMod.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-TableForShipmentMod = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZI_TableForShipmentMod_S IN LOCAL MODE
      ENTITY TableForShipmentMod
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(ref_TableForShipmentMod)
        FAILED DATA(read_failed).

    IF ref_TableForShipmentMod IS NOT INITIAL.
      ASSIGN ref_TableForShipmentMod[ 1 ] TO FIELD-SYMBOL(<ref_TableForShipmentMod>).
      DATA(key) = keys[ KEY draft %TKY = <ref_TableForShipmentMod>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_TableForShipmentMod>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_TableForShipmentMod>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_TableForShipmentMod> EXCEPT
          SingletonID
          ConfigDeprecationCode
          LastChangedAt
          LocalLastChangedAt
        ) ) )
      ) TO new_TableForShipmentMod ASSIGNING FIELD-SYMBOL(<new_TableForShipmentMod>).
      <new_TableForShipmentMod>-%TARGET[ 1 ]-ShipMode = key-%PARAM-ShipMode.

      MODIFY ENTITIES OF ZI_TableForShipmentMod_S IN LOCAL MODE
        ENTITY TableForShipmentAll CREATE BY \_TableForShipmentMod
        FIELDS (
                 ShipMode
                 ShipDesc
               ) WITH new_TableForShipmentMod
        MAPPED DATA(mapped_create)
        FAILED failed
        REPORTED reported.

      mapped-TableForShipmentMod = mapped_create-TableForShipmentMod.
    ENDIF.

    INSERT LINES OF read_failed-TableForShipmentMod INTO TABLE failed-TableForShipmentMod.

    IF failed-TableForShipmentMod IS INITIAL.
      reported-TableForShipmentMod = VALUE #( FOR created IN mapped-TableForShipmentMod (
                                                 %CID = created-%CID
                                                 %ACTION-CopyTableForShipmentMod = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-TableForShipmentAll-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-TableForShipmentAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_TABLEFORSHIPMENTMOD' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-Deprecate = is_authorized.
    result-%ACTION-Invalidate = is_authorized.
    result-%ACTION-CopyTableForShipmentMod = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    READ ENTITIES OF ZI_TableForShipmentMod_S IN LOCAL MODE
      ENTITY TableForShipmentMod
      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys )
      RESULT DATA(TableForShipmentMod).
    DATA keys_act LIKE keys.
    LOOP AT keys INTO DATA(key) USING KEY draft WHERE %is_draft = if_abap_behv=>mk-on.
      key-%is_draft = if_abap_behv=>mk-off.
      INSERT key INTO TABLE keys_act.
    ENDLOOP.
    READ ENTITIES OF ZI_TableForShipmentMod_S IN LOCAL MODE
      ENTITY TableForShipmentMod
      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys_act )
      RESULT DATA(TableForShipmentMod_act).
    LOOP AT keys INTO key.
      DATA(delete) = if_abap_behv=>fc-o-disabled.
      DATA(deprecate) = if_abap_behv=>fc-o-disabled.
      DATA(invalidate) = if_abap_behv=>fc-o-disabled.
      DATA(copy) = if_abap_behv=>fc-o-disabled.
      IF key-%IS_DRAFT = if_abap_behv=>mk-on.
        copy = if_abap_behv=>fc-o-enabled.
        READ TABLE TableForShipmentMod WITH KEY draft COMPONENTS %TKY = key-%TKY ASSIGNING FIELD-SYMBOL(<TableForShipmentMod>).
        IF <TableForShipmentMod>-ConfigDeprecationCode = ''.
          deprecate = if_abap_behv=>fc-o-enabled.
          invalidate = if_abap_behv=>fc-o-enabled.
        ELSEIF <TableForShipmentMod>-ConfigDeprecationCode = 'W'.
          invalidate = if_abap_behv=>fc-o-enabled.
        ENDIF.
        IF NOT line_exists( TableForShipmentMod_act[ KEY entity COMPONENTS %KEY = key-%KEY ] ).
          delete = if_abap_behv=>fc-o-enabled.
        ENDIF.
      ENDIF.
      INSERT VALUE #( %TKY = key-%TKY
                      %DELETE = delete
                      %ACTION-CopyTableForShipmentMod = copy
                      %ACTION-deprecate = deprecate
                      %ACTION-invalidate = invalidate ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE ZI_TableForShipmentMod_S.
    IF keys_TableForShipmentMod IS NOT INITIAL.
      DATA(is_draft) = keys_TableForShipmentMod[ 1 ]-%IS_DRAFT.
    ELSE.
      RETURN.
    ENDIF.
    READ ENTITY IN LOCAL MODE ZI_TableForShipmentMod_S
    FROM VALUE #( ( %IS_DRAFT = is_draft
                    SingletonID = 1
                    %CONTROL-TransportRequestID = if_abap_behv=>mk-on ) )
    RESULT FINAL(transport_from_singleton).
    IF lines( transport_from_singleton ) = 1.
      DATA(transport_request) = transport_from_singleton[ 1 ]-TransportRequestID.
    ENDIF.
    lhc_rap_tdat_cts=>get( )->validate_all_changes(
                                transport_request     = transport_request
                                table_validation_keys = VALUE #(
                                                          ( table = 'ZDT_SHIP_MODE' keys = REF #( keys_TableForShipmentMod ) )
                                                               )
                                reported              = REF #( reported )
                                failed                = REF #( failed )
                                change                = REF #( change ) ).
  ENDMETHOD.
ENDCLASS.
