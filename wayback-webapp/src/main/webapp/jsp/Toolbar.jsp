<%@   page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8"
%><%@ page import="java.util.Iterator"
%><%@ page import="java.util.ArrayList"
%><%@ page import="java.util.Date"
%><%@ page import="java.util.Calendar"
%><%@ page import="java.util.List"
%><%@ page import="java.text.ParseException"
%><%@ page import="org.archive.wayback.ResultURIConverter"
%><%@ page import="org.archive.wayback.WaybackConstants"
%><%@ page import="org.archive.wayback.core.CaptureSearchResult"
%><%@ page import="org.archive.wayback.core.CaptureSearchResults"
%><%@ page import="org.archive.wayback.core.UIResults"
%><%@ page import="org.archive.wayback.core.WaybackRequest"
%><%@ page import="org.archive.wayback.partition.CaptureSearchResultPartitionMap"
%><%@ page import="org.archive.wayback.partition.PartitionPartitionMap"
%><%@ page import="org.archive.wayback.partition.PartitionsToGraph"
%><%@ page import="org.archive.wayback.partition.InteractiveToolBarData"
%><%@ page import="org.archive.wayback.util.graph.Graph"
%><%@ page import="org.archive.wayback.util.graph.GraphEncoder"
%><%@ page import="org.archive.wayback.util.graph.GraphRenderer"
%><%@ page import="org.archive.wayback.util.partition.Partition"
%><%@ page import="org.archive.wayback.util.partition.Partitioner"
%><%@ page import="org.archive.wayback.util.partition.PartitionSize"
%><%@ page import="org.archive.wayback.util.StringFormatter"
%><%@ page import="org.archive.wayback.util.url.UrlOperations"
%><%
UIResults results = UIResults.extractReplay(request);
WaybackRequest wbRequest = results.getWbRequest();
ResultURIConverter uriConverter = results.getURIConverter();
StringFormatter fmt = wbRequest.getFormatter();

String staticPrefix = results.getStaticPrefix();
String queryPrefix = results.getQueryPrefix();
String replayPrefix = results.getReplayPrefix();

String graphJspPrefix = results.getContextConfig("graphJspPrefix");
if(graphJspPrefix == null) {
	graphJspPrefix = queryPrefix;
}
InteractiveToolBarData data = new InteractiveToolBarData(results);

String searchUrl =
	UrlOperations.stripDefaultPortFromUrl(wbRequest.getRequestUrl());
String searchUrlSafe = fmt.escapeHtml(searchUrl);
String searchUrlJS = fmt.escapeJavaScript(searchUrl);
Date firstYearDate = data.yearPartitions.get(0).getStart();
Date lastYearDate = data.yearPartitions.get(data.yearPartitions.size()-1).getEnd();

int resultIndex = 1;
int imgWidth = 0;
int imgHeight = 27;
int monthWidth = 2;
int yearWidth = 25;

for (int year = 1991; year <= Calendar.getInstance().get(Calendar.YEAR); year++)
    imgWidth += yearWidth;

String yearFormatKey = "PartitionSize.dateHeader.yearGraphLabel";
String encodedGraph = data.computeGraphString(yearFormatKey,imgWidth,imgHeight);

String graphImgUrl = graphJspPrefix + "jsp/graph.jsp?graphdata=" + encodedGraph;
// TODO: this is archivalUrl specific:
String starLink = fmt.escapeHtml(queryPrefix + wbRequest.getReplayTimestamp() +
		"*/" + searchUrl);
%>
<!-- BEGIN WAYBACK TOOLBAR INSERT -->

<style type="text/css">
  body {
    margin-top: 0 !important;
    padding-top: 0 !important;
    min-width: 800px !important;
  }
  #wm-ipp a:hover {
    text-decoration: underline !important;
  }
  .su-wayback-m-tooltip {
    position: absolute;
    z-index: 1070;
    display: block;
    visibility: visible;
    font-size: 12px;
    line-height: 1.4;
    opacity: 0;
    filter: alpha(opacity=0);
  }
  .su-wayback-m-tooltip.in {
    opacity: 0.9;
    filter: alpha(opacity=90);
  }
  .su-wayback-m-tooltip.top {
    margin-top: -3px;
    padding: 5px 0;
  }
  .su-wayback-m-tooltip.right {
    margin-left: 3px;
    padding: 0 5px;
  }
  .su-wayback-m-tooltip.bottom {
    margin-top: 3px;
    padding: 5px 0;
  }
  .su-wayback-m-tooltip.left {
    margin-left: -3px;
    padding: 0 5px;
  }
  .su-wayback-m-tooltip-inner {
    max-width: 200px;
    padding: 3px 8px;
    color: #f7f7f7;
    text-align: center;
    text-decoration: none;
    background-color: #990000;
    border-radius: 4px;
  }
  .su-wayback-m-tooltip-arrow {
    position: absolute;
    width: 0;
    height: 0;
    border-color: transparent;
    border-style: solid;
  }
  .su-wayback-m-tooltip.top .su-wayback-m-tooltip-arrow {
    bottom: 0;
    left: 50%;
    margin-left: -5px;
    border-width: 5px 5px 0;
    border-top-color: #990000;
  }
  .su-wayback-m-tooltip.top-left .su-wayback-m-tooltip-arrow {
    bottom: 0;
    left: 5px;
    border-width: 5px 5px 0;
    border-top-color: #990000;
  }
  .su-wayback-m-tooltip.top-right .su-wayback-m-tooltip-arrow {
    bottom: 0;
    right: 5px;
    border-width: 5px 5px 0;
    border-top-color: #990000;
  }
  .su-wayback-m-tooltip.right .su-wayback-m-tooltip-arrow {
    top: 50%;
    left: 0;
    margin-top: -5px;
    border-width: 5px 5px 5px 0;
    border-right-color: #990000;
  }
  .su-wayback-m-tooltip.left .su-wayback-m-tooltip-arrow {
    top: 50%;
    right: 0;
    margin-top: -5px;
    border-width: 5px 0 5px 5px;
    border-left-color: #990000;
  }
  .su-wayback-m-tooltip.bottom .su-wayback-m-tooltip-arrow {
    top: 0;
    left: 50%;
    margin-left: -5px;
    border-width: 0 5px 5px;
    border-bottom-color: #990000;
  }
  .su-wayback-m-tooltip.bottom-left .su-wayback-m-tooltip-arrow {
    top: 0;
    left: 5px;
    border-width: 0 5px 5px;
    border-bottom-color: #990000;
  }
  .su-wayback-m-tooltip.bottom-right .su-wayback-m-tooltip-arrow {
    top: 0;
    right: 5px;
    border-width: 0 5px 5px;
    border-bottom-color: #990000;
  }
  .su-wayback-m-tooltip {
    font-size: 13px;
    z-index: 100000;
  }
  .su-wayback-m-tooltip-inner {
    background-color: #990000;
    border: 1px solid #000; border: 0;
    color: #f7f7f7;
    -moz-box-shadow: 2px 5px 10px 2px #999;
    -webkit-box-shadow: 2px 5px 10px 2px #999;
    box-shadow: 2px 5px 10px 2px #999;
  }
  .su-wayback-m-tooltip.in {
    opacity: 1;
    filter: alpha(opacity=100);
  }
  .su-wayback-m-tooltip.left {
    margin-left: -12px;
  }
  @import url(https://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700);
  .su-wayback-m-years, .su-wayback-m-months, .su-wayback-m-days  {
    border-collapse:collapse;
    border-spacing:0;
    display: inline-block;
    vertical-align: bottom;
  }
  .su-wayback-m-years td, .su-wayback-m-months td, .su-wayback-m-days td {
    font-family:Arial, sans-serif;
    font-size:14px;
    padding: 5px;
    border:1px solid #bbb;
    overflow:hidden;
    word-break:normal;
  }
  .su-wayback-m-years td > div, .su-wayback-m-months td > div, .su-wayback-m-days td > div {
    background: #555;
    border: 1px solid #ccc;
    border-radius: 6px;
    width: 10px;
    height: 10px;
    margin: 0 auto;
  }
  .su-wayback-m-years .su-wayback-m-year-heading,
  .su-wayback-m-months .su-wayback-m-month-heading,
  .su-wayback-m-days .su-wayback-m-day-heading {
    border:0;
    font-weight:bold;
    color:#9b9b9b;
    text-align:left;
    font-size:11px;
    padding:0 0 3px;
  }
  .su-wayback-m-days .su-wayback-m-day-heading {
    padding-left: 3px;
  }
  .su-wayback-m-year-label, .su-wayback-m-month-label, .su-wayback-m-day-label  {
    display: inline-block;
    vertical-align: bottom;
    text-align: right;
    margin-right: 10px;
    color: #999;
    font-size: 13px;
    font-weight: bold;
    text-transform: uppercase;
    width: 50px;
  }
  .su-wayback-m-years .su-wayback-m-frequency,
  .su-wayback-m-months .su-wayback-m-frequency,
  .su-wayback-m-days .su-wayback-m-frequency {
    width: 24px;
    background-color: #f7f7f7;
  }

  .su-wayback-m-year-display {margin: 10px 10px 20px 10px;}
  .su-wayback-m-month-display {margin: 10px 10px 20px 10px;}
  .su-wayback-m-day-display {margin: 10px 10px 25px 10px;}

  .su-wayback-m-month-display, .su-wayback-m-day-display {display: none;}

  .su-wayback-m-month-heading, .su-wayback-m-month-label,
  .su-wayback-m-day-heading, .su-wayback-m-day-label {
    display: none;
  }
  .su-wayback-m-months .su-wayback-m-month-heading {
    padding-left: 3px;
  }
  .su-wayback-m-month-heading.dec, .su-wayback-m-day-heading.thirty {text-align: right;}

  .su-wayback-m-days .su-wayback-m-frequency {
    padding: 0;
  }
  .su-wayback-m-frequency.su-wayback-m-low {
    background-color: #fee391;
  }
  .su-wayback-m-frequency.su-wayback-m-low-medium {
    background-color: #fec44f;
  }
  .su-wayback-m-frequency.su-wayback-m-medium {
    background-color: #fe9929;
    color: #f7f7f7;
  }
  .su-wayback-m-frequency.su-wayback-m-medium-high {
    background-color: #d95f0e;
    color: #f7f7f7;
  }
  .su-wayback-m-frequency.su-wayback-m-high {
    background-color: #993404;
    color: #f7f7f7;
  }
</style>

<!-- TODO: We should be able to remove js/disclaim-element.js
           but without it the overlay doesn't show.
           Probably related to JS code at very bottom of this page. -->
<script type="text/javascript" src="<%= staticPrefix %>js/disclaim-element.js" ></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js" ></script>

<script type="text/javascript" src="<%= staticPrefix %>js/su-wayback-m-bootstrap-tooltip.js" ></script>

<script type="text/javascript">
  $().ready(function(){
    // Stanford Wayback show/hide toggle
    $("#su-wayback-m-visibility-toggle").click(function() {
      $(this).text($(this).text() == 'Show overlay' ? 'Hide overlay' : 'Show overlay');
      $("#su-wayback-m-toolbar-info").toggle();
      return false;
    });

    var freq_class;
    var months = [ "January", "February", "March", "April", "May", "June",
                   "July", "August", "September", "October", "November", "December" ];

    // YEARS data
    var years_json = {
      "1991":7,"1992":5,"1993":3,"1994":1,"1995":12,"1996":0,"1997":0,"1998":0,"1999":2,
      "2000":0,"2001":8,"2002":0,"2003":0,"2004":2,"2005":5,"2006":7,"2007":0,"2008":0,"2009":0,
      "2010":6,"2011":0,"2012":1,"2013":0,"2014":2
    }

    // MONTHS data
    months_json = {
      "1991":{"1":5,"2":9,"3":0,"4":0,"5":2,"6":2,"7":1,"8":0,"9":0,"10":0,"11":0,"12":1},
    	"1992":{"1":0,"2":0,"3":2,"4":1,"5":1,"6":0,"7":0,"8":1,"9":0,"10":0,"11":0,"12":0},
    	"1993":{"1":1,"2":0,"3":0,"4":0,"5":0,"6":1,"7":0,"8":0,"9":0,"10":0,"11":0,"12":1},
    	"1994":{"1":0,"2":0,"3":0,"4":1,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
    	"1995":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
    	"1996":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
    	"1997":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
    	"1998":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
    	"1999":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
    	"2000":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
      "2001":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
      "2002":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
      "2003":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
      "2004":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
      "2005":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
      "2006":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
      "2007":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
      "2008":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
      "2009":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
      "2010":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
      "2011":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
      "2012":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
      "2013":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0},
      "2014":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0}
     }

  days_json = {"1991":{"1":"0123450005830020200209005072101","2":"0090030020011072005607342001","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000010000000000000000000000000"},"1992":{"1":"0000000000000000000000000000000","2":"00000000000000000000000000000","3":"0000010000000000010000000000000","4":"000000000000000000000000000001","5":"1000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000010000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"1993":{"1":"0000000000000000000000000001000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000001000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"1000000000000000000000000000000"},"1994":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000100000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"1995":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"1996":{"1":"0000000000000000000000000000000","2":"00000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"1997":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"1998":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"1999":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2000":{"1":"0000000000000000000000000000000","2":"00000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2001":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2002":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2003":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2004":{"1":"0000000000000000000000000000000","2":"00000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2005":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2006":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2007":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2008":{"1":"0000000000000000000000000000000","2":"00000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2009":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2010":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2011":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2012":{"1":"0000000000000000000000000000000","2":"00000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2013":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"},"2014":{"1":"0000000000000000000000000000000","2":"0000000000000000000000000000","3":"0000000000000000000000000000000","4":"000000000000000000000000000000","5":"0000000000000000000000000000000","6":"000000000000000000000000000000","7":"0000000000000000000000000000000","8":"0000000000000000000000000000000","9":"000000000000000000000000000000","10":"0000000000000000000000000000000","11":"000000000000000000000000000000","12":"0000000000000000000000000000000"}}

  // Create cells for the YEARS visualization when the document is loaded.
  $.each(years_json, function(key, value) {
    determineFrequencyClass(value);
    // console.log(key + ": " + value + " = " + freq_class);
    var cell = $('<td class="su-wayback-m-frequency ' + freq_class + '" data-toggle="tooltip" data-placement="top" data-container="body" data-key="' + key + '" data-original-title="' + key + ': ' + value +  ' captures" title=""><div style="opacity: 0;">&nbsp;</div></td>')
    $("#su-wayback-m-year-data").append(cell);
    $("[data-toggle='tooltip']").tooltip();
  });

  // When a year is clicked, create cells for the MONTHS visualization.
  $(document).on('click', '#su-wayback-m-year-data td', function () {
    $("#su-wayback-m-year-data td > div").css("opacity", "0");
    $(this).find("div").css("opacity", "1");
    $(".su-toolbar-viz-message").css("display", "none");
    $(".su-wayback-m-month-display").css("display", "block");
    $(".su-wayback-m-day-display .su-wayback-m-day-label").css("display", "none");
    $(".su-wayback-m-day-display .su-wayback-m-day-heading").css("display", "none");
    $(".su-wayback-m-month-display .su-wayback-m-month-label").css("display", "inline-block");
    $(".su-wayback-m-month-display .su-wayback-m-month-heading").css("display", "table-cell");
    $("#su-wayback-m-month-data").empty();
    $("#su-wayback-m-day-data").empty();
    target_year = $(this).data("key");
    $.each(months_json[target_year], function(key, value) {
      determineFrequencyClass(value);
      month_label = getMonthLabel(key);
      // console.log("key: " +key + ", value: " + value + " month label: " + month_label);
      var cell = $('<td class="su-wayback-m-frequency ' + freq_class + '" data-toggle="tooltip" data-placement="top" data-container="body" data-year="' + target_year + '" data-key="' + key + '" data-original-title="' +  month_label + " " + target_year + ': ' + value +  ' captures" title=""><div style="opacity: 0;">&nbsp;</div></td>')
      $("#su-wayback-m-month-data").append(cell);
      $("[data-toggle='tooltip']").tooltip();
    });
  });

  // When a month is clicked, create cells for the DAYS visualization.
  $(document).on('click', '#su-wayback-m-month-data td', function () {
    $("#su-wayback-m-month-data td > div").css("opacity", "0");
    $(this).find("div").css("opacity", "1");
    $(".su-wayback-m-day-display").css("display", "block");
    $(".su-wayback-m-day-display .su-wayback-m-day-label").css("display", "inline-block");
    $(".su-wayback-m-day-display .su-wayback-m-day-heading").css("display", "table-cell");
    $("#su-wayback-m-day-data").empty();
    target_year = $(this).data("year");
    target_month = $(this).data("key");
    month_label = getMonthLabel(target_month);
    month_data = days_json[target_year][target_month];
    for (var i = 0; i < month_data.length; i++) {
      var day_value = month_data.substring(i, i+1);
      // convert day value to int from string
      determineFrequencyClass(parseInt(day_value, 10));
      var day_label = i + 1; // adjust for zero-based index; days start with 1
      // TODO: replace the link below with capture clicked on
      var cell = $('<td class="su-wayback-m-frequency ' + freq_class + '" data-toggle="tooltip" data-placement="top" data-container="body" data-original-title="' + month_label + " " + day_label + ", " + target_year + ': ' + day_value +  ' captures" title=""><a href="<%= staticPrefix %>20140909184942/http://stanford.edu/" style="z-index: 100001;"><div style="opacity: 0;">&nbsp;</div></a></td>')
      $("#su-wayback-m-day-data").append(cell);
      $("[data-toggle='tooltip']").tooltip();
    }
  });

  function determineFrequencyClass(freq) {
    if (freq == 1) {
      freq_class = "su-wayback-m-low";
    } else if ((freq > 1) && (freq <= 3 )) {
      freq_class = "su-wayback-m-low-medium";
    } else if ((freq > 3) && (freq <= 5 )) {
      freq_class = "su-wayback-m-medium";
    } else if ((freq > 5) && (freq <= 7 )) {
      freq_class = "su-wayback-m-medium-high";
    } else if (freq > 7) {
      freq_class = "su-wayback-m-high";
    } else {
      freq_class = "";
    }

    return freq_class;
  }

  function getMonthLabel(month_value) {
    month_label = months[month_value - 1];
    return month_label;
  }

});
</script>

<style type="text/css"></style>
<div id="wm-ipp" style="display:none; position:relative;padding:0;min-height:90px;min-width:800px; z-index:99999; margin: 0 30px;">
  <div id="wm-ipp-inside"
    style="position:fixed;padding: 0!important;margin:0!important;
          width:96%;min-width:780px;
          border: 2px solid #999; border-top:none;
          border-bottom-left-radius: 12px; border-bottom-right-radius: 12px;
          background-color: #990000;
          text-align:center;
          font-size:12px!important;font-family:'Lucida Grande','Arial',sans-serif!important;">

          <div id="su-wayback-m-sul-logo" style="padding: 6px 12px 12px; height: 36px;">
            <div style="width: 100%;">
              <span style="display: inline-block; float: left;">
                <a href="http://library.stanford.edu" title="Stanford University Library homepage">
                  <img src="<%= staticPrefix %>images/SUL-Logo-white-text-h25.png" alt="Wayback Machine" width="297" height="25" border="0" />
                </a>
              </span>
              <span class="su-wayback-m-toolbar-actions"
                    style="display: inline-block; float: right; padding-top: 3px;
                          font-size: 13px;
                          font-family:'Source Sans Pro','Helvetica Neue',Helvetica,Arial,sans-serif;">
                <a href="<%= staticPrefix %>"
                   title="Find out more about the Stanford Wayback Machine"
                  style="color: #ddd; text-decoration: none;">
                    Stanford Wayback Home
                </a>
                <span style="color: #bbb; padding: 4px;">|</span>
                <!-- TODO: What is this page linked below? Does Nicholas have an idea for it? -->
                <a href="#"
                    style="color: #ddd; text-decoration: none;">
                    Wayback Info
                </a>
                <span style="color: #bbb; padding: 4px;">|</span>
                <a href="#" id="su-wayback-m-visibility-toggle"
                    style="color: #ddd; text-decoration: none;">
                    Hide overlay
                </a>
              </span>
            </div>
          </div>
          <div style="float: left; height: 34px; width: 100%; margin:0; padding: 8px 20px; font-size: 14px; font-family:'Source Sans Pro','Helvetica Neue',Helvetica,Arial,sans-serif!important; color: #555; background-color: #f7f7f7;">
            <div style="float: left; margin-left: 30px;">
              <span>
                Showing
                <span style="text-decoration: underline;">
                  <%= searchUrlSafe %>
                </span>
                captured on
                <%= fmt.format("ToolBar.curMonthText",data.curResult.getCaptureDate()) %>
                <%= fmt.format("ToolBar.curDayText",data.curResult.getCaptureDate()) %>,
                <%= fmt.format("ToolBar.curYearText",data.curResult.getCaptureDate()) %>
              </span>
            </div>
            <div style="float: right;">
              <span>
                <a href="#" style="color: #555; text-decoration: none;"> <!-- TODO: if previous capture, link to it -->
                  <img src="<%= staticPrefix %>images/toolbar/su-wayback-m-left-arrow.png" style="width: 14px; height: 14px; vertical-align: middle; margin-bottom: 3px; opacity: 0.6;">
                  Previous capture
                </a>
              </span>
              <span style="color: #bbb; padding: 4px;">|</span>
              <span>
                <a href="#" style="color: #555; text-decoration: none;"> <!-- TODO: if next capture, link to it -->
                  Next capture
                  <img src="<%= staticPrefix %>images/toolbar/su-wayback-m-right-arrow.png" style="width: 14px; height: 14px; vertical-align: middle; margin-bottom: 3px; opacity: 0.6;">
                </a>
              </span>
            </div>
          </div>


    <table id="su-wayback-m-toolbar-info"
           style="border-collapse:collapse;margin: 0 0;width:100%;
                  border-top: 2px solid #bbb;
                  border-bottom-left-radius: 9px; border-bottom-right-radius: 9px;
                  background-color: #eee;">
      <tbody>
      <tr>
        <td style="padding:0!important;text-align:center;vertical-align:top;width:100%;">
          <table style="border-collapse:collapse;margin:0 auto;padding:0;">
            <tbody>
              <tr>
                <td style="padding: 20px 0 0;" colspan="2">
                  <form target="_top" method="get" action="<%= queryPrefix %>query" name="wmtb" id="wmtb"
                        style="margin:0!important;padding:0!important;">
                        <input type="text" name="<%= WaybackRequest.REQUEST_URL %>" id="wmtbURL"
                                value="<%= searchUrlSafe %>" maxlength="256"
                                style="width:300px;font-size:11px;font-family:'Lucida Grande','Arial',sans-serif;"/>
                        <input type="hidden" name="<%= WaybackRequest.REQUEST_TYPE %>" value="<%= WaybackRequest.REQUEST_REPLAY_QUERY %>">
                        <input type="hidden" name="<%= WaybackRequest.REQUEST_DATE %>" value="<%= data.curResult.getCaptureTimestamp() %>">
                        <input type="submit" value="Browse history" style="font-size:11px;font-family:'Lucida Grande','Arial',sans-serif;margin-left:5px;"/>
                        <span id="wm_tb_options" style="display:block;"></span>
                  </form>
                </td>
              </tr>
              <tr>
                <td>
                  <h2 style="font-size: 17px; color: #777; margin-top: 20px; margin-bottom: 10px;">
                     Captured
                     <span style="color: #333;">
                       1,320 times <!-- TODO: total captures for this URL -->
                     </span>
                     between
                     <a href="#" style="color: #333; text-decoration: none;">
                       September 1, 1991 <!-- TODO: first date or year with capture -->
                     </a>
                     and
                     <a href="#" style="color: #333; text-decoration: none;">
                       December 31, 2014 <!-- TODO: last date or year with capture -->
                     </a>
                  </h2>

                </td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
      <tr>
        <td style="padding:0!important;text-align:left;vertical-align:top;width:100%;">
          <table style="border-collapse:collapse;margin:0 auto;padding:0;min-width: 850px;">
            <tbody>
              <tr>
                <td>
                  <div class="su-wayback-m-year-display">
                    <span class="su-wayback-m-year-label">
                      Year
                    </span>

                    <table class="su-wayback-m-years">
                      <tr>
                        <th class="su-wayback-m-year-heading" colspan="4">1991</th>
                        <th class="su-wayback-m-year-heading" colspan="5">1995</th>
                        <th class="su-wayback-m-year-heading" colspan="5">2000</th>
                        <th class="su-wayback-m-year-heading" colspan="5">2005</th>
                        <th class="su-wayback-m-year-heading" colspan="3">2010</th>
                        <th class="su-wayback-m-year-heading" colspan="2" style="text-align: right;">2014</th>
                      </tr>
                      <tr id="su-wayback-m-year-data">
                        <!-- table cells are populated by jQuery below -->
                      </tr>
                    </table>
                  </div>

                  <div class="su-wayback-m-month-display">
                    <span class="su-wayback-m-month-label">
                      Month
                    </span>

                    <table class="su-wayback-m-months">
                      <tr>
                        <th class="su-wayback-m-month-heading jan" colspan="3">Jan</th>
                        <th class="su-wayback-m-month-heading" colspan="4">Apr</th>
                        <th class="su-wayback-m-month-heading" colspan="4">Aug</th>
                        <th class="su-wayback-m-month-heading dec" colspan="1">Dec</th>
                      </tr>
                      <tr id="su-wayback-m-month-data">
                        <!-- table cells are populated by jQuery below -->
                      </tr>
                    </table>
                  </div>

                  <div class="su-wayback-m-day-display">
                    <span class="su-wayback-m-day-label">
                      Day
                    </span>

                    <table class="su-wayback-m-days">
                      <tr>
                        <th class="su-wayback-m-day-heading" colspan="4">1st</th>
                        <th class="su-wayback-m-day-heading" colspan="5">5th</th>
                        <th class="su-wayback-m-day-heading" colspan="5">10th</th>
                        <th class="su-wayback-m-day-heading" colspan="5">15th</th>
                        <th class="su-wayback-m-day-heading" colspan="5">20th</th>
                        <th class="su-wayback-m-day-heading" colspan="5">25th</th>
                        <th class="su-wayback-m-day-heading" colspan="1">30th</th>
                      </tr>
                      <tr id="su-wayback-m-day-data">
                        <!-- table cells are populated by jQuery below -->
                      </tr>
                    </table>
                  </div>
                </td>
              </tr>
           </tbody>
         </table>
       </td>
    </tr>
   </tbody>
  </table>

  <script>



  </script>

  </div> <!-- end #wm-ipp-inside -->
</div> <!-- end #wm-ipp -->

<script type="text/javascript">
 var wmDisclaimBanner = document.getElementById("wm-ipp");
 if(wmDisclaimBanner != null) {
   disclaimElement(wmDisclaimBanner);
 }
</script>
<!-- END WAYBACK TOOLBAR INSERT -->
