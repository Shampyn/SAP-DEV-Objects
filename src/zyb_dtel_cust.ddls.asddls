@EndUserText.label: 'data element custom'
@ObjectModel.query.implementedBy: 'ABAP:ZYB_CL_DLET_CUST'
define custom entity ZYB_DTEL_CUST
{
  key Data_element      : zyb_dtel_name;
      @UI               : { identification: [ { position: 10, label:'Heading Description' } ] }
      Headingdescripton : zyb_heading_description;
      @UI               : { identification: [ { position: 20, label:'Short Description' } ] }
      Shortdescripton   : zyb_short_description;
      @UI               : { identification: [ { position: 30, label:'Medium Description' } ] }
      Mediumdescripton  : zyb_medium_description;
      @UI               : { identification: [ { position: 40, label:'Long Description' } ] }
      Longdescripton    : zyb_long_description;
      @UI               : { identification: [ { position: 50, label:'Type' } ] }
      Type              : zyb_type;
      @UI               : { identification: [ { position: 60, label:'Length' } ] }
      Length            : zyb_length;
      @UI               : { identification: [ { position: 45, label:'Domain' } ] }
      DomainName        : zyb_doma_name;
}
