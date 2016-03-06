<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.io.BufferedWriter" %>
<%@page import="java.io.FileWriter" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.Scanner" %>
<%
/** Log POSTs at / to a file **/
if ("POST".equalsIgnoreCase(request.getMethod())) {
        BufferedWriter writer = new BufferedWriter(new FileWriter("/tmp/sample-app.log", true));
        Scanner scanner = new Scanner(request.getInputStream()).useDelimiter("\\A");
	if(scanner.hasNext()) {
		String reqBody = scanner.next();
		writer.write(String.format("%s Received message: %s.\n", (new Date()).toString(), reqBody));
	}
        writer.flush();
        writer.close();
	
} else {
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>Marker Labels</title>
    <style>
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      #map {
        height: 88%;
      }
    </style>
    
    <%-- Query the ElasticSearch Index Running on EC2 w/ ElasticIP --%>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
    <script>
    $(document).ready(function(){
        $("button").click(function(){
            
            var outputVal = $.getJSON("search.json", function(json) {
                console.log(json); // this will show the info it in firebug console
                
                var parseJson = JSON.parse(json);
                var hits = parseJson.hits;
                console.log(hits);
            });
            
        });
    });
    </script>
     
    <script type="text/javascript" src="/elasticsearch.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCiYROVbUyYpzR7uFwqrdh2QAXTQlh-0qQ"></script>
    <script>
      // In the following example, markers appear when the user clicks on the map.
      // Each marker is labeled with a single alphabetical character.
      var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      var labelIndex = 0;

      function initialize() {
        var bangalore = { lat: 12.97, lng: 77.59 };
        var map = new google.maps.Map(document.getElementById('map'), {
          zoom: 3,
          center: bangalore
        });

        // This event listener calls addMarker() when the map is clicked.
        google.maps.event.addListener(map, 'click', function(event) {
          addPins(event.latLng, map);
          // addMarker(event.latLng, map);
        });

        // Add a marker at the center of the map.
        addMarker(bangalore, map);
      }

      // Adds a marker to the map.
      function addMarker(location, map) {
        // Add the marker at the clicked location, and add the next-available label
        // from the array of alphabetical characters.
        var marker = new google.maps.Marker({
          position: location,
          label: labels[labelIndex++ % labels.length],
          map: map
        });
      }
        
      google.maps.event.addDomListener(window, 'load', initialize);
    </script>
     
    <script>
    var elasticsearch = require('elasticsearch');
    var client = new elasticsearch.Client({
      host: '52.35.80.198:9201',
      log: 'trace'
    });
    
    client.ping({
    requestTimeout: 30000,

    // undocumented params are appended to the query string
      hello: "elasticsearch"
    }, function (error) {
      if (error) {
        console.error('elasticsearch cluster is down!');
      } else {
        console.log('All is well');
      }
    });
        
    client.search({
      index: 'apple',
      type: 'tweets',
      body: {
        query: {
          match: {
            body: 'Apple'
          }
        }
      }
    }).then(function (resp) {
        var hits = resp.hits.hits;
    }, function (err) {
        console.trace(err.message);
    });
        
    </script>
     
     <style>
         #button-layout {
             display:inline-block;
         }
     </style>
</head>
<body>
    
    <div id="selection"><h2>Homework 1 - TweetMap by efj2106</h2></div>
    
    <%-- 10 Selection Buttons to Filter Results --%>
    <div id="button-layout">
    <button id="Apple" type="button">Word 1: Apple</button>
    <button id="Google" type="button">Word 2: Google</button>
    <button id="Happy" type="button">Word 3: Happy</button>
    <button id="Sad" type="button">Word 4: Sad</button>
    <button id="Good" type="button">Word 5: Good</button>
    <button id="Bad" type="button">Word 6: Bad</button>
    <button id="iPhone" type="button">Word 7: iPhone</button>
    <button id="Camera" type="button">Word 8: Camera</button>
    <button id="Music" type="button">Word 9: Music</button>
    <button id="Internet" type="button">Word 10: Internet</button>
    </div>
    
    <div></div>
      
    <div id="map"></div>
    <script>
    var data = {
      size: 5 // get 5 results
      q: 'title:jones' // query on the title field for 'jones'
    };
   </script>
  </body>
</html>
<% } %>
