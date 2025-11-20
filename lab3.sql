--A--
create table FIGURY(
    ID number(1) primary key,
    KSZTALT MDSYS.SDO_GEOMETRY
);
--B--
INSERT INTO figury VALUES(1,mdsys.sdo_geometry(2003,null,null,mdsys.sdo_elem_info_array(1,1003,4),MDSYS.SDO_ORDINATE_ARRAY(5,7,7,5,5,3)));
INSERT INTO figury VALUES(2,mdsys.sdo_geometry(2003,null,null,mdsys.sdo_elem_info_array(1,1003,3),MDSYS.SDO_ORDINATE_ARRAY(1,1,5,5)));
INSERT INTO figury VALUES(3,mdsys.sdo_geometry(2002,null,null,mdsys.sdo_elem_info_array(1,4,2,1,2,1,5,2,2),MDSYS.SDO_ORDINATE_ARRAY(3,2,6,2,7,3,8,2,7,1)));
--C--
INSERT INTO figury VALUES(4,mdsys.sdo_geometry(2003,null,null,mdsys.sdo_elem_info_array(1,4,2,1,2,1,5,2,2),MDSYS.SDO_ORDINATE_ARRAY(3,2,6,2,7,3,8,2,7,1)));
--D--
select id, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt,0.1) from figury;
--E--
delete from figury where SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt,0.1)!=  'TRUE';
--F--
commit;