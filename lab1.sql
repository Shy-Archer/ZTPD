--1--
create type samochod as object
(
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji date,
    cena number(10,2)
);
create table samochody of samochod;
Insert into SAMOCHODY values ('FIAT', 'BRAVA', 60000,Date '1999-11-30',25000);
Insert into SAMOCHODY values ('FORD', 'MONDEO', 80000,Date '1997-05-10',45000);
Insert into SAMOCHODY values ('MAZDA', '323', 12000,Date '2000-09-22',52000);
select * from SAMOCHODY;

desc samochod;
--2--
create table wlasciciele
(
    imie varchar2(100),
    nazwisko varchar2(100),
    auto SAMOCHOD
);


insert into wlasciciele values ('JAN', 'KOWALSKI', new SAMOCHOD('FIAT', 'SEICENTO', 30000, '0010-12-02', 19500));
insert into wlasciciele values ('ADAM', 'NOWAK', new SAMOCHOD('OPEL', 'ASTRA', 34000, '0009-06-01', 19500));

desc wlasciciele;
select * from wlasciciele;


--3--
CREATE OR REPLACE TYPE BODY samochod AS
MEMBER FUNCTION wartosc RETURN NUMBER IS
    years NUMBER;
begin
    years := FLOOR(EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji));

    return round(cena*power(0.9,years));


end;
end;
alter type samochod replace as object
(
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji date,
    cena number(10,2),
    member function wartosc return number
);
SELECT s.marka, s.cena, s.wartosc() FROM SAMOCHODY s;

--4--
ALTER TYPE samochod ADD MAP MEMBER FUNCTION odwzoruj
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        years NUMBER;
    begin
        years := FLOOR(EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji));

        return round(cena*power(0.9,years));


    end;

MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
BEGIN
    RETURN FLOOR(EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji)) + kilometry/10000;
END;
end;

select * from samochody s order by value(s);

--5--
create or replace type wlasciciel as object
(
    imie varchar2(100),
    nazwisko varchar2(100)
);

alter type samochod add attribute wlasciciel_ref ref wlasciciel cascade;

create table wlasciciele2 of wlasciciel;
insert into WLASCICIELE2 values (new wlasciciel('Jan','Kowalski'));
insert into WLASCICIELE2 values (new wlasciciel('Adam','Nowak'));
insert into WLASCICIELE2 values (new wlasciciel('Ktoś','Cosiek'));

update TPD151061.samochody s
set s.wlasciciel_ref =
    (select ref(w) from TPD151061.WLASCICIELE2 w where w.NAZWISKO = 'Kowalski');

select * from samochody;

--6--
DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
    moje_przedmioty(1) := 'MATEMATYKA';
    moje_przedmioty.EXTEND(9);
    FOR i IN 2..10 LOOP
            moje_przedmioty(i) := 'PRZEDMIOT_' || i;
        END LOOP;
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
            DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
        END LOOP;
    moje_przedmioty.TRIM(2);
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
            DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    moje_przedmioty.EXTEND();
    moje_przedmioty(9) := 9;
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    moje_przedmioty.DELETE();
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

--7--
DECLARE
TYPE t_ksiazki IS VARRAY(10) OF VARCHAR2(20);
moje_ksiazki t_ksiazki := t_ksiazki('');
BEGIN
    moje_ksiazki(1) := 'CHERUB';
    moje_ksiazki.EXTEND(4);
    FOR i IN 2..5 LOOP
            moje_ksiazki(i) := 'Tytuł' || i;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('Tytuły:');
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
            DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('Tytuły:');
    moje_ksiazki.trim(3);
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
            DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
    moje_ksiazki.DELETE();
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());

end


--8--
DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
    moi_wykladowcy.EXTEND(2);
    moi_wykladowcy(1) := 'MORZY';
    moi_wykladowcy(2) := 'WOJCIECHOWSKI';
    moi_wykladowcy.EXTEND(8);
    FOR i IN 3..10 LOOP
            moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
        END LOOP;
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
            DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END LOOP;
    moi_wykladowcy.TRIM(2);
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
            DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END LOOP;
    moi_wykladowcy.DELETE(5,7);
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
            IF moi_wykladowcy.EXISTS(i) THEN
                DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
            END IF;
        END LOOP;
    moi_wykladowcy(5) := 'ZAKRZEWICZ';
    moi_wykladowcy(6) := 'KROLIKOWSKI';
    moi_wykladowcy(7) := 'KOSZLAJDA';
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
            IF moi_wykladowcy.EXISTS(i) THEN
                DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
            END IF;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;


--9--
DECLARE
TYPE t_months IS TABLE OF VARCHAR2(20);
m_months t_months := t_months();
BEGIN
    m_months.extend(12);
    FOR i IN 1..12 LOOP
            m_months(i) := TO_CHAR(TO_DATE(i,'mm'),'MONTH');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Miesiące:');
    FOR i IN m_months.FIRST()..m_months.LAST() LOOP
            IF m_months.EXISTS(i) THEN
                DBMS_OUTPUT.PUT_LINE(m_months(i));
            END IF;
        END LOOP;
    m_months.DELETE(7,9);
    DBMS_OUTPUT.PUT_LINE('Miesiące:');
    FOR i IN m_months.FIRST()..m_months.LAST() LOOP
            IF m_months.EXISTS(i) THEN
                DBMS_OUTPUT.PUT_LINE(m_months(i));
            END IF;
        END LOOP;

end;


--10--
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
                                     nazwa VARCHAR2(50),
                                     kraj VARCHAR2(30),
                                     jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
    ('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
    ('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
                                  numer NUMBER,
                                  egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
    NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
    (semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
    (semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';


--11--

CREATE TYPE koszyk_produktow AS TABLE OF VARCHAR2(20);
CREATE TYPE zakup AS OBJECT (
                                nazwa VARCHAR2(50),
                                koszyk koszyk_produktow
                            );
CREATE TABLE zakupy OF zakup
    NESTED TABLE koszyk STORE AS tab_koszyki;

INSERT INTO zakupy VALUES(zakup('A', koszyk_produktow('woda','banan','jabłko')));
INSERT INTO zakupy VALUES(zakup('B', koszyk_produktow('papier','woda')));
INSERT INTO zakupy VALUES(zakup('C', koszyk_produktow('kopytka','ziemniaki','mleko')));

SELECT * from zakupy;
delete from zakupy where 'woda' member of koszyk;
    SELECT * from zakupy;

--12--


CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
CREATE TYPE BODY instrument AS
    MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN dzwiek;
    END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
                                                 material VARCHAR2(20),
                                                 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
                                                 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_dety AS
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN 'dmucham: '||dzwiek;
    END;
    MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN glosnosc||':'||dzwiek;
    END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
                                                       producent VARCHAR2(20),
                                                       OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN 'stukam w klawisze: '||dzwiek;
    END;
END;
/
DECLARE
    tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
    trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
    fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
    dbms_output.put_line(tamburyn.graj);
    dbms_output.put_line(trabka.graj);
    dbms_output.put_line(trabka.graj('glosno'));
    dbms_output.put_line(fortepian.graj);
END;



--13--



CREATE TYPE istota AS OBJECT (
                                 nazwa VARCHAR2(20),
                                 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR
                             ) NOT INSTANTIABLE NOT FINAL;

CREATE TYPE lew UNDER istota (
                                 liczba_nog NUMBER,
                                 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR
                             );
drop type body lew;

CREATE TYPE BODY lew AS
    OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
    BEGIN
        RETURN 'upolowana ofiara: ' || ofiara;
    END;
END;
DECLARE
    KrolLew lew := lew('LEW', 4);
BEGIN
    DBMS_OUTPUT.PUT_LINE(KrolLew.poluj('antylopa'));
END;

--14--
DECLARE
    tamburyn instrument;
    cymbalki instrument;
    trabka instrument_dety;
    saksofon instrument_dety;
BEGIN
    tamburyn := instrument('tamburyn','brzdek-brzdek');
    cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
    trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
    -- saksofon := instrument('saksofon','tra-taaaa');
    -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

--15--
CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa')
                               );
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;