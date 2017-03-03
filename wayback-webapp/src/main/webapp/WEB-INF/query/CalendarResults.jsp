<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="org.archive.wayback.WaybackConstants" %>
<%@ page import="org.archive.wayback.core.CaptureSearchResult" %>
<%@ page import="org.archive.wayback.core.CaptureSearchResults" %>
<%@ page import="org.archive.wayback.core.UIResults" %>
<%@ page import="org.archive.wayback.core.WaybackRequest" %>
<%@ page import="org.archive.wayback.partition.CaptureSearchResultPartitionMap" %>
<%@ page import="org.archive.wayback.util.partition.Partition" %>
<%@ page import="org.archive.wayback.util.partition.Partitioner" %>
<%@ page import="org.archive.wayback.util.partition.PartitionSize" %>
<%@ page import="org.archive.wayback.util.partition.size.*" %>
<%@ page import="org.archive.wayback.util.StringFormatter" %>

<jsp:include page="/WEB-INF/template/UI-header.jsp" flush="true" />
<jsp:include page="/WEB-INF/template/CookieJS.jsp" flush="true" />

<%
UIResults results = UIResults.extractCaptureQuery(request);

WaybackRequest wbRequest = results.getWbRequest();
CaptureSearchResults cResults = results.getCaptureResults();
StringFormatter fmt = wbRequest.getFormatter();
String searchString = fmt.escapeHtml(wbRequest.getRequestUrl());
List<String> closeMatches = cResults.getCloseMatches();

String staticPrefix = results.getStaticPrefix();
String queryPrefix = results.getQueryPrefix();
String replayPrefix = results.getReplayPrefix();

Date searchStartDate = wbRequest.getStartDate();
Date searchEndDate = wbRequest.getEndDate();
long firstResult = cResults.getFirstReturned();
long lastResult = cResults.getReturnedCount() + firstResult;
long resultCount = cResults.getMatchingCount();

CaptureSearchResultPartitionMap map = new CaptureSearchResultPartitionMap();
Partitioner<CaptureSearchResult> partitioner = new Partitioner<CaptureSearchResult>(map);
PartitionSize size = new YearPartitionSize();
List<Partition<CaptureSearchResult>> partitions = partitioner.getRange(size,searchStartDate,searchEndDate);

Iterator<CaptureSearchResult> it = cResults.iterator();
partitioner.populate(partitions,it);
int numPartitions = partitions.size();
%>
<!-- Main page content -->
<div id="main-container" class="container">
  <div class="row">
    <div id="content" class="col-sm-12">
      <div class="search-resource result-summary">
        <%= fmt.format(searchString) %>
      </div>

      <div class="results-stats result-summary">
        Saved <span class="result-count">1 time</span> between
        <span class="search-date"><a href="#">January 1, 1991</a></span> and
        <span class="search-date"><a href="#">September 15, 2014</a></span>
      </div>

      <table class="results">
        <!-- RESULT COLUMN HEADERS -->
        <tr class="heading-row">
<%
          for (int i = 0; i < numPartitions; i++) {
            Partition<CaptureSearchResult> partition = partitions.get(i);
%>
          <td align="center" class="mainBigBody">
            <%= fmt.format("PartitionSize.dateHeader."+size.name(),partition.getStart(), partition.getEnd()) %>
          </td>
<%
          }
%>
        </tr>
        <!-- /RESULT COLUMN HEADERS -->

        <!-- RESULT COLUMN DATA -->
        <tr class="data-row">
<%
            boolean first = false;
            String lastMD5 = null;

            for (int i = 0; i < numPartitions; i++) {
              Partition<CaptureSearchResult> partition = partitions.get(i);
              List<CaptureSearchResult> partitionResults = partition.list();
%>
          <td nowrap class="mainBody">
<%
              if (partitionResults.size() == 0) {
%>
            &nbsp;
<%
              } else {
                for (int j = 0; j < partitionResults.size(); j++) {
                  CaptureSearchResult result = partitionResults.get(j);
                  String url = result.getUrlKey();
                  String captureTimestamp = result.getCaptureTimestamp();
                  Date captureDate = result.getCaptureDate();
                  String prettyDate = fmt.format("PathQuery.classicResultLinkText", captureDate);
                  String origHost = result.getOriginalHost();
                  String MD5 = result.getDigest();
                  String redirectFlag = (0 == result.getRedirectUrl().compareTo("-"))
                    ? "" : fmt.format("PathPrefixQuery.redirectIndicator");
                  String httpResponse = result.getHttpCode();
                  String mimeType = result.getMimeType();

                  String arcFile = result.getFile();
                  String arcOffset = String.valueOf(result.getOffset());

                  String replayUrl = fmt.escapeHtml(results.resultToReplayUrl(result));

                  boolean updated = false;
                  if (lastMD5 == null) {
                    lastMD5 = MD5;
                    updated = true;
                  } else if (0 != lastMD5.compareTo(MD5)) {
                    updated = true;
                    lastMD5 = MD5;
                  }
                  String updateStar = updated ? "*" : "";
%>
            <a onclick="SetAnchorDate('<%= captureTimestamp %>');" href="<%= replayUrl %>"><%= prettyDate %></a> <%= updateStar %>
            <br></br>
<%
                }
              }
%>
          </td>
<%
            }
%>
        </tr>
        <!-- /RESULT COLUMN DATA -->
      </table>

<%
            if (closeMatches != null && !closeMatches.isEmpty()) {
              WaybackRequest tmp = wbRequest.clone();
%>
      Close Matches:<br>
<%
              for (String closeMatch : closeMatches) {
                tmp.setRequestUrl(closeMatch);
                String link = fmt.escapeHtml(tmp.getAccessPoint().getQueryPrefix() +
                  "query?" + tmp.getQueryArguments());
                closeMatch = fmt.escapeHtml(closeMatch);
%>
      <a href="<%= link %>"><%= closeMatch %></a><br>
<%
              }
            }
            // show page indicators:
            if (cResults.getNumPages() > 1) {
              int curPage = cResults.getCurPageNum();
%>
      <hr></hr>
<%
              for (int i = 1; i <= cResults.getNumPages(); i++) {
                if (i == curPage) {
%>
      <b><%= i %></b>
<%
                } else {
%>
      <a href="<%= fmt.escapeHtml(results.urlForPage(i)) %>"><%= i %></a>
<%
                }
              }
            }
%>
    </div>
  </div>
</div>

<!-- Closing tags below close tags opened in UI_header.jsp -->
      </div> <!-- #su-content end -->
    </div> <!-- #su-wrap end -->

<jsp:include page="/WEB-INF/template/UI-footer.jsp" flush="true" />
