--Operator CONTAINS - Podstawy--

--1--
Create table  CYTATY as select * from ZTPD.CYTATY;
--2--
select autor, tekst from cytaty where lower(tekst) like '%optymista%' and lower(tekst) like '%pesymista%';
--3--
create index CYTATY_IDX on CYTATY(tekst)
indextype is CTXSYS.CONTEXT;
--4--
select autor, tekst from cytaty 
where contains(tekst, 'optymista')>0 and contains(tekst, 'pesymista')>0;
--5--
select autor, tekst from cytaty 
where contains(tekst, 'optymista')=0 and contains(tekst, 'pesymista')>0;
--6--
select autor, tekst from cytaty 
where contains(tekst, 'near((optymista,pesymista),3)')>0;
--7--
select autor, tekst from cytaty 
where contains(tekst, 'near((optymista,pesymista),10)')>0;
--8--
select autor, tekst from cytaty 
where contains(tekst, '¿yci%')>0;
--9--
select  autor,tekst, score(1) from cytaty 
where contains(tekst, '¿yci%',1)>0;
--10--
select  autor,tekst, score(1) as dopasowanie from cytaty 
where contains(tekst, '¿yci%',1)>0
order by dopasowanie desc
fetch first 1 rows only;
--11--
select  autor,tekst from cytaty 
where contains(tekst, 'fuzzy(probelm)',1)>0;
--12--
INSERT into cytaty values(39,'Bertrand Russell','To smutne, ¿e g³upcy s¹ tacy pewni
siebie, a ludzie rozs¹dni tacy pe³ni w¹tpliwoœci.');
--13--
select  autor,tekst from cytaty 
where contains(tekst, 'g³upcy',1)>0;

--14--
select *  from dr$cytaty_idx$i
where lower(token_text) = 'g³upcy';

--15--
drop index  CYTATY_IDX;

create index CYTATY_IDX on CYTATY(tekst)
indextype is CTXSYS.CONTEXT;
--16--
select  autor,tekst from cytaty 
where contains(tekst, 'g³upcy',1)>0;
--17--
drop index  CYTATY_IDX;
drop table cytaty;

--Zaawansowane indeksowanie i wyszukiwanie--
--1--
create table  QUOTES as select * from ZTPD.QUOTES;
--2--
create index QUOTES_IDX on QUOTES(text)
indextype is CTXSYS.CONTEXT;

--3--
select  author,text from quotes 
where contains(text, 'work',1)>0;

select  author,text from quotes 
where contains(text, '$work',1)>0;

select  author,text from quotes 
where contains(text, 'working',1)>0;


select  author,text from quotes 
where contains(text, '$working',1)>0;

--4--
select  author,text from quotes 
where contains(text, 'it',1)>0;

--5--
select * from CTX_STOPLISTS; 
--6--
select * from CTX_STOPWORDS; 
--7--
drop index  QUOTES_IDX;

create index QUOTES_IDX on QUOTES(text)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST');

--8--
select  author,text from quotes 
where contains(text, 'it',1)>0;
--9--
select  author,text from quotes 
where contains(text, 'fool AND humans',1)>0;
--10--
select  author,text from quotes 
where contains(text, 'fool AND computer',1)>0;
--11--
select  author,text from quotes 
where contains(text, '(fool AND computer) within sentence',1)>0;
--12--
drop index  QUOTES_IDX;

--13--
begin
 ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
 ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
 ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
end; 
--14--
create index QUOTES_IDX on QUOTES(text)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST section group nullgroup');
--15--

select  author,text from quotes 
where contains(text, '(fool AND humans) within sentence',1)>0;

select  author,text from quotes 
where contains(text, '(fool AND computer) within sentence',1)>0;

--16--
select  author,text from quotes 
where contains(text, 'humans',1)>0;
--17--
drop index  QUOTES_IDX;

BEGIN
  ctx_ddl.create_preference('lex_z_m', 'BASIC_LEXER');
  ctx_ddl.set_attribute('lex_z_m', 'printjoins', '_-');
  ctx_ddl.set_attribute('lex_z_m', 'index_text', 'YES');
END;



create index QUOTES_IDX on QUOTES(text)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST section group nullgroup LEXER lex_z_m');

--18--
select  author,text from quotes 
where contains(text, 'humans',1)>0;
--19--
select  author,text from quotes 
where contains(text, 'non\-humans',1)>0;

--20--
DROP TABLE QUOTES;

begin
CTX_DDL.DROP_SECTION_GROUP('nullgroup');
CTX_DDL.DROP_PREFERENCE('lex_z_m');
end;