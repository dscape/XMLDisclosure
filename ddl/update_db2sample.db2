UPDATE PURCHASEORDER
SET PORDER = 
  XMLQUERY('copy $cp := $PORDER
            modify 
              do insert attribute Cid { $CUSTID } into $cp/PurchaseOrder
            return  $cp')
@

UPDATE CUSTOMER
SET INFO = 
  XMLQUERY('copy $cp := $INFO
            modify (
              do insert <sex>Female</sex> after $cp/customerinfo/name,
              do insert <dob>
                          <year>1983</year>
                          <month>5</month>
                          <day>22</day>
                        </dob> after $cp/customerinfo/name
            )
            return  $cp')
WHERE
  CID = 1000
  AND
  XMLEXISTS('$INFO/customerinfo[not(exists(sex))]')
@

UPDATE CUSTOMER
SET INFO = 
  XMLQUERY('copy $cp := $INFO
            modify (
              do insert <sex>Female</sex> after $cp/customerinfo/name,
              do insert <dob>
                          <year>1953</year>
                          <month>7</month>
                          <day>1</day>
                        </dob> after $cp/customerinfo/name
            )
            return  $cp')
WHERE
  CID = 1001
  AND
  XMLEXISTS('$INFO/customerinfo[not(exists(sex))]')
@

UPDATE CUSTOMER
SET INFO = 
  XMLQUERY('copy $cp := $INFO
            modify (
              do insert <sex>Male</sex> after $cp/customerinfo/name,
              do insert <dob>
                          <year>1975</year>
                          <month>2</month>
                          <day>15</day>
                        </dob> after $cp/customerinfo/name
            )
            return  $cp')
WHERE
  CID = 1002
  AND
  XMLEXISTS('$INFO/customerinfo[not(exists(sex))]')
@

UPDATE CUSTOMER
SET INFO = 
  XMLQUERY('copy $cp := $INFO
            modify (
              do insert <sex>Male</sex> after $cp/customerinfo/name,
              do insert <dob>
                          <year>1935</year>
                          <month>11</month>
                          <day>5</day>
                        </dob> after $cp/customerinfo/name
            )
            return  $cp')
WHERE
  CID = 1003
  AND
  XMLEXISTS('$INFO/customerinfo[not(exists(sex))]')
@

UPDATE CUSTOMER
SET INFO = 
  XMLQUERY('copy $cp := $INFO
            modify (
              do insert <sex>Male</sex> after $cp/customerinfo/name,
              do insert <dob>
                          <year>1988</year>
                          <month>5</month>
                          <day>30</day>
                        </dob> after $cp/customerinfo/name
            )
            return  $cp')
WHERE
  CID = 1004
  AND
  XMLEXISTS('$INFO/customerinfo[not(exists(sex))]')
@

UPDATE CUSTOMER
SET INFO = 
  XMLQUERY('copy $cp := $INFO
            modify (
              do insert <sex>Male</sex> after $cp/customerinfo/name,
              do insert <dob>
                          <year>1969</year>
                          <month>6</month>
                          <day>15</day>
                        </dob> after $cp/customerinfo/name
            )
            return  $cp')
WHERE
  CID = 1005
  AND
  XMLEXISTS('$INFO/customerinfo[not(exists(sex))]')
@
