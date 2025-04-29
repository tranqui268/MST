<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="s" uri="/struts-tags" %>
        <%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
            <script>
                console.log('user-script.jsp loaded!');

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

                    $(document).on('change', '#selectAll', function () {
                        $('.user-checkbox').prop('checked', $(this).prop('checked'));
                    });


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
                                if (response.data && response.data.length > 0) {
                                    console.log('Response:', response);
                                    const startIndex = (page - 1) * response.paginationInfo.pageSize;
                                    $.each(response.data, function (index, user) {
                                        let row = '<tr>' +
                                            '<td><input type="checkbox" class="user-checkbox" value="' + user.id + '"></td>' +
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

                                    $('#total').html('<p>Hiển thị từ ' + (startIndex + 1) + ' ~ ' + (startIndex + response.data.length) + ' trong tổng số ' + response.paginationInfo.totalUsers + ' khách hàng</p>');


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
                        selectedUserName = $icon.closest('tr').find('td').eq(2).text();
                        const currentStatus = $icon.data('active');
                        newStatus = currentStatus == 1 ? 0 : 1;
                        $currentRow = $icon.closest('tr');
                        console.log(this);
                        console.log($icon.data());



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
                        $('#confirmStatusModal').data('action', 'changePermission');
                        $('#confirmStatusModal').modal('show');


                    });




                    // Update permission
                    $('#confirmStatusBtn').on('click', function () {
                        const action = $('#confirmStatusModal').data('action')
                        console.log(action);

                        if (action === 'changePermission') {
                            updatePermission();
                        }
                        if (action === 'deleteUser') {
                            deleteUser();
                        }
                    });

                    // Delete user
                    $(document).on('click', '.deleteUser', function () {
                        const $icon = $(this);
                        selectedUserId = $icon.data('id');
                        const name = $icon.closest('tr').find('td').eq(2).text();
                        $('#confirmStatusModal').modal({
                            backdrop: 'static',
                            keyboard: false
                        });


                        const htmlContent = 'Bạn có muốn xóa thành viên <strong>' + name + '</strong> không?';
                        $('#confirmModalContent').html(htmlContent);
                        console.log("Content set before show:", $('#confirmModalContent').html());
                        $('#confirmStatusModal').data('action', 'deleteUser');
                        $('#confirmStatusModal').modal('show');

                    });

                    // Delete All
                    $(document).on('click', '#deleteSelectedBtn', function () {
                        const ids = $('.user-checkbox:checked').map(function () {
                            return $(this).val();
                        }).get();

                        if (ids.length === 0) {
                            alert('Vui lòng chọn ít nhất một người dùng để xóa.');
                            return;
                        }

                        if (!confirm('Bạn có chắc chắn muốn xóa ' + ids.length + ' người dùng?')) {
                            return;
                        }

                        // Gửi request xóa
                        $.ajax({
                            url: 'deleteUsersBulk',
                            type: 'POST',
                            data: { selectedIds: ids },
                            traditional: true, // để gửi mảng đúng định dạng
                            success: function (response) {
                                if (response.success) {
                                    alert('Đã xóa thành công!');
                                    loadUser(1); // gọi lại hàm load dữ liệu nếu bạn có
                                } else {
                                    alert('Xóa thất bại!');
                                }
                            },
                            error: function () {
                                alert('Lỗi kết nối server!');
                            }
                        });
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

                        const name = $icon.closest('tr').find('td').eq(2).text();
                        const email = $icon.closest('tr').find('td').eq(3).text();
                        const group = $icon.closest('tr').find('td').eq(4).text();

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
                                if (response.success) {
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
                                            group: groupRole
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


                    // function 
                    function updatePermission() {
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
                                    Swal.fire("Thành công!", "Cập nhật trạng thái thành công!", "success").then(() => {
                                        loadUser();
                                    });                                  
                                } else {
                                    Swal.fire("Thất bại!", "Cập nhật trạng thái thất bại!", "error");                               
                                }
                                $('#confirmStatusModal').modal('hide');
                            },
                            error: function () {
                                Swal.fire("Thất bại", "Lỗi server!", "error");
                                $('#confirmStatusModal').modal('hide');
                            }
                        });
                    }

                    function deleteUser() {
                        $.ajax({
                            url: 'deleteUser',
                            method: 'POST',
                            data: { id: selectedUserId },
                            success: function (response) {
                                if (response.success) {
                                    Swal.fire("Thành công!", "Xóa thành công!", "success").then(() => {
                                        loadUser();
                                    });
                                } else {
                                    Swal.fire("Thất bại!", "Xóa thất bại!", "error");
                                    alert("Xóa thất bại!");
                                }
                                $('#confirmStatusModal').modal('hide');
                            },
                            error: function () {
                                Swal.fire("Thất bại", "Lỗi server!", "error");
                                $('#confirmStatusModal').modal('hide');
                            }
                        });
                    }


                });
            </script>