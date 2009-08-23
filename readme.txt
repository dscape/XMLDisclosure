XQuery 
  for $i in db2-fn:xmlcolumn("CUSTOMER.INFO")
  return 
    copy $cp := $i
    modify(
      do delete $cp//text(),
      do delete $cp//@*,
      do replace value of $cp/customerinfo/name with $i/customerinfo/name/text()
    )
    return $cp
@

XQuery db2-fn:xmlcolumn("CUSTOMER.INFO") @

db2 "call xmldisclosure.filter('xquery', 'contact')"
db2 "call xmldisclosure.filter('xquery db2-fn:xmlcolumn(''CUSTOMER.INFO'')/customerinfo', 'contact')"

      IDEA
  Possible Filters
    1' rewrite query like doing in filter - we put it in a let then change
    the results according to a transformation with iteration one by one
    2' run query as is. remove all qualifying xpaths without carrying if 
       about iterations
    3' run the query, have java change the results with some lame xml lib

