CLASS zyb_cl_dlet_cust DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zyb_cl_dlet_cust IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA: ls_dtel TYPE zyb_dtel_cust,
          lt_dtel TYPE TABLE OF zyb_dtel_cust.

    IF io_request->is_data_requested( ).


      DATA(lt_range_table) = io_request->get_filter( )->get_as_ranges(  ).

      DATA(range) = lt_range_table[ name = 'DATA_ELEMENT' ]-range.

      SELECT abapobject
      FROM i_custabapobjdirectoryentry
      WHERE abapobjecttype = 'DTEL'
      AND abapobjectisdeleted <>'X'
      AND abapobject IN @range
      INTO TABLE @DATA(lt_dtel_object).

      LOOP AT lt_dtel_object ASSIGNING FIELD-SYMBOL(<lsf_dtel_object>).

        ls_dtel-data_element = <lsf_dtel_object>-abapobject.
   DATA(lo_dtel) = xco_cp_abap_repository=>object->dtel->for( CONV #( <lsf_dtel_object>-abapobject ) ).
        ls_dtel-headingdescripton =  lo_dtel->content(  )->get(  )-heading_field_label-text.
        ls_dtel-longdescripton =  lo_dtel->content(  )->get(  )-long_field_label-text.
        ls_dtel-mediumdescripton =  lo_dtel->content(  )->get(  )-medium_field_label-text.
        ls_dtel-shortdescripton =  lo_dtel->content(  )->get(  )-short_field_label-text.

        DATA(lo_data_element_data_type) = lo_dtel->content(  )->get_data_type(  ).

        IF lo_data_element_data_type->is_domain( ) EQ abap_true.

          IF lo_data_element_data_type->get_domain(
           )->exists(  ).

            DATA(lo_domain_format) = lo_data_element_data_type->get_domain(
             )->content( xco_cp_abap_dictionary=>object_read_state->active_version
             )->get_format( ).

             ls_dtel-DomainName = lo_data_element_data_type->get_domain(
             )->name.

            DATA(lo_built_in_type) = lo_domain_format->get_built_in_type( ).

            ls_dtel-length = lo_built_in_type->length.
            ls_dtel-type = lo_built_in_type->type.
          ENDIF.

        ELSE.

          DATA(lo_data) = lo_data_element_data_type->get_built_in_type(  ).
          ls_dtel-length = lo_data->length.
          ls_dtel-type = lo_data->type.
        ENDIF.

        APPEND ls_dtel TO lt_dtel.

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
                                      THEN 'DATA_ELEMENT'
                                      ELSE concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).

      DATA(lt_req_elements) = io_request->get_requested_elements( ).
      DATA(lv_req_elements)  = concat_lines_of( table = lt_req_elements sep = `, ` ).


      DATA lt_dtel_response TYPE STANDARD TABLE OF zyb_dtel_cust.

      SELECT (lv_req_elements) FROM @lt_dtel AS object
"               WHERE (lv_sql_filter)
               ORDER BY (lv_sort_string)
               INTO CORRESPONDING FIELDS OF TABLE @lt_dtel_response
               OFFSET @lv_offset UP TO @lv_max_rows ROWS.

      io_response->set_data( lt_dtel_response ).


    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).

      SELECT COUNT( * ) FROM @lt_dtel AS response
                        INTO @DATA(lv_dtel_count).

      io_response->set_total_number_of_records( lv_dtel_count ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
