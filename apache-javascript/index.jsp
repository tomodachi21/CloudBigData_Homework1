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
        height: 85%;
      }
    </style>
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
    <script type="text/javascript" src="/elasticsearch.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCiYROVbUyYpzR7uFwqrdh2QAXTQlh-0qQ"></script>
    
    <%-- Query the ElasticSearch Index Running on EC2 w/ ElasticIP --%>
    <script>
    $(document).ready(function(){
        $("button").click(function(){
            var kansas = { lat: 38.276139, lng: -98.525391 };
            var mapT = new google.maps.Map(document.getElementById('map'), {
              zoom: 4,
              center: kansas
            });
            
            var btn = this.id;
            var baseUrl = "https://s3.amazonaws.com/homework1-json/";
            var endUrl = ".json";
            var URL = baseUrl.concat(btn);
            var URL = URL.concat(endUrl);
            
            console.log(URL);
            var output = $.getJSON(URL, function(json) {
                console.log(json); 
                var parsed = JSON.parse(JSON.stringify(json));
                var numObj = Number(Object.keys(json).length);
                console.log(numObj);
                markers = Array();
                infoWindows = Array();
                for (var i in parsed) {
                    console.log(parsed[i].lat);
                    console.log(parsed[i].long);
                    console.log(parsed[i].text);
                    console.log(parsed[i].screename);
                    console.log(parsed[i].url);
                    
                    var loc = { lat: Number(parsed[i].lat), lng: Number(parsed[i].long) };
                    
                    var marker = new google.maps.Marker({
                      position: loc,
                      map: mapT,
                      infoWindowIndex : i
                    });
                    
                    var contentString = '<div id="content">'+
                    '<div id="siteNotice">'+
                    '</div>'+
                    '<h1 id="firstHeading" class="firstHeading">' + parsed[i].screename + '</h1>'+
                    '<div id="bodyContent">'+
                    '<p>' + parsed[i].text + '</p>'+
                    '<p><a href="' + parsed[i].url + '">'+
                    'tweet-link</a></p>'+
                    '</div>'+
                    '</div>';
                    
                    var infoWindow = new google.maps.InfoWindow({
                      content: contentString
                    });
                    
                    marker.addListener('click', function(event) {
                        infoWindows[this.infoWindowIndex].open(mapT, this);
                        console.log(i);
                    });
                    
                    infoWindows.push(infoWindow);
                    markers.push(marker);
                }
                
            });
            
        });
    });
    </script>
     
    <script>
      // In the following example, markers appear when the user clicks on the map.
      // Each marker is labeled with a single alphabetical character.
      var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      var labelIndex = 0;

      function initialize() {
        var kansas = { lat: 38.276139, lng: -98.525391 };
        var map = new google.maps.Map(document.getElementById('map'), {
          zoom: 4,
          center: kansas
        });

        // This event listener calls addMarker() when the map is clicked.
        google.maps.event.addListener(map, 'click', function(event) {
          addMarker(event.latLng, map);
          //  
        });

      }

      // Adds a marker to the map.
      function addMarker(location, map) {
        // Add the marker at the clicked location, and add the next-available label
        var marker = new google.maps.Marker({
          position: location,
          label: labels[labelIndex++ % labels.length],
          map: map
        });
      }
        
      google.maps.event.addDomListener(window, 'load', initialize);
    </script>
     
     <style>
         #button-layout {
             display:inline-block;
         }
     </style>
</head>
<body>
    
    <div id="selection"><h2>Homework 1 - TweetMap by efj2106 (click on annotation for tweet info)</h2></div>
    
    <%-- 10 Selection Buttons to Filter Results --%>
    <div id="button-layout">
    <button id="apple" type="button">Word 1: Apple</button>
    <button id="google" type="button">Word 2: Google</button>
    <button id="happy" type="button">Word 3: Happy</button>
    <button id="sad" type="button">Word 4: Sad</button>
    <button id="good" type="button">Word 5: Good</button>
    <button id="bad" type="button">Word 6: Bad</button>
    <button id="iphone" type="button">Word 7: iPhone</button>
    <button id="camera" type="button">Word 8: Camera</button>
    <button id="music" type="button">Word 9: Music</button>
    <button id="coffee" type="button">Word 10: Coffee</button>
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
