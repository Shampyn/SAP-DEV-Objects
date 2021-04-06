@EndUserText.label: 'custom entity for table elements'
@ObjectModel.query.implementedBy: 'ABAP:ZYB_CL_TABLE_CUST'
define custom entity ZYB_TABLE_CUST
{
  key ABAPObject          : zyb_tabl_name;

      @UI : {
        lineItem : [ { position: 10, importance: #HIGH }],
        identification : [ { position: 10 } ]
      }
      @EndUserText.label: 'Field'
  key Field               : zyb_field_name;

      @UI : {
        lineItem : [ { position: 20, importance: #HIGH }],
        identification : [ { position: 20 } ]
      }
      @EndUserText.label: 'Type'
      Type                : zyb_type;

      @UI : { 
        lineItem: [ { position: 30, importance: #HIGH }],
        identification: [ { position: 30 } ] 
      }
      @EndUserText.label: 'Length'
      Length              : zyb_length;
      
      @UI : { 
        lineItem:       [ { position: 15 }] ,
        identification: [ { position: 15 } ] 
      }
      @EndUserText.label: 'Key field'
      KeyField            : zyb_iskey;
      
      @UI : { 
        lineItem:       [ { position: 40, importance: #HIGH }] ,
        identification: [ { position: 40 } ] 
      }
      @EndUserText.label: 'Data Element'
      DataElemName        : zyb_dtel_name;
      
      @UI : { 
        lineItem:       [ { position: 50, importance: #HIGH }] ,
        identification: [ { position: 50 } ] 
      }
      @EndUserText.label: 'Description'
      DataElemDescription : zyb_description;


}
