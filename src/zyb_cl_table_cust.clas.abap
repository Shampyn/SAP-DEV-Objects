CLASS zyb_cl_table_cust DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zyb_cl_table_cust IMPLEMENTATION.
  METHOD if_rap_query_provider~select.

    DATA: ls_tabl TYPE zyb_table_cust,
          lt_tabl TYPE TABLE OF zyb_table_cust.

    IF io_request->is_data_requested( ).

      DATA(lt_range_table) = io_request->get_filter( )->get_as_ranges(  ).


      DATA(range) = lt_range_table[ name = 'ABAPOBJECT' ]-range.

      SELECT abapobject
      FROM i_custabapobjdirectoryentry
      WHERE abapobjecttype = 'TABL'
      AND abapobjectisdeleted <>'X'
      AND abapobject IN @range
      INTO TABLE @DATA(lt_table_object).

      LOOP AT lt_table_object ASSIGNING FIELD-SYMBOL(<lfs_table_object>).
        ls_tabl-abapobject = <lfs_table_object>-abapobject.

        DATA(lo_database_table) = xco_cp_abap_repository=>object->tabl->database_table->for( CONV #( <lfs_table_object>-abapobject ) ).

        TRY.
            LOOP AT lo_database_table->fields->all->get( ) ASSIGNING FIELD-SYMBOL(<lfs_field>).

              CLEAR ls_tabl.
              ls_tabl-field = <lfs_field>->name.

              IF <lfs_field>->content(  )->get_key_indicator(  ).
                ls_tabl-keyfield = 'X'.
              ENDIF.


              DATA(lo_field_type) = <lfs_field>->content( xco_cp_abap_dictionary=>object_read_state->active_version
                )->get_type( ).

              IF lo_field_type->is_data_element( ) EQ abap_true.

                DATA(lo_data_element_data_type) = lo_field_type->get_data_element(
                  )->content(
                  )->get_data_type( ).

                ls_tabl-dataelemdescription = lo_field_type->get_data_element(
                 )->content(  )->get_short_description(  ).
                ls_tabl-dataelemname = lo_field_type->get_data_element(  )->if_xco_ar_object~name->value.

                IF lo_data_element_data_type->is_domain( ) EQ abap_true.

                  IF lo_data_element_data_type->get_domain(
                   )->exists(  ).

                    DATA(lo_domain_format) = lo_data_element_data_type->get_domain(
                     )->content( xco_cp_abap_dictionary=>object_read_state->active_version
                     )->get_format( ).

                    DATA(lo_built_in_type) = lo_domain_format->get_built_in_type( ).

                    ls_tabl-length = lo_built_in_type->length.
                    ls_tabl-type = lo_built_in_type->type.
                  ENDIF.
                ELSE.

                  DATA(lo_data) = lo_data_element_data_type->get_built_in_type(  ).

                  ls_tabl-length = lo_data->length.
                  ls_tabl-type = lo_data->type.
                ENDIF.
              ELSE.

                DATA(lo_type) = lo_field_type->get_built_in_type(  ).

                ls_tabl-length = lo_type->length.
                ls_tabl-type = lo_type->type.
              ENDIF.

              APPEND ls_tabl TO lt_tabl.
            ENDLOOP.

          CATCH cx_xco_ar_existence_exception   INTO DATA(lr_err).
          CATCH cx_sy_ref_is_initial     INTO DATA(lr_null).
        ENDTRY.

      ENDLOOP.

      DATA(lv_offset) = io_request->get_paging( )->get_offset( ).
      DATA(lv_page_size) = io_request->get_paging( )->get_page_size( ).
      DATA(lv_max_rows) = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE lv_page_size ).

      DATA(sort_elements) = io_request->get_sort_elements( ).
      DATA(lt_sort_criteria) = VALUE string_table( FOR sort_element IN sort_elements
                                                 ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true
                                                                                        THEN ` descending`
                                                                                        ELSE ` ascending` ) ) ).
      DATA(lv_sort_string)  = COND #( WHEN lt_sort_criteria IS INITIAL
                                      THEN 'ABAPObject'
                                      ELSE concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).

      DATA(lt_req_elements) = io_request->get_requested_elements( ).
      DATA(lv_req_elements)  = concat_lines_of( table = lt_req_elements sep = `, ` ).


      DATA lt_tabl_response TYPE STANDARD TABLE OF zyb_table_cust.

      SELECT (lv_req_elements) FROM @lt_tabl AS object
               ORDER BY (lv_sort_string)
               INTO CORRESPONDING FIELDS OF TABLE @lt_tabl_response
               OFFSET @lv_offset UP TO @lv_max_rows ROWS.

      io_response->set_data( lt_tabl_response ).
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).

      SELECT COUNT( * ) FROM @lt_tabl AS response
                        INTO @DATA(lv_tabl_count).

      io_response->set_total_number_of_records( lv_tabl_count ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
