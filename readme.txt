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

