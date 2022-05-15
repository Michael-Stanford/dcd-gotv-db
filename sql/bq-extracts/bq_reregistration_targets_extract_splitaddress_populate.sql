do $$
  declare
    debug int default(0);
    rec record;
	street_number varchar(50);
    street_pre_dir varchar(50);
    street_name varchar(50);
    street_type varchar(50);
    street_post_dir varchar(50);
    unit varchar(50);
    unit_type varchar(50);
	extra varchar(150);
	item varchar(50);
	idx int;
	unitTypeIdx int;
	itemIsDirection boolean;
	itemIsStreetType boolean;
	itemIsUnitType boolean;
  begin
    for rec in
	select person_id,
	      case when coalesce(position(upper(address_2) in upper(address)),0) > 0
		  then upper(address)
		  else upper(address|| ' ' ||coalesce(address_2,' ')) 
		  end as newaddress,
	      case when coalesce(position(upper(address_2) in upper(address)),0) > 0
		  then string_to_array(upper(address),' ')
		  else string_to_array(upper(address|| ' ' ||coalesce(address_2,' ')),' ')
		  end as items ,
		  upper(city) as city, zip
	from bq_reregistration_targets_extract 
	--where upper(address) like '%PO %'
	--fetch first 10 rows only
    loop
	   idx = 0;
	   street_number = null;
       street_pre_dir = '';
       street_name = '';
       street_type = '';
       street_post_dir = '';
       unit = '';
       unit_type = '';
	   extra = '';
	   unitTypeIdx = 0;
       RAISE NOTICE '>>> % <%>', rec.person_id, rec.newaddress;
	   foreach item in array rec.items
	      loop
		  
	         itemIsDirection = coalesce((select true from streetdirections x where x.streetdirection = item), false);
	         itemIsStreetType = coalesce((select true from streettypes x where x.streettype = item), false);
	         itemIsUnitType = coalesce((select true from unit_types x where x.unit_type = item), false);
		     raise notice 'item is <%> %:%:%', item, itemIsDirection, itemIsStreetType, itemIsUnitType; 
		  
		     idx = idx +1;
			 if idx = 1 then
			    if not (select item ~ '^[0-9]+$') then
				   street_number = '';
				   street_name = item;
				   raise notice 'setting street_number empty and street_name %', item;
				else
			       street_number = item;
				   raise notice 'setting street_number %', item;
				end if;
		     elsif (street_name = '' and itemIsDirection) then
		        street_pre_dir = item;
				raise notice 'setting street_pre_dir %', item;
			 elsif (street_type = '' and not itemIsDirection and not itemIsUnitType and (street_name = '' or not itemIsStreetType)) then
			    street_name = street_name || ' ' || item;
				raise notice 'setting street_name %', item;
			 elsif itemIsStreetType then
		        street_type = item;
				raise notice 'setting street_type %', item;
		     elsif itemIsDirection then
		        street_post_dir = item;
				raise notice 'setting street_post_dir %', item;
		     elsif itemIsUnitType 
			    and unit_type = '' then
				if (street_type = '') then
				   street_type = 'nt';
				end if; 
		        unit_type = item;
				unitTypeIdx = idx;
				raise notice 'setting unit_type % at %', item, unitTypeIdx;
		     elsif idx = (unitTypeIdx + 1) then
		        unit = item;
				raise notice 'setting unit %', item;
			 else 
			    extra = extra || ' ' || item;
				raise notice 'setting extra %', item;
		     end if;
           end loop;	
		   if (street_type = 'nt') then
		      street_type = '';
		   end if;	  
		   street_name = trim(street_name);
		   extra = trim(extra);
		   if debug = 0 then
		    insert into bq_reregistration_targets_extract_splitaddress 
			(person_id, street_number, street_pre_dir, street_name, street_type, street_post_dir, unit_type, unit, extra, city, zip)
			values ( 
			rec.person_id,
			nullif(street_number, ''),
  		    nullif(street_pre_dir, ''),
  		  	nullif(street_name, ''),
  		  	nullif(street_type, ''),
  		  	nullif(street_post_dir, ''),
  		  	nullif(unit_type, ''),
  		  	nullif(unit, ''),
			nullif(extra, ''),
			rec.city, rec.zip);
		   else
		   raise notice '*************************************';
		   raise notice 'street_number is   %', street_number;
           raise notice 'street_pre_dir is  %', street_pre_dir;
           raise notice 'street_name is     %', street_name;
           raise notice 'street_type is     %', street_type;
           raise notice 'street_post_dir is %', street_post_dir;
           raise notice 'unit_type is       %', unit_type;
           raise notice 'unit is            %', unit;
           raise notice 'extra is           %', extra;
		   end if;
	 end loop;

     if debug = 0 then
	    with xx as (
          select sa.person_id, a.address_geo_id
          from bq_reregistration_targets_extract_splitaddress sa
          left join bq_street_extract s 
          on coalesce(s.street_name, '') = coalesce(sa.street_name, '') and 
             coalesce(s.street_pre_dir, '') = coalesce(sa.street_pre_dir, '') and
             coalesce(s.street_type, '') = coalesce(sa.street_type, '') and 
             coalesce(s.street_post_dir, '') = coalesce(sa.street_post_dir, '') and
             coalesce(s.city, '') = coalesce(sa.city, '') and
             coalesce(s.zip, '') = coalesce(sa.zip, '') 
          left join bq_address_extract a
          on a.street_id = s.street_id and a.street_number = sa.street_number
          )
          update bq_reregistration_targets_extract_splitaddress
          set address_geo_id = xx.address_geo_id
          from xx
          where xx.person_id = bq_reregistration_targets_extract_splitaddress.person_id
          ;
      end if;	  
  end;
$$;

-- select rr.address,rr.address_2,sa.* from bq_reregistration_targets_extract_splitaddress sa join bq_reregistration_targets_extract rr on rr.person_id = sa.person_id;
