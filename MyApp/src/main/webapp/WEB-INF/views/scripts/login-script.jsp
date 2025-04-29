<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
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
