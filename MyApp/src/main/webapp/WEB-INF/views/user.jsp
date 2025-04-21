<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="s" uri="/struts-tags" %>
        <%@ page import="org.example.model.User" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>User</title>
                <link rel="stylesheet"
                    href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

            </head>

            <body class="bg-light">
                <s:set var="section" value="'user'" scope="request" />
                <div class="container">
                    <h2 class="bg-info text-white text-center">QUẢN LÝ USER</h2>
                </div>

                <%@ include file="/WEB-INF/views/common/navbar.jsp" %>

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
                            <a href="#" id="clearSearchBtn" class="btn btn-secondary ml-1"><i
                                    class="bi bi-x-circle"></i> Xóa tìm</a>
                        </form>
                        <a id="btnAdd" class="btn btn-secondary ml-1"><i class="bi bi-person-fill-add"
                                style="color: blue"></i>Thêm mới</a>
                        <div class="d-flex align-items-center justify-content-end" id="total">

                        </div>

                    </div>


                    <table id="userTable" class="table table-bordered table-striped text-center">
                        <thead class="thead-light">
                            <tr>
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

                    <!-- Modal -->
                    <div class="modal fade" id="confirmStatusModal" tabindex="-1" role="dialog"
                        aria-labelledby="confirmModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered" role="document">
                            <div class="modal-content">
                                <div class="modal-header bg-warning">
                                    <h5 class="modal-title" id="confirmModalLabel">Nhắc nhở</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Đóng">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body text-center" id="confirmModalContent">

                                </div>
                                <div class="modal-footer justify-content-center">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy bỏ</button>
                                    <button type="button" class="btn btn-primary" id="confirmStatusBtn">OK</button>
                                </div>
                            </div>
                        </div>
                    </div>

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
                                            <input type="email" class="form-control" id="newEmail" name="email"
                                                required>
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




                    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
                    <script
                        src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
                    <script>
                        if (typeof jQuery === 'undefined') {
                            console.error('jQuery is not loaded!');
                        } else {
                            console.log('jQuery loaded successfully:', jQuery.fn.jquery);
                            if (typeof $.ajax === 'undefined') {
                                console.error('$.ajax is not available! Make sure to use the full jQuery version.');
                            } else {
                                console.log('$.ajax is available');
                            }
                        }

                        $(document).ready(function () {

                            console.log('Document ready - Starting AJAX call');

                            loadUser(1);
                            // fetch data user
                            function loadUser(page = 1) {
                                let searchParams = {
                                    name: $('#searchName').val() ?? '',
                                    email: $('#searchEmail').val() ?? '',
                                    group: $('#searchGroup').val() ?? '',
                                    status: $('#searchStatus').val() ?? ''
                                };
                                console.log('loadUser function called for page:', page);
                                $.ajax({
                                    url: 'getListUserFilter',
                                    type: 'GET',
                                    data: {
                                        name: searchParams.name,
                                        email: searchParams.email,
                                        group: searchParams.group,
                                        status: searchParams.status,
                                        page: page
                                    },
                                    dataType: 'json',
                                    success: function (response) {
                                        console.log('Response:', response);
                                        let tableBody = $('#userTableBody');
                                        tableBody.empty();


                                        // Hiển thị danh sách user
                                        if (response.users && response.users.length > 0) {
                                            console.log('Response:', response);
                                            const startIndex = (page - 1) * response.pageSize;
                                            $.each(response.users, function (index, user) {
                                                let row = '<tr>' +
                                                    '<td>' + (startIndex + index + 1) + '</td>' +
                                                    '<td>' + user.name + '</td>' +
                                                    '<td>' + user.email + '</td>' +
                                                    '<td>' + (user.group_role) + '</td>' +
                                                    '<td>' + (user.is_active == 1 ? '<span class="text-success">Đang hoạt động</span>' : '<span class="text-danger">Tạm khóa</span>') + '</td>' +
                                                    '<td>' +
                                                    '<a class="editUser text-info mr-2" data-id="' + user.id + '"><i class="bi bi-pencil-fill" style="color: blue"></i></a>' +
                                                    '<a href="#" class="deleteUser text-danger mr-2" data-id="' + user.id + '"><i class="bi bi-trash-fill" style="color: red;"></i></a>' +
                                                    '<a href="#" class="toggle-active text-dark" data-id="' + user.id + '" data-active="' + user.is_active + '"><i class="bi bi-person-x-fill"></i></a>' +
                                                    '</td>' +
                                                    '</tr>';
                                                tableBody.append(row);
                                            });

                                            $('#total').html('<p>Hiển thị từ ' + (startIndex + 1) + ' ~ ' + (startIndex + response.users.length) + ' trong tổng số ' + response.totalUsers + ' khách hàng</p>');


                                        } else {
                                            tableBody.append('<tr><td colspan="5" class="text-center">Không có dữ liệu</td></tr>');
                                        }

                                        // Hiển thị phân trang
                                        let pagination = $('#pagination');
                                        pagination.empty();
                                        let paginationInfo = response.paginationInfo;
                                        let currentPage = paginationInfo.currentPage;
                                        let totalPages = paginationInfo.totalPages;

                                        // Nút Previous
                                        if (totalPages > 1) {
                                            if (currentPage > 1) {
                                                pagination.append('<li class="page-item"><a class="page-link" href="#" data-page="' + (currentPage - 1) + '">Previous</a></li>');
                                            } else {
                                                pagination.append('<li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>');
                                            }

                                            // Các số trang
                                            for (let i = 1; i <= totalPages; i++) {
                                                if (i === currentPage) {
                                                    pagination.append('<li class="page-item active"><a class="page-link" href="#">' + i + '</a></li>');
                                                } else {
                                                    pagination.append('<li class="page-item"><a class="page-link" href="#" data-page="' + i + '">' + i + '</a></li>');
                                                }
                                            }

                                            // Nút Next
                                            if (currentPage < totalPages) {
                                                pagination.append('<li class="page-item"><a class="page-link" href="#" data-page="' + (currentPage + 1) + '">Next</a></li>');
                                            } else {
                                                pagination.append('<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>');
                                            }

                                            // Gắn sự kiện cho các nút phân trang
                                            $('.page-link').click(function (e) {
                                                e.preventDefault();
                                                let page = $(this).data('page');
                                                if (page) {
                                                    loadUser(page);
                                                }
                                            });
                                        }
                                    },
                                    error: function (xhr, status, error) {
                                        console.error('Error fetching users:', error);
                                        console.error('Status:', status);
                                        console.error('XHR:', xhr);
                                        $('#userTableBody').html('<tr><td colspan="5" class="text-center text-danger">Lỗi khi tải dữ liệu</td></tr>');
                                    }
                                });
                            }

                            // event search
                            $('#searchForm').on('submit', function (e) {
                                e.preventDefault();
                                loadUser(1);
                            });

                            $('#clearSearchBtn').click(function (e) {
                                e.preventDefault();


                                $('#searchName').val('');
                                $('#searchEmail').val('');
                                $('#searchGroup').val('');
                                $('#searchStatus').val('');


                                loadUser(1);
                            });




                            // event change permission
                            let selectedUserId = null;
                            let selectedUserName = '';
                            let newStatus = null;
                            let $currentRow = null;
                            $(document).on('click', '.toggle-active', function (e) {
                                e.preventDefault();

                                const $icon = $(this);
                                selectedUserId = $icon.data('id');
                                selectedUserName = $icon.closest('tr').find('td').eq(1).text();
                                const currentStatus = $icon.data('active');
                                newStatus = currentStatus == 1 ? 0 : 1;
                                $currentRow = $icon.closest('tr');
                                console.log(this);            // Xem phần tử thật sự là gì
                                console.log($icon.data());    // Xem có chứa 'id' và 'active' không



                                const actionText = newStatus === 1 ? 'mở khóa' : 'khóa';
                                console.log("actionText:", actionText);
                                console.log("selectedUserName:", selectedUserName);
                                console.log("Element:", $('#confirmModalContent').length);

                                const modalData = { actionText, selectedUserName };

                                $('#confirmStatusModal').modal({
                                    backdrop: 'static',
                                    keyboard: false
                                });


                                const htmlContent = 'Bạn có muốn <strong>' + actionText + '</strong> thành viên <strong>' + selectedUserName + '</strong> không?';
                                $('#confirmModalContent').html(htmlContent);
                                console.log("Content set before show:", $('#confirmModalContent').html());
                                $('#confirmStatusModal').modal('show');


                            });

                            // Update permission
                            $('#confirmStatusBtn').on('click', function () {
                                $.ajax({
                                    url: 'managePermission',
                                    method: 'POST',
                                    data: {
                                        id: selectedUserId,
                                        isActive: parseInt(newStatus)
                                    },
                                    success: function (response) {
                                        console.log('Response:', response);
                                        if (response.success) {
                                            alert('Cập nhật trạng thái thành công!')
                                            loadUser();

                                        } else {
                                            alert('Cập nhật trạng thái thất bại!');
                                        }
                                        $('#confirmStatusModal').modal('hide');
                                    },
                                    error: function () {
                                        alert('Lỗi khi cập nhật trạng thái.');
                                        $('#confirmStatusModal').modal('hide');
                                    }
                                });
                            });

                            // Delete user
                            $(document).on('click', '.deleteUser', function () {
                                const $icon = $(this);
                                const userId = $icon.data('id');
                                const name = $icon.closest('tr').find('td').eq(1).text();
                                if (confirm('Bạn có chắc muốn xóa ' + name)) {
                                    $.ajax({
                                        url: 'deleteUser',
                                        method: 'POST',
                                        data: { id: userId },
                                        success: function (response) {
                                            if (response.success) {
                                                alert("Xóa thành công!");
                                                loadUser();
                                            } else {
                                                alert("Xóa thất bại!");
                                            }
                                        },
                                        error: function () {
                                            alert("Lỗi khi xóa");
                                        }
                                    });
                                }

                            });


                            //Validate add user
                            $('#btnAdd').on('click', function () {
                                $('#addUserForm')[0].reset();
                                $('#userId').val(0);
                                $('#addUserModalLabel').text('Thêm mới người dùng');

                                $('#addUserModal').modal('show');
                            });

                            // Edit user
                            $(document).on('click', '.editUser', function () {
                                $('#addUserForm')[0].reset();
                                const $icon = $(this);
                                $('#addUserModalLabel').text('Sửa thông tin người dùng')

                                const name = $icon.closest('tr').find('td').eq(1).text();
                                const email = $icon.closest('tr').find('td').eq(2).text();
                                const group = $icon.closest('tr').find('td').eq(3).text();

                                $('#userId').val($icon.data('id'));
                                $('#newName').val(name);
                                $('#newEmail').val(email);
                                $('#newGroupRole').val(group);

                                $('#addUserModal').modal('show');
                            });

                            $('#addUserModal').on('show.bs.modal', function () {

                                const errorIds = ['#nameError', '#emailError', '#passwordError', '#passwordConfirmError', '#groupRoleError'];
                                errorIds.forEach(id => $(id).text(''));
                            });


                            $('#saveUserBtn').on('click', function () {
                                let name = $('#newName').val().trim();
                                let email = $('#newEmail').val().trim();
                                let password = $('#newPassword').val().trim();
                                let confirmPassword = $('#passwordConfirm').val().trim();
                                let groupRole = $('#newGroupRole').val();
                                let id = $('#userId').val();

                                const errorIds = ['#nameError', '#emailError', '#passwordError', '#passwordConfirmError', '#groupRoleError'];
                                errorIds.forEach(id => $(id).text(''));

                                let specialCharRegex = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;
                                let emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                                let hasError = false;

                                if (!name) {
                                    $('#nameError').text('Tên không được để trống');
                                    hasError = true;
                                } else if (specialCharRegex.test(name)) {
                                    $('#nameError').text('Tên không được chứa ký tự đặc biệt');
                                    hasError = true;
                                }

                                if (!email) {
                                    $('#emailError').text('Email không được để trống.');
                                    hasError = true;
                                } else if (!emailRegex.test(email)) {
                                    $('#emailError').text('Email không đúng định dạng.');
                                    hasError = true;
                                } else if (specialCharRegex.test(email.split('@')[0])) {
                                    $('#emailError').text('Phần trước @ của email không được chứa ký tự đặc biệt.');
                                    hasError = true;
                                }

                                let isEdit = id != 0 ? true : false;
                                if (isEdit == false) {


                                    if (!password) {
                                        $('#passwordError').text('Mật khẩu không được để trống.');
                                        hasError = true;
                                    } else if (password.length < 6) {
                                        $('#passwordError').text('Mật khẩu ít nhất 6 ký tự.');
                                        hasError = true;
                                    }



                                    if (!confirmPassword) {
                                        $('#passwordConfirmError').text('Xác nhận mật khẩu không được để trống.');
                                        hasError = true;
                                    } else if (password !== confirmPassword) {
                                        $('#passwordConfirmError').text('Mật khẩu và xác nhận mật khẩu không khớp.');
                                        hasError = true;
                                    }

                                } else {
                                    if (password || confirmPassword) {
                                        if (password.length < 6) {
                                            $('#passwordError').text('Mật khẩu phải có ít nhất 6 ký tự.');
                                            hasError = true;
                                        }


                                        if (password !== confirmPassword) {
                                            $('#passwordConfirmError').text('Mật khẩu và xác nhận mật khẩu không khớp.');
                                            hasError = true;
                                        }
                                    }
                                }

                                if (!groupRole) {
                                    $('#groupRoleError').text('Vui lòng chọn nhóm quyền.');
                                    hasError = true;
                                }

                                if (hasError) return;


                                let url = id != 0 ? 'updateUser' : 'addUser';
                                // Check email existed
                                $.ajax({
                                    url: 'checkEmailExist',
                                    method: 'POST',
                                    data: {
                                        id: id,
                                        email: email
                                    },
                                    dataType: 'json',
                                    success: function (response) {
                                        if (response.exist) {
                                            $('#emailError').text('Email đã tồn tại.');
                                        } else {

                                            $.ajax({
                                                url: url,
                                                method: 'POST',
                                                data: {
                                                    id: id,
                                                    name: name,
                                                    email: email,
                                                    password: password,
                                                    groupRole: groupRole
                                                },
                                                dataType: 'json',
                                                success: function (response) {
                                                    if (response.success) {
                                                        alert(id != 0 ? "Sửa thành công" : "Thêm thành công");
                                                        $('#addUserForm')[0].reset();
                                                        loadUser();
                                                    } else {
                                                        alert(id != 0 ? "Sửa thất bại" : "Thêm thất bại");
                                                    }
                                                    $('#addUserModal').modal('hide');
                                                },
                                                error: function () {
                                                    alert(id != 0 ? "Lỗi khi sửa" : "Lỗi khi thêm");
                                                    $('#addUserModal').modal('hide');
                                                }

                                            });
                                        }
                                    }

                                });
                            });

                            // Edit user


                        });


                    </script>
            </body>

            </html>