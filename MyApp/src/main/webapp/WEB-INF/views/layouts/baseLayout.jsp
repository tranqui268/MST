<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
        <%@ taglib prefix="s" uri="/struts-tags" %>
            <% response.setCharacterEncoding("UTF-8"); %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>
                        <tiles:getAsString name="title" ignore="true" defaultValue="Default Title" />
                    </title>
                    <link rel="stylesheet"
                        href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
                    <style>
                        body {
                            background-color: #f8f9fa;
                        }

                        .content {
                            margin-top: 20px;
                        }
                    </style>
                </head>

                <body>
                    <!-- Navbar -->
                    <tiles:insertAttribute name="navbar" ignore="true" />

                    <!-- Body -->
                    <div class="container content">
                        <tiles:insertAttribute name="body" ignore="true" />
                        <tiles:insertAttribute name="modal" ignore="true" />
                    </div>

                    <!-- Scripts -->
                    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
                    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
                    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

                    <!-- SweetAlert2 JS -->
                    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                    <tiles:insertAttribute name="page-scripts" ignore="true" />
                </body>

                </html>