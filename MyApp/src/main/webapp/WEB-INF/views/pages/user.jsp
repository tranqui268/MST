<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="s" uri="/struts-tags" %>
        <%@ page import="org.example.model.User" %>

            <body class="bg-light">
                <s:set var="section" value="'user'" scope="request" />
                <div>
                    <form id="searchForm" method="get" class="form-inline mb-2">
                        <input id="searchName" type="text" name="name" placeholder="Nhập họ tên"
                            class="form-control mr-1" />
                        <input id="searchEmail" type="text" name="email" placeholder="Nhập email"
                            class="form-control mr-1" />

                        <select id="searchGroup" name="group" class="form-control mr-1">
                            <option value="">Chọn nhóm</option>
                            <option value="admin">Admin</option>
                            <option value="editor">Editor</option>
                            <option value="moderator">Moderator</option>
                        </select>

                        <select id="searchStatus" name="status" class="form-control mr-1">
                            <option value="">Chọn trạng thái</option>
                            <option value="1">Đang hoạt động</option>
                            <option value="0">Tạm khóa</option>
                        </select>

                        <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Tìm kiếm</button>
                        <a href="#" id="clearSearchBtn" class="btn btn-secondary ml-1"><i class="bi bi-x-circle"></i>
                            Xóa tìm</a>
                    </form>
                    <a id="btnAdd" class="btn btn-secondary ml-1"><i class="bi bi-person-fill-add"
                            style="color: blue"></i>Thêm mới</a>

                    <div class="mb-2">
                        <button id="deleteSelectedBtn" class="btn btn-danger">Xóa hàng loạt</button>
                    </div>
                    
                    <div class="d-flex align-items-center justify-content-end" id="total">

                    </div>

                </div>


                <table id="userTable" class="table table-bordered table-striped text-center">
                    <thead class="thead-light">
                        <tr>
                            <th></th>
                            <th>#</th>
                            <th>Họ tên</th>
                            <th>Email</th>
                            <th>Nhóm</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody id="userTableBody">

                    </tbody>
                </table>


                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center" id="pagination">
                    </ul>
                </nav>

                

                <!-- Modal Thêm mới người dùng -->
                <div class="modal fade" id="addUserModal" tabindex="-1" role="dialog"
                    aria-labelledby="addUserModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addUserModalLabel"></h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <form id="addUserForm">
                                    <input type="hidden" id="userId" name="id">
                                    <div class="form-group">
                                        <label for="newName">Tên:</label>
                                        <input type="text" class="form-control" id="newName" name="name" required>
                                        <small class="text-danger" id="nameError"></small>
                                    </div>
                                    <div class="form-group">
                                        <label for="newEmail">Email:</label>
                                        <input type="email" class="form-control" id="newEmail" name="email" required>
                                        <small class="text-danger" id="emailError"></small>
                                    </div>
                                    <div class="form-group">
                                        <label for="newPassword">Mật khẩu:</label>
                                        <input type="password" class="form-control" id="newPassword" name="password"
                                            required>
                                        <small class="text-danger" id="passwordError"></small>
                                    </div>
                                    <div class="form-group">
                                        <label for="passwordConfirm">Xác nhận:</label>
                                        <input type="password" class="form-control" id="passwordConfirm"
                                            name="passwordConfirmName" required>
                                        <small class="text-danger" id="passwordConfirmError"></small>
                                    </div>
                                    <div class="form-group">
                                        <label for="newGroupRole">Nhóm quyền:</label>
                                        <select class="form-control" id="newGroupRole" name="group_role" required>
                                            <option value="">-- Chọn nhóm quyền --</option>
                                            <option value="admin">Admin</option>
                                            <option value="user">User</option>
                                        </select>
                                        <small class="text-danger" id="groupRoleError"></small>
                                    </div>

                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                <button type="button" class="btn btn-primary" id="saveUserBtn">Lưu</button>
                            </div>
                        </div>
                    </div>
                </div>