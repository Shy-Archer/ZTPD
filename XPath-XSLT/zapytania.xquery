(:27:)
(:for $k in doc('file:///D:/studnia/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ
return <KRAJ>
 {$k/NAZWA, $k/STOLICA}
</KRAJ>:)


(:28:)
(:for $k in doc('file:///D:/studnia/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ
where starts-with($k/NAZWA,"A")
return <KRAJ>
 {$k/NAZWA, $k/STOLICA}
</KRAJ>:)

(:29:)
(:for $k in doc('file:///D:/studnia/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ
where starts-with(substring($k/NAZWA,1,1),substring($k/STOLICA,1,1))
return <KRAJ>
 {$k/NAZWA, $k/STOLICA}
</KRAJ>:)

(:30:)
(:for $k in doc('file:///D:/studnia/XPath-XSLT/swiat.xml')//KRAJ
where starts-with(substring($k/NAZWA,1,1),substring($k/STOLICA,1,1))
return <KRAJ>
 {$k/NAZWA, $k/STOLICA}
</KRAJ>:)

(:31:)
(:doc('file:///D:/studnia/XPath-XSLT/zesp_prac.xml'):)

(:32:)
(:for $k in doc('file:///D:/studnia/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW/PRACOWNICY/ROW
return
$k/NAZWISKO:)
(:33:)
(:for $k in doc('file:///D:/studnia/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW[NAZWA = 'SYSTEMY EKSPERCKIE']/PRACOWNICY/ROW
return
$k/NAZWISKO:)
(:34:)
(:for $k in count(doc('file:///D:/studnia/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW[ID_ZESP = 10]/PRACOWNICY/ROW)
return
$k:)

(:35:)
(:
for $k in doc('file:///D:/studnia/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW/PRACOWNICY/ROW[ID_SZEFA = 100]
return
$k/NAZWISKO:)
(:36:)

let $k := doc('file:///D:/studnia/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW/PRACOWNICY/ROW[ID_ZESP = /ZESPOLY/ROW/PRACOWNICY/ROW[NAZWISKO = 'BRZEZINSKI']/ID_ZESP]
return
sum($k/PLACA_POD)