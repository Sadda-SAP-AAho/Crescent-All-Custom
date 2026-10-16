CLASS lhc_zi_powerrdngl DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS updateitem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZI_POWERRDNGL~updateitem.

ENDCLASS.

CLASS lhc_zi_powerrdngl IMPLEMENTATION.

  METHOD updateitem.
  READ ENTITIES OF zi_powerrdngh IN LOCAL MODE
  ENTITY zi_powerrdngh
  ALL FIELDS
  WITH CORRESPONDING #( keys )
  RESULT FINAL(header).

  DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

  READ ENTITY zi_powerrdngh
  BY \_Item
  ALL FIELDS
  WITH CORRESPONDING #( keys )
  RESULT DATA(Item).

  DATA(gfs_Item) = VALUE #( Item[ 1 ] OPTIONAL ).

  SELECT SINGLE * FROM zdt_powerhead WHERE subheadcd = @gfs_Item-Subhdcd
  INTO @data(Loc_Item).
  IF sy-subrc = 0.

  gfs_Item-subhdnm = loc_Item-subheadnm.
  gfs_Item-headcd = loc_Item-headcd.
  gfs_Item-headnm = loc_Item-headnm.
  gfs_Item-metertyp = loc_Item-metertyp.

  ENDIF.

  MODIFY ENTITIES OF zi_powerrdngh IN LOCAL MODE
  ENTITY zi_powerrdngl
  UPDATE
  FIELDS ( Subhdnm Headcd Headnm Metertyp )
  WITH VALUE #( FOR key IN keys
               ( %tky = gfs_Item-%tky

               Subhdnm = gfs_Item-Subhdnm
               Headcd = gfs_Item-Headcd
               Headnm = gfs_Item-Headnm
               Metertyp = gfs_Item-Metertyp

               %control-Subhdnm = if_abap_behv=>mk-on
               %control-Headcd = if_abap_behv=>mk-on
               %control-Headnm = if_abap_behv=>mk-on
               %control-Metertyp = if_abap_behv=>mk-on
               ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_powerrdngh DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_powerrdngh RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_powerrdngh RESULT result.
    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_powerrdngh~updateheader.

ENDCLASS.

CLASS lhc_zi_powerrdngh IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.
  READ ENTITIES OF zi_powerrdngh IN LOCAL MODE
  ENTITY zi_powerrdngh
  ALL FIELDS
  WITH CORRESPONDING #( keys )
  RESULT FINAL(header).

  DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

  SELECT SINGLE * FROM zdt_location WHERE loctncd = @gfs_header-Readloccd
  INTO @data(Loc_final).
  IF sy-subrc = 0.
  gfs_header-Readlocnm = loc_final-loctnnam.

  ENDIF.

  MODIFY ENTITIES OF zi_powerrdngh IN LOCAL MODE
  ENTITY zi_powerrdngh
  UPDATE
  FIELDS ( Readlocnm )
  WITH VALUE #( FOR key IN keys
               ( %tky = gfs_header-%tky
               Readlocnm = gfs_header-Readlocnm
               %control-Readlocnm = if_abap_behv=>mk-on
               ) ).

  ENDMETHOD.

ENDCLASS.
