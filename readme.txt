Start by editing the config.sh to fit your environment
Great read me file right? Rest is for me self
So... Wait for the real thing this is still a work in progress

Remember to put xml update article do matthias na tese..

mudar o delete de atributos para replace string vazia
unica maneira de naos os perder

APENAS FULL RECORD (FICHEIRO XML COMPLETO) OPTSINS OUTS
FUTURE WORK: Ao nivel do elemento XML
--------------------------------------------------------------------------------
Case 1: All customers, no opt-ins or opt-outs
  Purpose: Marketing
  Policy: Disclose name and country. No opt-ins ot opt-out
  Q : XQuery db2-fn:xmlcolumn("CUSTOMER.INFO")
  Q': XQuery 
      for $i in db2-fn:xmlcolumn("CUSTOMER.INFO")
      return 
        copy $cp := $i
        modify(
          do delete $cp//text(),
          do delete $cp//@*,
          do insert attribute Cid { $i/customerinfo/@Cid } into $cp/customerinfo,
          for $j at $x in $cp/customerinfo/phone
          return
            do replace value of $j with $i/customerinfo/phone[$x]
      )
      return $cp


--------------------------------------------------------------------------------
XQuery db2-fn:xmlcolumn("CUSTOMER.INFO") 
@
XQuery
  for $i in db2-fn:xmlcolumn("CUSTOMER.INFO")
  return $i
@
XQuery
  for $i in db2-fn:xmlcolumn("CUSTOMER.INFO")
  return <i> {$i} </i>
@ 
XQuery
  for $i in db2-fn:xmlcolumn("CUSTOMER.INFO")
  return $i/customerinfo/name
@
XQuery
  for $i in db2-fn:xmlcolumn("CUSTOMER.INFO")
  return <name> {$i/customerinfo/name} </name>
@
XQuery
  for $i in db2-fn:xmlcolumn("CUSTOMER.INFO")
  return <e> {$i/customerinfo/name, $i/customerinfo/phone[1]} </e>
@
XQuery 
  for $i in db2-fn:xmlcolumn("CUSTOMER.INFO")
  return 
    <a> { copy $cp := $i
    modify(
      do delete $cp//text(),
      do replace value of $cp//@* with "",
      for $j at $x in $cp/customerinfo/phone
      return
        do replace value of $j with $i/customerinfo/phone[$x]
    )
    return $cp, copy $cp2 := $i
    modify(
      do delete $cp2//text(),
      do delete $cp2//@*,
      do replace value of $cp2/customerinfo/name with $i/customerinfo/name/text()
    )
    return $cp2 } </a>
@
XQuery 
  for $i in db2-fn:xmlcolumn("CUSTOMER.INFO")
  return 
    copy $cp := $i
    modify(
      do delete $cp//text(),
      do delete $cp//@*,
      do insert attribute Cid { $i/customerinfo/@Cid } into $cp/customerinfo,
      for $j at $x in $cp/customerinfo/phone
      return
        do replace value of $j with $i/customerinfo/phone[$x]
    )
    return $cp
@
XQuery 
  for $i in db2-fn:xmlcolumn("CUSTOMER.INFO")
  return 
    <a> { copy $cp := $i
    modify(
      do delete $cp//text(),
      do delete $cp//@*,
      do replace value of $cp/customerinfo/name with $i/customerinfo/name/text()
    )
    return $cp, copy $cp2 := $i
    modify(
      do delete $cp2//text(),
      do delete $cp2//@*,
      do replace value of $cp2/customerinfo/addr/@country  with $i/customerinfo/addr/@country
    )
    return $cp2 } </a>
@
###################################YOUAREHERE##
XQuery 
  for $i in db2-fn:xmlcolumn("CUSTOMER.INFO")
  return 
    copy $cp := $i
    modify(
      for 
        $j at $x in $cp/customerinfo/phone
      return
        do replace value of $j with $i/customerinfo/phone[$x]
    )
    return $cp
@

###############################################
XQuery 
  for $i in db2-fn:xmlcolumn("CUSTOMER.INFO")/customerinfo/name[2-1]
  return $i
 @
--------------------------------------------------------------------------------



XQuery 
  for $i in db2-fn:xmlcolumn("CUSTOMER.INFO")
  return 
    copy $cp := $i
    modify(
      do delete $cp//text(),
      do delete $cp//@*,
      for 
        $j at $p in $cp/customerinfo/name
      return
        do replace value of $j with $i/customerinfo/name[p]/text()
    )
    return $cp
@

XQuery db2-fn:xmlcolumn("CUSTOMER.INFO") @

db2 "call xmldisclosure.filter('xquery', 'contact')"
db2 "call xmldisclosure.filter('xquery db2-fn:xmlcolumn(''CUSTOMER.INFO'')', 'contact')"
## will this make it loose the context? smart....
db2 "call xmldisclosure.filter('xquery db2-fn:xmlcolumn(''CUSTOMER.INFO'')/customerinfo', 'contact')"
db2 "call xmldisclosure.filter('xquery db2-fn:xmlcolumn(''CUSTOMER.INFO'')/customerinfo/name', 'contact')"

--------------------------------------------------------------------------------
debug and production staging - for turning on and off performance like
cli logs
db2diag
db2 GET CLI CFG FOR SECTION COMMON
--------------------------------------------------------------------------------

o db2set DB2_JVM_STARTARGS="-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=7777"
o Debug Perspective -> Run -> Debug Configuration -> Java Application -> Remote Java Application (localhost:7777)



      IDEA
  Possible Filters
    1' rewrite query like doing in filter - we put it in a let then change
    the results according to a transformation with iteration one by one
    2' run query as is. remove all qualifying xpaths without carrying if 
       about iterations
    3' run the query, have java change the results with some lame xml lib

