CLASS lhc_zi_spclprcemlh DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_spclprcemlh RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_spclprcemlh RESULT result.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_spclprcemlh~updateheader.

ENDCLASS.

CLASS lhc_zi_spclprcemlh IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.
  READ ENTITIES OF zi_spclprcemlh IN LOCAL MODE
  ENTITY zi_spclprcemlh
  ALL FIELDS
  WITH CORRESPONDING #( keys )
  RESULT FINAL(header).

  DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

  SELECT SINGLE * FROM zdt_location WHERE loctncd = @gfs_header-Loctncd
  INTO @data(Loc_final).
  IF sy-subrc = 0.
  gfs_header-Loctnnm = loc_final-loctnnam.

  ENDIF.

  MODIFY ENTITIES OF zi_spclprcemlh IN LOCAL MODE
  ENTITY zi_spclprcemlh
  UPDATE
  FIELDS ( Loctnnm )
  WITH VALUE #( FOR key IN keys
               ( %tky = gfs_header-%tky
               Loctnnm = gfs_header-Loctnnm
               %control-Loctnnm = if_abap_behv=>mk-on
               ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_spclprcemll DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS updateitem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_spclprcemll~updateitem.

ENDCLASS.

CLASS lhc_zi_spclprcemll IMPLEMENTATION.

  METHOD updateitem.
  ENDMETHOD.

ENDCLASS.
