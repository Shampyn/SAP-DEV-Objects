@EndUserText.label: 'aplo custom table'
@ObjectModel.query.implementedBy: 'ABAP:ZYB_CL_APLO_CUST'
define custom entity ZYB_APLO_CUST
{
  key object        : zyb_aplo_obj;
  
      @UI           : { lineItem:       [ { position: 10, importance: #HIGH, label:'Subobject' }] ,
                        identification: [ { position: 10, label:'Subobject' } ] }
  key subObject     : zyb_aplo_subojb;
  
      @UI           : { lineItem:       [ { position: 20, importance: #HIGH, label:'Subobject Text' }] ,
                        identification: [ { position: 20, label:'Subobject Text' } ] }
      subObjectText : zyb_aplo_text;
}
