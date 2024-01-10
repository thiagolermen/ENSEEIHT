function initVars(scope) {
	localStorage.setItem('flights', null);
	if(localStorage.getItem("user") != null){
		if (localStorage.getItem("user").startsWith("{")){
			if (JSON.parse(localStorage.getItem("user")) !== null){	
				scope.user = JSON.parse(localStorage.getItem("user"));
			}
		}
	} else {
		 scope.user = new Object();
	}
	scope.preliminary = new Object();
	scope.flights = new Object();
	
	scope.data = {
	    nbPassengersOptions: [
	        "1",
	        "2",
	        "3",
	        "4",
	        "5"
	    ]
	};
}
function initView(scope) {
	if (localStorage.getItem("isLoggedIn") === null){
		scope.isLoggedIn = false;
	} else {
		scope.isLoggedIn = JSON.parse(localStorage.getItem("isLoggedIn"));
	}
    scope.activeLoginDiv = false;
    scope.activeAlert = false;
    scope.activeLoginAlert = false;
}

function click(button, scope, http, window){
    switch (button) {
        case "login" :
            scope.activeLoginDiv = true;
            break;
        case "main" :
            scope.activeLoginDiv = false;
            break;
        case "submit" :
            scope.activeLoginAlert = true;
            if(!scope.loginForm.$error.required){
                http.get("rest/loginauthentication", {params: scope.user}).then(function(response) {
                    if (response.status == 200 && !response.data) {
                    	console.log("Success on logging in.");
                    	scope.isLoggedIn = true;
                    	localStorage.setItem('user', JSON.stringify(scope.user));
                    	localStorage.setItem('isLoggedIn', "true");
                    } else {
                    	scope.isLoggedIn = false;
                    	console.log("Error logging in.");
                    	localStorage.setItem('isLoggedIn', "false");
                    }
                });
            }
            scope.isLoggedIn = (localStorage.getItem('isLoggedIn') === 'true');
            scope.activeLoginDiv = !scope.isLoggedIn;
            break;
        case "register" :
        	window.location.href = "pages/register.html";
            break;
        case "search-flight" :
            scope.activeAlert = true;
            if(!scope.mainForm.$error.required){
                scope.preliminary.isOneWay = Boolean(scope.preliminary.isOneWay)
                http.get("rest/searchdepartureflight", {params: scope.preliminary}).then(function(response) {
                    if (response.status == 200 || response.status == 204) {
                    	console.log("Success on adding search information"); 
                    	scope.flights = response.data;
                        localStorage.setItem('flights', JSON.stringify(scope.flights));
                        localStorage.setItem('isOneWay', JSON.stringify(scope.preliminary.isOneWay));
                        if (!scope.preliminary.isOneWay){
                        	http.get("rest/searchreturnflight", {params: scope.preliminary}).then(function(response_return) {
                        		if (response_return.status == 200 || response_return.status == 204) {
                        			console.log("Success on adding search information"); 
                                	scope.returnFlights = response_return.data;
                                	localStorage.setItem('returnFlights', JSON.stringify(scope.returnFlights));
                                	window.location.href = "pages/list_flights.html";
                        		}
                        		else console.log("Error on adding search information");
                        	});
                        } else window.location.href = "pages/list_flights.html";
                    }
                    else console.log("Error on adding search information");
                });
            }

            break;
        case "my-tickets" :
        	window.location.href = "pages/list_tickets.html";
        	scope.user = JSON.parse(localStorage.getItem('user'));
        	scope.isLoggedIn = Boolean(localStorage.getItem('isLoggedIn'));
        	break;
        case "my-account" :
        	window.location.href = "pages/my_account.html";
        	scope.user = JSON.parse(localStorage.getItem('user'));
        	scope.isLoggedIn = Boolean(localStorage.getItem('isLoggedIn'));
        	break;
    }
}

var app = angular.module('homeApp', ['ngMaterial', 'ngMessages']);
app.controller('homeCtrl', function($scope,$http, $q, $timeout, $window) {
    initVars($scope);
    initView($scope);
    $http.get("rest/loginauthentication", {params: $scope.user}).then(function(response) {
        if (response.status == 200 && !response.data) {
        	$scope.isLoggedIn = true;
        	localStorage.setItem('user', JSON.stringify($scope.user));
        	localStorage.setItem('isLoggedIn', "true");
        } else {
        	$scope.isLoggedIn = false;
        	localStorage.setItem('user', {});
        	localStorage.setItem('isLoggedIn', "false");
        }
    });
    $scope.doClick=function(button) {click(button, $scope,$http, $window);}
});