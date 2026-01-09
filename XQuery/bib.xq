let $doc := doc("db/bib/bib.xml")
(:5:)
(:for $autor in $doc//book//author
return $autor/last:)
(:6:)
(:for $book in $doc//book
return <ksiazka>{$book/author}{$book/title}</ksiazka>:)
(:7:)
(:for $book in $doc//book
for $autor in $book//author
return <ksiazka>{$autor/last/text()}{$autor/first/text()}{$book/title}</ksiazka>:)
(:8:)
(:for $book in $doc//book
for $autor in $book//author
return <ksiazka>{concat($autor/last/text()," ",$autor/first/text())}{$book/title}</ksiazka>:)
(:9:)
(: return
<wynik>{
  for $book in $doc//book
  for $autor in $book//author
  return
    <ksiazka>
      <autor>{concat($autor/last/text(), " ", $autor/first/text())}</autor>
      <tytul>{$book/title/text()}</tytul>
    </ksiazka>
}</wynik> :)
(:10:)
(: return <imiona>{
 for $book in $doc//book
 for $autor in $book//author
 where $book/title = "Data on the Web"
  return
  
   <imie>{$autor/first/text()}</imie>
 }
</imiona> :)
(:11:)
(: return <DataOnTheWeb>{
 for $book in $doc//book
 
 where $book/title = "Data on the Web"
  return
  
   $book
 }
</DataOnTheWeb> :)

(: return
<DataOnTheWeb>{
  $doc//book[title = "Data on the Web"]
}</DataOnTheWeb> :)

(:12:)
(: return <Data>{
 for $book in $doc//book
 for $autor in $book//author
 where contains($book/title,'Data')
  return
  
   <nazwisko>{$autor/last/text()}</nazwisko>
 }
</Data> :)
(:13:)
(: return
<Data>{
  for $book in $doc//book
  where $book/title = "Data on the Web"
  return (
    <title>{$book/title/text()}</title>,
    for $autor in $book/author
    return <nazwisko>{$autor/last/text()}</nazwisko>
  )
}</Data> :)

(:14:)
  (: for $book in $doc//book
  where count($book/author) <=2
  return 
    <title>{$book/title/text()}</title> :)
(:15:)
 (: for $book in $doc//book
  return<ksiazka>
    <title>{$book/title/text()}</title>
    <autorow>{count($book/author)}</autorow>
    </ksiazka> :)
(:16:)

(: let $min := min($doc//book/@year)
let $max := max($doc//book/@year)
return
  <przedzial>
    {concat($min, ' - ', $max)}
  </przedzial> :)
  
(:17:)
(: let $min := min($doc//book/price)
let $max := max($doc//book/price)

return
  <różnica>
   {xs:double($max)-xs:double($min)}
  </różnica> :)
  
  (:18:)
(: let $min := xs:float(min($doc//book/price))

return
<najtańsze>{
  for $book in $doc//book
  where xs:float($book/price) = $min
  return
    <najtańsza>
      <title>{$book/title/text()}</title>
      {
        for $autor in $book/author
        return $autor
      }
    </najtańsza>
}</najtańsze> :)
 
(:19:)
  for $book in $doc//book
  for $a in $book/author
  group by $last := $a/last/text()
  return
    <autor>
      <last>{$last}</last>
      {
        for $t in distinct-values($book[author/last = $last]/title/text())
        return <title>{$t}</title>
      }
    </autor>

