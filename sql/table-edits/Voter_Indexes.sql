drop index if exists voter_streetnumber;
create index voter_streetnumber on voter(streetnumber);
drop index if exists voter_streetname;
create index voter_streetname on voter(streetname);
