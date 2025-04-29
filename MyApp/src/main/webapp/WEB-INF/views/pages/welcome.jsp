<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>

<html>
<head>
    <title>Welcome</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
</head>
<body>
    <%@ include file="/WEB-INF/views/common/navbar.jsp" %>
    <s:if test="#session.loggedUser != null">
        <h2>Chào mừng <s:property value="#session.loggedUser.name"/>!</h2>
        <p>ID: <s:property value="#session.loggedUser.id"/></p>
    </s:if>

    <a href="logout.action" class="btn btn-danger mt-3">Logout</a>


    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>

</html>