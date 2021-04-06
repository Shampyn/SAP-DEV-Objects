CLASS zyb_cl_table_cust DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
       ty_t_response TYPE STANDARD TABLE OF zyb_table_cust.

    METHODS:

      paging_response
        IMPORTING it_fetched_data            TYPE ty_t_response
                  io_paging                  TYPE REF TO if_rap_query_paging
        EXPORTING ev_total_number_of_records TYPE int8
                  et_response                TYPE ty_t_response,

      sorting_response
        IMPORTING it_sort_elements TYPE if_rap_query_request=>tt_sort_elements
        CHANGING  ct_response      TYPE ty_t_response.
ENDCLASS.

CLASS zyb_cl_table_cust IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    CONSTANTS lc_tabl TYPE string VALUE 'TABL' ##NO_TEXT.

    DATA:
      lt_list_fileds   TYPE sxco_t_dbt_fields,
      ls_fetched_data  TYPE zyb_table_cust,
      lt_fetched_data  TYPE TABLE OF zyb_table_cust,
      lt_response      TYPE ty_t_response,
      lo_built_in_type TYPE REF TO cl_xco_ad_built_in_type.

    IF io_request->is_data_requested( ).

      " Get range tables of the filter
      TRY.
          DATA(lt_filter_ranges) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_range).
          RAISE EXCEPTION TYPE lcx_rap_query_provider
            EXPORTING
              previous = lx_no_range.
      ENDTRY.

      DATA(ltr_object) = lt_filter_ranges[ name = 'ABAPOBJECT' ]-range.

      SELECT abapobject
        FROM i_custabapobjdirectoryentry
          WHERE abapobjecttype = @lc_tabl
            AND abapobjectisdeleted = @abap_false
            AND abapobject IN @ltr_object
        INTO TABLE @DATA(lt_fetched_datae_object).

      LOOP AT lt_fetched_datae_object ASSIGNING FIELD-SYMBOL(<lfs_table_object>).

        DATA(lo_tbl) = xco_cp_abap_repository=>object->tabl->for( CONV #( <lfs_table_object>-abapobject ) ).

        IF lo_tbl->is_database_table( ).
          DATA(lo_database_table) = xco_cp_abap_repository=>object->tabl->database_table->for( CONV #( <lfs_table_object>-abapobject ) ).

          lt_list_fileds = lo_database_table->fields->all->get( ).
        ENDIF.

        IF lo_tbl->is_structure( ).
          CONTINUE.
        ENDIF.

        TRY.
            LOOP AT lt_list_fileds ASSIGNING FIELD-SYMBOL(<lfs_field>).

              CLEAR: ls_fetched_data,
                     lo_built_in_type.

              ls_fetched_data-abapobject = <lfs_table_object>-abapobject.
              ls_fetched_data-field = <lfs_field>->name.

              DATA(lo_content) = <lfs_field>->content( xco_cp_abap_dictionary=>object_read_state->active_version ).

              IF lo_content->get_key_indicator(  ).
                ls_fetched_data-keyfield = 'X'.
              ENDIF.

              DATA(lo_field_type) = lo_content->get_type( ).

              IF lo_field_type->is_data_element( ) EQ abap_true.

                DATA(lo_data_element_content) = lo_field_type->get_data_element( )->content( ).
                DATA(lo_data_element_data_type) = lo_data_element_content->get_data_type( ).

                ls_fetched_data-dataelemdescription = lo_data_element_content->get_short_description(  ).
                ls_fetched_data-dataelemname = lo_field_type->get_data_element( )->if_xco_ar_object~name->value.

                IF lo_data_element_data_type->is_domain( ) = abap_true.

                  DATA(lo_domain) = lo_data_element_data_type->get_domain( ).

                  IF lo_domain->exists(  ).

                    lo_built_in_type = lo_domain->content( xco_cp_abap_dictionary=>object_read_state->active_version )->get_format( )->get_built_in_type( ).

                  ENDIF.

                ELSE.

                  lo_built_in_type = lo_data_element_data_type->get_built_in_type(  ).

                ENDIF.
              ELSE.

                lo_built_in_type = lo_field_type->get_built_in_type(  ).

              ENDIF.

              IF lo_built_in_type IS BOUND.
                ls_fetched_data-length = lo_built_in_type->length.
                ls_fetched_data-type = lo_built_in_type->type.
              ENDIF.

              APPEND ls_fetched_data TO lt_fetched_data.

            ENDLOOP.

          CATCH cx_xco_ar_existence_exception INTO DATA(lr_err).
          CATCH cx_sy_ref_is_initial INTO DATA(lr_null).
        ENDTRY.

      ENDLOOP.

      " Sorting of the Response
      sorting_response(
        EXPORTING
          it_sort_elements = io_request->get_sort_elements( )
        CHANGING
          ct_response      = lt_fetched_data
      ).

      " Paging of the Response
      paging_response(
        EXPORTING
          it_fetched_data            = lt_fetched_data
          io_paging                  = io_request->get_paging( )
        IMPORTING
          ev_total_number_of_records = DATA(lv_total_number_of_records)
          et_response                = lt_response
      ).

      " Set total count of the messages
      IF io_request->is_total_numb_of_rec_requested( ).
        io_response->set_total_number_of_records( lv_total_number_of_records ).
      ENDIF.

      " Set Response
      io_response->set_data( lt_response ).

    ENDIF.

  ENDMETHOD.

  METHOD paging_response.

    IF it_fetched_data IS INITIAL.
      ev_total_number_of_records = 0.
      RETURN.
    ENDIF.

    ev_total_number_of_records = lines( it_fetched_data ).

    DATA(lv_offset) = io_paging->get_offset( ).
    DATA(lv_size) = io_paging->get_page_size( ).

    DATA(lv_init) = lv_offset + 1.
    DATA(lv_limit) = lv_offset + lv_size.

    IF ev_total_number_of_records > lv_size.

      et_response = VALUE #( FOR j = lv_init THEN  j + 1 UNTIL j > lv_limit
                              ( CORRESPONDING #( it_fetched_data[ j ] )
                           ) ).
    ELSE.
      et_response = CORRESPONDING #( it_fetched_data ).
    ENDIF.

  ENDMETHOD.

  METHOD sorting_response.

    CHECK ct_response IS NOT INITIAL.

    IF it_sort_elements IS INITIAL.
*      SORT ct_response BY ABAPObject.
    ELSE.

      DATA(lt_sort_condition) = VALUE abap_sortorder_tab( FOR sort_element IN it_sort_elements
                                                            ( name = condense( to_upper( sort_element-element_name ) )
                                                              descending = sort_element-descending ) ).

      SORT ct_response BY (lt_sort_condition).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
