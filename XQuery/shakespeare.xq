(:20:)
let $collection := collection("db/shakespeare")
(: return <wynik>{
for $plays in $collection//PLAY
return $plays/TITLE
}</wynik> :)

(:21:)
(: return $collection//PLAY[contains(string-join(.//LINE, ' '), "or not to be")]/TITLE :)
(:22:)
for $plays in $collection//PLAY
return<wynik>{
  <sztuka tytul="{$plays/TITLE/text()}">
          <postaci>{count($plays//PERSONA)}</postaci>
        <aktow>{count($plays//ACT)}</aktow>
        <scen>{count($plays//SCENE)}</scen>
  </sztuka>
  
}
</wynik>


