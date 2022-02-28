do $$
  declare
    debug int default(0);
    rec record;
	streetnumber varchar(50);
    streetname varchar(50);
    streettype varchar(50);
    streetdirection varchar(50);
    streetbuilding varchar(50);
    unit varchar(50);
    unit_type varchar(50);
	extra varchar(150);
	item varchar(50);
	idx int;
	unitTypeIdx int;
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
		  end as items 
	from uvoter 
	--where upper(address) like '%PARK LANE%'
	--fetch first 1 rows only
    loop
	   idx = 0;
	   streetnumber = null;
       streetname = '';
       streettype = '';
       streetdirection = '';
       streetbuilding = '';
       unit = '';
       unit_type = '';
	   extra = '';
	   unitTypeIdx = 0;
       --RAISE NOTICE '% % <%>', idx, rec.person_id, rec.address;
	   foreach item in array rec.items
	      loop
		  --raise notice 'item is %', item;
		     idx = idx +1;
			 if idx = 1 then
			    streetnumber = item;
				--raise notice 'setting streetnumber %', item;
		     elsif (select 1 from streetdirections x where x.streetdirection = item) is not null then
		        streetdirection = streetdirection || ' '  || item;
				--raise notice 'setting streetdirection %', item;
			 elsif ((select 1 from streettypes x where x.streettype = item) is null or streetname = '')
				and streettype = '' then
			    streetname = streetname || ' ' || item;
				--raise notice 'setting streetname %', item;
			 elsif (select 1 from streettypes x where x.streettype = item) is not null then
		        streettype = item;
				--raise notice 'setting streettype %', item;
		     elsif (select 1 from unit_types x where x.unit_type = item) is not null 
			    and unit_type = '' then
		        unit_type = item;
				unitTypeIdx = idx;
				--raise notice 'setting unit_type % at %', item, unitTypeIdx;
		     elsif idx = (unitTypeIdx + 1) then
		        unit = item;
				--raise notice 'setting unit %', item;
		     elsif (select 1 from streetbuildings x where x.streetbuilding = item) is not null then
		        streetbuilding = item;
				--raise notice 'setting streetbuilding %', item;
			 else 
			    extra = extra || ' ' || item;
				--raise notice 'setting extra %', item;
		     end if;
           end loop;	
		   streetdirection = trim(streetdirection);
		   streetname = trim(streetname);
		   extra = trim(extra);
		   if debug = 0 then
		    insert into uvoter_splitaddress values ( 
			rec.person_id,
			nullif(streetnumber,''),
  		    nullif(streetdirection, ''),
  		  	nullif(streetname, ''),
  		  	nullif(streettype, ''),
  		  	nullif(streetbuilding, ''),
  		  	nullif(unit_type, ''),
  		  	nullif(unit, ''),
			nullif(extra, ''));
		   else
		   raise notice '*************************************';
		   raise notice 'streetnumber is    %', streetnumber;
           raise notice 'streetdirection is %', streetdirection;
           raise notice 'streetname is      %', streetname;
           raise notice 'streettype is      %', streettype;
           raise notice 'streetbuilding is  %', streetbuilding;
           raise notice 'unit_type is       %', unit_type;
           raise notice 'unit is            %', unit;
           raise notice 'extra is           %', extra;
		   end if;
	 end loop;
  end;
$$;