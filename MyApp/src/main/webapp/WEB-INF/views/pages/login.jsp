<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="s" uri="/struts-tags" %>
        <%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
            <div class="container">
                <div class="row justify-content-center align-items-center" style="height:100vh;">
                    <div class="col-md-6">
                        <div class="card shadow rounded">
                            <div class="card-body">
                                <h3 class="card-title text-center mb-4">Đăng nhập</h3>

                                <s:if test="message != null && !message.isEmpty()">
                                    <div class="alert alert-danger" role="alert">
                                        <s:property value="message" />
                                    </div>
                                </s:if>

                                <!-- Form Login -->
                                <s:form action="login" method="post" cssClass="needs-validation">
                                    <s:token />
                                    <div class="form-group">
                                        <label for="email" class="form-label">Email</label>
                                        <s:textfield name="email" id="email" cssClass="form-control"
                                            placeholder="Enter your email" />
                                        <div id="emailError" class="alert alert-danger mt-2 d-none"></div>
                                    </div>
                                    <div class="form-group">
                                        <label for="password" class="form-label">Password</label>
                                        <s:password name="password" id="password" cssClass="form-control"
                                            placeholder="Enter your password" />
                                        <div id="passwordError" class="alert alert-danger mt-2 d-none"></div>
                                    </div>
                                    <div class="form-group">
                                        <label>
                                            <input type="checkbox" name="remember" /> Remember
                                        </label>
                                    </div>
                                    <button type="submit" class="btn btn-primary btn-block">Login</button>
                                </s:form>
                                <s:if test="hasActionErrors()">
                                    <div class="alert alert-danger">
                                        <s:actionerror />
                                    </div>
                                </s:if>

                            </div>
                        </div>
                    </div>
                </div>
            </div>