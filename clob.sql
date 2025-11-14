--1--
create table DOKUMENTY(
    ID number(12) primary key,
    DOKUMENT clob
)
--2--
declare
    tekst clob;
begin
    for i in 1..10000 LOOP
        tekst := tekst || 'Oto tekst. ';
        end loop;
    INSERT into DOKUMENTY values (1,tekst);
end;
--3--
select * from DOKUMENTY;

select upper(DOKUMENT) as dokument from DOKUMENTY;

select length(DOKUMENT) as rozmiar from DOKUMENTY;

select DBMS_LOB.GETLENGTH(DOKUMENT) from DOKUMENTY;

select substr(DOKUMENT,5,1000) from DOKUMENTY

select DBMS_LOB.SUBSTR(DOKUMENT,1000,5) from DOKUMENTY;
--4--
insert into DOKUMENTY values (2,empty_clob());
--5--
insert into DOKUMENTY values (3,null);

--7--
DECLARE
lobd clob;
fils BFILE := BFILENAME('TPD_DIR','dokument.txt');
doffset integer := 1;
soffset integer := 1;
langctx integer := 0;
warn integer := null;
begin
SELECT dokument INTO lobd FROM dokumenty
WHERE id=2 FOR UPDATE;
DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
DBMS_LOB.LOADCLOBFROMFILE(lobd, fils, DBMS_LOB.LOBMAXSIZE,
    doffset, soffset, 0, langctx, warn);
DBMS_LOB.FILECLOSE(fils);
COMMIT;
DBMS_OUTPUT.PUT_LINE('Status operacji: '||warn);

end;
--8--
update DOKUMENTY set DOKUMENT= to_clob(bfilename('TPD_DIR','dokument.txt')) where ID =3 ;
--9--
select * from DOKUMENTY;
--10--
select id, DBMS_LOB.GETLENGTH(DOKUMENT) from DOKUMENTY;

--11--
drop table DOKUMENTY;

--12--
create procedure clob_censor
(p1 in out clob, p2 in varchar2) is
    dots VARCHAR2(32767);
    offset Number :=1;
BEGIN

    dots := RPAD('.', LENGTH(p2), '.');
    LOOP
        offset := dbms_lob.INSTR(LOB_LOC  => p1, PATTERN  => p2, OFFSET  => 1, NTH  => 1);
        EXIT WHEN offset = 0;
        dbms_lob.write(p1, LENGTH(p2), offset, dots);
    END LOOP;
    dbms_output.put_line(p1);
END;
DECLARE
    c CLOB;
BEGIN
    c := 'dawd me me dwadw';
    clob_censor(c, 'me');

END;

--13--
CREATE TABLE BIOGRAPHIES AS SELECT * FROM ZTPD.BIOGRAPHIES;
SELECT * FROM BIOGRAPHIES;

DECLARE
    c CLOB;
BEGIN
    select bio into c from BIOGRAPHIES for update ;
    clob_censor(c, 'Cimrman');
    Commit;

END;
SELECT * FROM BIOGRAPHIES;

--14--
drop table BIOGRAPHIES;
