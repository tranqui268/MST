<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><tiles:getAsString name="title" /></title>
    <!-- CSS links -->
    <link rel="stylesheet" href="<s:url value='/assets/css/bootstrap.min.css' />">
    <link rel="stylesheet" href="<s:url value='/assets/css/login.css' />">
</head>
<body>
    <div class="container">
        <tiles:insertAttribute name="body" />
    </div>

    <!-- JavaScript files -->
    <script src="<s:url value='/assets/js/jquery.min.js' />"></script>
    <script src="<s:url value='/assets/js/bootstrap.bundle.min.js' />"></script>
</body>
</html>