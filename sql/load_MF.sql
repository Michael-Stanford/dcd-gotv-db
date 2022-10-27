select * from bq_street_extract
where street_name = 'ARAPAHO'
  and street_type = 'RD'
  and city = 'DALLAS'
  and zip = '75248'
limit 10;

select * from bq_address_extract
where street_id = 
  (select street_id from bq_street_extract
    where street_name = 'ARAPAHO'
      and street_type = 'RD'
      and city = 'DALLAS'
      and zip = '75248'
  )
  and street_number = '5515'
limit 10;

select * from Get_GeoID('5515', null, 'ARAPAHO', 'RD', null, 'DALLAS', '75248');

select * from address_supplement
where address_geo_id = 
  (select address_geo_id from bq_address_extract
    where street_id = 
    (select street_id from bq_street_extract
      where street_name = 'ARAPAHO'
        and street_type = 'RD'
        and city = 'DALLAS'
        and zip = '75248'
     )
  and street_number = '5515'
  )
limit 10;