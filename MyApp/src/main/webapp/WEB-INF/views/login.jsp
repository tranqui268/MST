
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
</head>
<body class="bg-light">

<div class="container">
    <div class="row justify-content-center align-items-center" style="height:100vh;">
        <div class="col-md-6">
            <div class="card shadow rounded">
                <div class="card-body">
                    <h3 class="card-title text-center mb-4">Đăng nhập</h3>

                    <s:if test="message != null && !message.isEmpty()">
                        <div class="alert alert-danger" role="alert">
                            <s:property value="message"/>
                        </div>
                    </s:if>

                    <!-- Form Login -->
                    <s:form action="login" method="post" cssClass="needs-validation" theme="simple">
                       <s:token/>
                        <div class="form-group">
                            <label for="email" class="form-label">Email</label>
                            <s:textfield name="email" id="email" cssClass="form-control" placeholder="Enter your email"/>
                            <div id="emailError" class="alert alert-danger mt-2 d-none"></div>
                        </div>
                        <div class="form-group">
                            <label for="password" class="form-label">Password</label>
                            <s:password name="password" id="password" cssClass="form-control" placeholder="Enter your password"/>
                            <div id="passwordError" class="alert alert-danger mt-2 d-none"></div>
                        </div>
                        <div class="form-group">
                             <label>
                                <input type="checkbox" name="remember"/> Remember
                             </label>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">Login</button>
                    </s:form>
                    <s:actionerror/>

                </div>
            </div>
        </div>
    </div>
</div>


<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const email = document.getElementById("email");
        const password = document.getElementById("password");
        const emailError = document.getElementById("emailError");
        const passwordError = document.getElementById("passwordError");

        email.addEventListener("blur", function () {
            const errorDiv = document.getElementById("emailError");
            if (email.value.trim() === "") {
                emailError.textContent = "Email không được để trống";
                emailError.classList.remove("d-none");
                emailError.classList.add("alert", "alert-danger");
            }
        });
        email.addEventListener("input", function () {
            emailError.textContent = "";
            emailError.classList.add("d-none");
            emailError.classList.remove("alert", "alert-danger");
        });



        password.addEventListener("blur", function () {
            const errorDiv = document.getElementById("passwordError");
            if (password.value.trim() === "") {
                passwordError.textContent = "Mật khẩu không được để trống";
                passwordError.classList.remove("d-none");
                passwordError.classList.add("alert", "alert-danger");
            }
        });
        password.addEventListener("input", function () {
            passwordError.textContent = "";
            passwordError.classList.add("d-none");
            passwordError.classList.remove("alert", "alert-danger");
        });

    });
</script>
</body>
</html>
