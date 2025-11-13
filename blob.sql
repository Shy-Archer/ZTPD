--1--
Create table movies as select * from ZTPD.movies;
--2--
desc movies;
select *
from movies;
--3--
select id, title from movies where cover is null;
--4--
select id, TITLE, DBMS_LOB.GETLENGTH(cover) as filesize from movies where cover is not null;
--5--
select id, TITLE, DBMS_LOB.GETLENGTH(cover) as filesize from movies where cover is  null;
--6--
select DIRECTORY_name, directory_path from ALL_DIRECTORIES where DIRECTORY_NAME = 'TPD_DIR';

--7--
update movies set COVER = empty_blob(), MIME_TYPE = 'image/jpeg' where ID = 66;
--8--
select id, TITLE, DBMS_LOB.GETLENGTH(cover) as filesize from  movies where  id in (65,66);
--9--
declare
    bfil bfile := BFILENAME('TPD_DIR','escape.jpg');
    bl blob;
BEGIN
    Select cover into bl from movies where id=66 for update;
    DBMS_LOB.fileopen(bfil, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(bl,bfil,DBMS_LOB.GETLENGTH(bfil));
    DBMS_LOB.FILECLOSE(bfil);
    Commit;

end;
--10--
create table TEMP_COVERS
(
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);
--11--
Insert into TEMP_COVERS values(65,BFILENAME('TPD_DIR','eagles.jpg'),'image/jpeg');
--12--
select movie_id, DBMS_LOB.GETLENGTH(image) as filesize from TEMP_COVERS;
--13--
declare
bfil bfile;
bl blob;
mime varchar2(50);
begin
    select MIME_TYPE, image into mime, bfil from TEMP_COVERS;
    DBMS_LOB.CREATETEMPORARY(bl,true);
    DBMS_LOB.fileopen(bfil);
    DBMS_LOB.LOADFROMFILE(bl,bfil,DBMS_LOB.GETLENGTH(bfil));
    DBMS_LOB.FILECLOSE(bfil);
    update movies set COVER = bl, MIME_TYPE= mime where ID = 65;
    DBMS_LOB.FREETEMPORARY(bl);
    commit;

end;

select id, DBMS_LOB.GETLENGTH(cover) as filesize from movies where id in (65,66);

drop table movies;
drop table TEMP_COVERS;
