package XMLDISCLOSURE;

//------------------------------------------------------------------ imports --
import java.sql.*;

import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.ArrayList;

public class PrivacyFunctions {
// -------------------------------------------------------------------- UDFs --
  /*
   * SP: rewrite
   */
  public static void rewrite(
     String xquery,
     String purpose,
     ResultSet[] rs1
    ) throws SQLException, Exception {
    isValidXQuery(xquery);
    rs1[0] = runSQLStatement(xquery);
  }

  /*
   * SP: original
   */
  public static void unmodified(
     String xquery, 
     String purpose,
     ResultSet[] rs1
    ) throws SQLException, Exception {
    isValidXQuery(xquery);
    rs1[0] = runSQLStatement(xquery);
  }

  /*
   * SP: filter
   */
  public static void filter(
     String xquery,
     String purpose,
     ResultSet[] rs1
    ) throws SQLException, Exception {
    isValidXQuery(xquery);
    Object[] xmlCols                = targetXMLColumns(xquery);
    String [] requiredModifications = 
      getRequiredXMLUpdateModificationsFor(xmlCols[i], purpose, "cp", "i");
    String[] prologBodyPair = extractPrologAndBodyFrom(xquery);
    String filter_query = buildQueryUsing(
      xquery,
      xmlCols,
      requiredModifications,
      prologBodyPair
    )
    rs1[0] = runSQLStatement( prologBodyPair[0] + " " + prologBodyPair[1] );
  }

//---------------------------------------------------------------------- aux --
  private static void isValidXQuery(String xquery) throws SQLException {
    // Not real validation, just to check constraints.
    if (xquery == null || !xquery.toLowerCase().startsWith("xquery ")
        || xquery.contains("db2-fn:sqlquery")) {
      throw new SQLException(
          "Invalid XQuery statement: null, doesn't start with XQuery or" +
          " includes SQLQuery collection function");
    }
  }

  private static Object[] targetXMLColumns(String xquery) {
    // Dummy implementation for now
    ArrayList xmlCols = new ArrayList();
    xmlCols.add("CUSTOMER.INFO");
    return xmlCols.toArray();
  }

  private static String[] extractPrologAndBodyFrom(String xquery) {
    // remove the xquery statement
    xquery = xquery.substring(7, xquery.length());

    StringBuilder xq_prolog = new StringBuilder();
    StringBuffer xq_body    = new StringBuffer();

    xq_prolog.append("XQuery ");

    Pattern namespaceDeclaration = 
      Pattern.compile(
        "declare (default element )?namespace" + 
        " ((\\w)+((\\s)+)?(\\=)((\\s)+)?)?(.*);", 
        Pattern.CASE_INSENSITIVE
      );

      Matcher namespacesMatcher = namespaceDeclaration.matcher(xquery);

      while(namespacesMatcher.find())
      {
         namespacesMatcher.appendReplacement(xq_body, "");
         xq_prolog.append(namespacesMatcher.group());
         xq_prolog.append(" ");
      }
      namespacesMatcher.appendTail(xq_body);

      String[] prologBodyPair = new String[2];
      prologBodyPair[0] = xq_prolog.toString();
      prologBodyPair[1] = xq_body.toString();

      return prologBodyPair;
  }

  private static String[] getRequiredXMLUpdateModificationsFor(
    Object[] xmlCols,
    String purpose,
    String copyVarName,
    String iVarName
  ) {
    String[] requiredModifications = new String[xmlCols.length];
    for ( int i = 0; i < xmlCols.length; i++ ) {
      // Get the required updates
      requiredModifications[i] = 
        getRequiredXMLUpdateModificationsFor(
          (String) xmlCols[i], 
          purpose, 
          "cp",
          "i"
        );
    }
    return requiredModifications;
  }

  private static String getRequiredXMLUpdateModificationsFor(
    String xmlColumn, 
    String purpose,
    String copyVarName,
    String iVarName
   ) {
     // Dummy
     return "do replace value of $" + copyVarName +
            "/customerinfo/name with $" + iVarName +
            "/customerinfo/name/text()";
  }

  private static String buildQueryUsing(
    String xquery,
    Object[] xmlCols,
    String [] requiredModifications,
    String[] prologBodyPair
  ) {
    // Dummy of course
    // Maybe if modifications, then method else method
    StringBuilder query = new StringBuilder();
    query.append("XQuery ");
    query.append(prologBodyPair[0]);
    query.append("let $target := (");
    query.append(prologBodyPair[1]);
    query.append(") for $i in $target return transform copy $cp := $i modify(");
    query.append(" do delete $cp//text(), do delete $cp//@*, ");
    query.append(requiredModifications[0]);
    query.append(") return $cp");
    return query.toString();
  }

//----------------------------------------------------------------------- db  --
  private static ResultSet runSQLStatement(String xquery) throws SQLException {
    Connection con = DriverManager.getConnection("jdbc:default:connection");
    PreparedStatement stmt = null;
    String sql = xquery;

    stmt = con.prepareStatement(sql.toString());
    boolean bFlag = stmt.execute();
    return stmt.getResultSet();
  }
}
