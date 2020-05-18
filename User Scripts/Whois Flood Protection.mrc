/*
/whois flood protection (for ircops)
By PuNkTuReD
http://www.sassirc.com

edit the "3" and "10"
example: 3 10
would be 3 /whois's in 10 seconds.
*/
alias max.whois return 3 10
on ^*:snotice:* did a /whois on you.: {
  $iif(!$($+(%,$2,whois),2),set $+(-u,$gettok($max.whois,2,32)) $+(%,$2,whois) 1,inc $+(%,$2,whois) 1)
  if ($($+(%,$2,whois),2) == $gettok($max.whois,1,32)) { unset $($+(%,$2,whois),1) | kill $2 [ /whois abuser - $max.whois in $max.whois.time secs ] }
} 
