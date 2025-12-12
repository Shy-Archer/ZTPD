--1--
--A--
Insert into user_sdo_geom_metadata values('Figury','Ksztalt',
MDSYS.SDO_DIM_ARRAY(
 MDSYS.SDO_DIM_ELEMENT('X', 0,10, 0.01),
 MDSYS.SDO_DIM_ELEMENT('Y', 0,8, 0.01)),
 null
);
--B--
SELECT SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000,8192,10,2,0) from figury;

--C--
create index figura_idx
on figury(ksztalt)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;
--D--
--Wynik nie odpowiada rzeczywistoœci z t¹ wspó³rzêdn¹ powi¹zany jest tylko kwadrat. Jest to spowodowane wykonaniem tylko pierwszej fazy przetwarzania.
select ID
from FIGURY
where SDO_FILTER(KSZTALT,
SDO_GEOMETRY(2001,null,
 SDO_POINT_TYPE(3,3,null),
 null,null)) = 'TRUE';
 --E--
 --Wynik odpowiada rzeczywistoœci
select ID
from FIGURY
where SDO_RELATE(KSZTALT,
 SDO_GEOMETRY(2001,null,
 SDO_POINT_TYPE(3,3,null),
 null,null),
 'mask=ANYINTERACT') = 'TRUE';

--2--
select GEOM from MAJOR_CITIES WHERE CITY_NAME = 'Warsaw';
--A--


select A.CITY_NAME miasto, ROUND(SDO_NN_DISTANCE(1)) odl
from MAJOR_CITIES A
where SDO_NN(GEOM,MDSYS.SDO_GEOMETRY(2001, 8307, NULL,
 MDSYS.SDO_ELEM_INFO_ARRAY(1, 1, 1),
MDSYS.SDO_ORDINATE_ARRAY(21.0118794, 52.2449452)),
 'sdo_num_res=10 unit=km',1) = 'TRUE'
 AND A.CITY_NAME <> 'Warsaw';
 
 --B--
 select C.CITY_NAME miasto
from MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.GEOM,
 SDO_GEOMETRY(2001,
 8307,
null,
MDSYS.SDO_ELEM_INFO_ARRAY(1, 1, 1),
MDSYS.SDO_ORDINATE_ARRAY(21.0118794, 52.2449452)),
 'distance=100 unit=km') = 'TRUE'
  AND C.CITY_NAME <> 'Warsaw';
--C--
select B.CNTRY_NAME kraj, C.CITY_NAME as  miasto
from COUNTRY_BOUNDARIES B, MAJOR_CITIES C
where SDO_RELATE(C.GEOM, B.GEOM,
 'mask=INSIDE') = 'TRUE'
and B.CNTRY_NAME = 'Slovakia';

--D--
select B.CNTRY_NAME AS PANSTWO, SDO_GEOM.SDO_DISTANCE(A.GEOM, B.GEOM, 1, 'unit=km') ODL
from COUNTRY_BOUNDARIES A, COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Poland' AND B.CNTRY_NAME <> 'Poland'
    AND NOT SDO_RELATE(A.GEOM, B.GEOM,
    'mask=TOUCH') = 'TRUE';
    
--3--
--A--
select B.CNTRY_NAME, SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM, 1), 1, 'unit=km') ODLEGLOSC
from COUNTRY_BOUNDARIES A, COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Poland' AND B.CNTRY_NAME <> 'Poland'
    AND SDO_RELATE(A.GEOM, B.GEOM,
    'mask=TOUCH') = 'TRUE';
    
--B--
select A.CNTRY_NAME
from COUNTRY_BOUNDARIES A
order by SDO_GEOM.SDO_AREA(A.GEOM, 1, 'unit=SQ_KM') DESC
FETCH FIRST 1 ROWS ONLY;
--C--

select (
    SDO_GEOM.SDO_AREA((
        SDO_GEOM.SDO_MBR(
            SDO_GEOM.SDO_UNION(C.GEOM, D.GEOM, 1)
        )
    ), 1, 'unit=SQ_KM')
) AS SQ_KM
from COUNTRY_BOUNDARIES B,
MAJOR_CITIES C,
MAJOR_CITIES D
where SDO_RELATE(C.GEOM, B.GEOM,
    'mask=INSIDE') = 'TRUE'
    AND B.CNTRY_NAME = 'Poland'
    AND C.CITY_NAME = 'Warsaw'
    AND D.CITY_NAME = 'Lodz';
--D--  
select SDO_GEOM.SDO_UNION(B.GEOM, C.GEOM, 1).SDO_GTYPE AS GTYPE
from COUNTRY_BOUNDARIES B, MAJOR_CITIES C
where B.CNTRY_NAME = 'Poland'
    AND C.CITY_NAME = 'Prague';
    
--E--

select CITY_NAME, CNTRY_NAME
from (
  select
    C.CITY_NAME,
    B.CNTRY_NAME,
    SDO_GEOM.SDO_DISTANCE(
      SDO_GEOM.SDO_CENTROID(B.GEOM, 1),
      C.GEOM,
      1,
      'UNIT=KM'
    ) AS DIST_KM
  from COUNTRY_BOUNDARIES B
  join MAJOR_CITIES C
    on SDO_RELATE(C.GEOM, B.GEOM, 'MASK=INSIDE') = 'TRUE'
  order by DIST_KM
)
FETCH FIRST 1 ROW ONLY;




--F--
select C."NAME", SUM(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(B.GEOM, C.GEOM, 1), 1, 'unit=km')) Dlugosc
from COUNTRY_BOUNDARIES B, RIVERS C
where SDO_RELATE(C.GEOM, B.GEOM,
    'mask=ANYINTERACT') = 'TRUE'
    AND B.CNTRY_NAME = 'Poland'
GROUP BY C."NAME";


