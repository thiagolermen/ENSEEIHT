function initVars(scope) {
    scope.user = new Object();
}
function initView(scope) {
    scope.activeRegister = false;
}

function click(button, scope, http){
    switch (button) {
        case "register" :
            scope.activeRegister = true;
            http.post("../rest/register", scope.user).then(function(response) {
                if (response.status == 200 || response.status == 204) console.log("Success on registering."); 
                else console.log("Error registering.");
            });
            window.location.href = "../index.html";
            break;
    }
}


var app = angular.module('registerApp', []);
app.controller('registerCtrl', function($scope,$http) {
    initVars($scope);
    initView($scope);
    $scope.doClick=function(button) {click(button, $scope,$http);}
});