<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
        <%@ taglib prefix="s" uri="/struts-tags" %>
            <% response.setCharacterEncoding("UTF-8"); %>
                <nav class="navbar navbar-expand-lg navbar-light">
                    <div class="container-fluid">
                        <!-- Tiêu đề -->
                        <a class="navbar-brand text-white" href="#" id="navbarTitle" >QUẢN LÝ USER</a>
                        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
                            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <div class="collapse navbar-collapse justify-content-start" id="navbarNav">
                            <ul class="navbar-nav">
                                <li class="nav-item">
                                    <a class="nav-link text-white" href="product.action"
                                        data-page="product">Products</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link text-white" href="customer.action"
                                        data-page="customer">Customers</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link text-white" href="user.action" data-page="user">Users</a>
                                </li>
                            </ul>
                        </div>

                        <div class="d-flex align-items-center">
                            <s:if test="session.loggedUser != null">
                                <span class="navbar-text mr-3 text-white">👤
                                    <s:property value="#session.loggedUser.group_role" />
                                </span>
                            </s:if>
                            <a href="logout.action" class="btn btn-danger">Logout</a>
                        </div>
                    </div>
                </nav>

                <style>
                    .navbar {
                        background-color: #17a2b8;
                        /* Màu xanh lam giống hình ảnh */
                    }

                    .nav-item.active .nav-link {
                        background-color: #dc3545;
                        /* Màu đỏ khi active */
                        border-radius: 5px;
                    }
                </style>

                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        const currentPage = window.location.pathname.split("/").pop().split(".")[0]; // ví dụ: user từ "user.action"

                        const pageTitles = {
                            "user": "QUẢN LÝ USER",
                            "product": "QUẢN LÝ SẢN PHẨM",
                            "customer": "QUẢN LÝ KHÁCH HÀNG"
                        }

                        const navbarTitle = document.getElementById("navbarTitle");
                        navbarTitle.textContent = pageTitles[currentPage] || pageTitles[""]
                        document.querySelectorAll('.nav-link').forEach(function (link) {
                            if (link.dataset.page === currentPage) {
                                link.classList.add('bg-danger', 'text-white', 'active');
                            } else {
                                link.classList.remove('bg-danger', 'text-white', 'active');
                            }
                        });


                    });
                </script>