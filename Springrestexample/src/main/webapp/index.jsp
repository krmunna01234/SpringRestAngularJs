<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!doctype html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>
            AngularJS - REST Demo using $http service
        </title>
        <!-- Load AngularJS -->
        <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
        <script type="text/javascript">
            var app = angular.module("UserManagement", []);
         
            //Controller Part
            app.controller("UserManagementController", function($scope, $http) {
         
                //Initialize page with default data which is blank in this example
                $scope.employees = [];
                $scope.form = {
                    id : -1,
                    firstName : "",
                    lastName : "",
                    email : ""
                };
         
                //Now load the data from server
                _refreshPageData();
         
                //HTTP POST/PUT methods for add/edit employee
                $scope.submitEmployee = function() {
         
                    var method = "";
                    var url = "";
                    if ($scope.form.id == -1) {
                        //Id is absent so add employee - POST operation
                        method = "POST";
                        url = 'employees';
                    } else {
                        //If Id is present, it's edit operation - PUT operation
                        method = "PUT";
                        url = 'employees/' + $scope.form.id;
                    }
         
                    $http({
                        method : method,
                        url : url,
                        data : angular.toJson($scope.form),
                        headers : {
                            'Content-Type' : 'application/json'
                        }
                    }).then( _success, _error );
                };
         
                //HTTP DELETE- delete employee by Id
                $scope.removeEmployee = function(employee) {
                    $http({
                        method : 'DELETE',
                        url : 'employees/' + employee.id
                    }).then(_success, _error);
                };
 
                //In case of edit employee, populate form with employee data
                $scope.editEmployee = function(employee) {
                    $scope.form.firstName = employee.firstName;
                    $scope.form.lastName = employee.lastName;
                    $scope.form.email = employee.email;
                    $scope.form.id = employee.id;
                };
         
                /* Private Methods */
                //HTTP GET- get all employees collection
                function _refreshPageData() {
                    $http({
                        method : 'GET',
                        url : 'employees'
                    }).then(function successCallback(response) {
                        $scope.employees = response.data.employees;
                    }, function errorCallback(response) {
                        console.log(response.statusText);
                    });
                }
         
                function _success(response) {
                    _refreshPageData();
                    _clearForm()
                }
         
                function _error(response) {
                    console.log(response.statusText);
                }
         
                //Clear the form
                function _clearForm() {
                    $scope.form.firstName = "";
                    $scope.form.lastName = "";
                    $scope.form.email = "";
                    $scope.form.id = -1;
                };
            });
        </script>
        <style>
            .button {
                cursor: pointer;
                color: blue;
            }
            td,th{
                border: 1px solid gray;
                width: 25%;
                text-align: left;
            }
            table {
                width: 600px;
            }
        </style>
    <head>
    <body ng-app="UserManagement" ng-controller="UserManagementController">
         <h1>
            AngularJS - Use $http to invoke RESTful APIs
        </h1>
 
        <table>
            <tr>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
                <th>Actions</th>
            </tr>
 
            <tr ng-repeat="employee in employees">
                <td>{{ employee.firstName }}</td>
                <td>{{ employee.lastName }}</td>
                <td>{{ employee.email }}</td>
                <td><a ng-click="editEmployee( employee )" class="button">Edit</a> | <a ng-click="removeEmployee( employee )" class="button">Remove</a></td>
            </tr>
 
        </table>
 
        <h2>Add/Edit Employee</h2>
 
        <form ng-submit="submitEmployee()">
            <table>
                <tr>
                    <td>First Name</td>
                    <td><input type="text" ng-model="form.firstName" size="60" /></td>
                </tr>
                <tr>
                    <td>Last Name</td>
                    <td><input type="text" ng-model="form.lastName" size="60" /></td>
                </tr>
                <tr>
                    <td>Email</td>
                    <td><input type="text" ng-model="form.email" size="60" /></td>
                </tr>
                <tr>
                    <td colspan="2"><input type="submit" value="Submit" /></td>
                </tr>
            </table>
        </form>
 
    </body>
</html>