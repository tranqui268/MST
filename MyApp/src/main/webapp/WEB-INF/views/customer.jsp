<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="s" uri="/struts-tags" %>
        <%@ page import="org.example.model.Customer" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Customer</title>
                <link rel="stylesheet"
                    href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

            </head>

            <body class="bg-light">
                <s:set var="section" value="'customer'" scope="request" />
                <div class="container">
                    <h2 class="bg-info text-white text-center">QUẢN LÝ KHÁCH HÀNG</h2>
                </div>

                <%@ include file="/WEB-INF/views/common/navbar.jsp" %>

                    <div>
                        <form id="searchForm" method="get" class="form-inline mb-2">
                            <input id="searchName" type="text" name="name" placeholder="Nhập họ tên"
                                class="form-control mr-1" />
                            <input id="searchEmail" type="text" name="email" placeholder="Nhập email"
                                class="form-control mr-1" />

                            <select id="searchStatus" name="status" class="form-control mr-1">
                                <option value="">Chọn trạng thái</option>
                                <option value="1">Đang hoạt động</option>
                                <option value="0">Tạm khóa</option>
                            </select>

                            <input id="searchAddress" type="text" name="email" placeholder="Nhập địa chỉ"
                                class="form-control mr-1" />

                            <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Tìm kiếm</button>
                            <a href="#" id="clearSearchBtn" class="btn btn-secondary ml-1"><i
                                    class="bi bi-x-circle"></i> Xóa tìm</a>
                        </form>

                        <div class="mb-2">
                            <a id="btnAdd" class="btn btn-secondary ml-1"><i class="bi bi-person-fill-add"
                                    style="color: blue"></i>Thêm mới</a>
                            <!-- IMPORT -->
                            <label class="btn btn-success" for="importFile">
                                <i class="bi bi-upload"></i> Import CSV
                                <input type="file" id="importFile" name="file" accept=".csv, .xlsx" hidden>
                            </label>

                            <!-- EXPORT -->
                            <button id="exportBtn" class="btn btn-success">
                                <i class="bi bi-download"></i> Export CSV
                            </button>
                        </div>
                        <div class="d-flex align-items-center justify-content-end" id="total">
                                   
                        </div>

                    </div>


                    <table id="customerTable" class="table table-bordered table-striped text-center">
                        <thead class="thead-light">
                            <tr>
                                <th>#</th>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Địa chỉ</th>
                                <th>Điện thoại</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody id="customerTableBody">

                        </tbody>
                    </table>


                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center" id="pagination">
                        </ul>
                    </nav>


                    <!-- Modal Thêm mới khách hàng -->
                    <div class="modal fade" id="addCustomerModal" tabindex="-1" role="dialog"
                        aria-labelledby="addCustomerModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="addCustomerModalLabel"></h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <form id="addCustomerForm">
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
                                            <label for="newPhone">Điện thoại:</label>
                                            <input type="tel" class="form-control" id="newPhone" name="phone" required>
                                            <small class="text-danger" id="phoneError"></small>
                                        </div>
                                        <div class="form-group">
                                            <label for="newAddress">Địa chỉ:</label>
                                            <input type="text" class="form-control" id="newAddress" name="newAddress"
                                                required>
                                            <small class="text-danger" id="addressError"></small>
                                        </div>


                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                    <button type="button" class="btn btn-primary" id="saveCustomerBtn">Lưu</button>
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

                            loadCustomer(1);
                            // fetch data user
                            function loadCustomer(page = 1) {
                                let searchParams = {
                                    name: $('#searchName').val() ?? '',
                                    email: $('#searchEmail').val() ?? '',
                                    status: $('#searchStatus').val() ?? '',
                                    address: $('#searchAddress').val() ?? ''
                                };
                                console.log('loadUser function called for page:', page);
                                $.ajax({
                                    url: 'getFilteredCustomer',
                                    type: 'GET',
                                    data: {
                                        name: searchParams.name,
                                        email: searchParams.email,
                                        status: searchParams.status,
                                        address: searchParams.address,
                                        page: page
                                    },
                                    dataType: 'json',
                                    success: function (response) {
                                        console.log('Response:', response);
                                        let tableBody = $('#customerTableBody');
                                        tableBody.empty();


                                        // Hiển thị danh sách user
                                        if (response.data && response.data.length > 0) {
                                            console.log('Response:', response);
                                            const startIndex = (page - 1) * response.paginationInfo.pageSize;
                                            $.each(response.data, function (index, customer) {
                                                let row = '<tr>' +
                                                    '<td>' + (startIndex + index + 1) + '</td>' +
                                                    '<td>' + customer.customer_name + '</td>' +
                                                    '<td>' + customer.email + '</td>' +
                                                    '<td>' + (customer.address) + '</td>' +
                                                    '<td>' + (customer.tel_num) + '</td>' +
                                                    '<td>' +
                                                    '<a class="editUser text-info mr-2" data-id="' + customer.customer_id + '"><i class="bi bi-pencil-fill" style="color: blue"></i></a>' +
                                                    '</td>' +
                                                    '</tr>';
                                                tableBody.append(row);
                                            });

                                            $('#total').html('<p>Hiển thị từ ' + (startIndex + 1) + ' ~ ' + (startIndex + response.data.length) + ' trong tổng số ' + response.paginationInfo.totalCustomers + ' khách hàng</p>');


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
                                                    loadCustomer(page);
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
                                loadCustomer(1);
                            });

                            $('#clearSearchBtn').click(function (e) {
                                e.preventDefault();


                                $('#searchName').val('');
                                $('#searchEmail').val('');
                                $('#searchAddress').val('');
                                $('#searchStatus').val('');


                                loadCustomer(1);
                            });




                            //Validate add user
                            $('#btnAdd').on('click', function () {
                                $('#addCustomerForm')[0].reset();
                                $('#addCustomerModalLabel').text('Thêm khách hàng');

                                $('#addCustomerModal').modal('show');
                            });



                            $('#addCustomerModal').on('show.bs.modal', function () {

                                const errorIds = ['#nameError', '#emailError', '#phoneError', '#addressError'];
                                errorIds.forEach(id => $(id).text(''));
                            });


                            $('#saveCustomerBtn').on('click', function () {
                                let name = $('#newName').val().trim();
                                let email = $('#newEmail').val().trim();
                                let phone = $('#newPhone').val().trim();
                                let address = $('#newAddress').val().trim();

                                const errorIds = ['#nameError', '#emailError', '#phoneError', '#addressError'];
                                errorIds.forEach(id => $(id).text(''));

                                let specialCharRegex = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;
                                let emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                                const phoneRegex = /^0\d{9}$/;
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

                                if (!phone) {
                                    $('#phoneError').text('Điện thoại không được để trống');
                                    hasError = true;
                                } else if (phoneRegex.test(phone)) {
                                    $('#phoneError').text('Điện thoại không đúng định dạng');
                                    hasError = true;
                                }

                                if (!address) {
                                    $('#addressError').text('Địa chỉ không được để trống');
                                    hasError = true;
                                }


                                if (hasError) return;

                                $.ajax({
                                    url: 'checkCustomerExist',
                                    method: 'POST',
                                    data: {
                                        customer_id: 0,
                                        email: email
                                    },
                                    dataType: 'json',
                                    success: function (response) {
                                        if (response.exist) {
                                            $('#emailError').text('Email đã tồn tại.');
                                        } else {

                                            $.ajax({
                                                url: 'addCustomer',
                                                method: 'POST',
                                                data: {
                                                    name: name,
                                                    email: email,
                                                    tel_num: phone,
                                                    address: address
                                                },
                                                dataType: 'json',
                                                success: function (response) {
                                                    if (response.success) {
                                                        alert("Thêm thành công");
                                                        $('#addCustomerForm')[0].reset();
                                                        loadCustomer();
                                                    } else {
                                                        alert("Thêm thất bại");
                                                    }
                                                    $('#addCustomerModal').modal('hide');
                                                },
                                                error: function () {
                                                    alert("Lỗi khi thêm");
                                                    $('#addCustomerModal').modal('hide');
                                                }

                                            });
                                        }
                                    }

                                });
                            });


                            // edit customer
                            $(document).on('click', '.editUser', function (e) {
                                e.preventDefault();

                                const row = $(this).closest('tr');
                                const id = $(this).data('id');
                                console.log(id);


                                const name = row.find('td:eq(1)').text().trim();
                                const email = row.find('td:eq(2)').text().trim();
                                const address = row.find('td:eq(3)').text().trim();
                                const tel = row.find('td:eq(4)').text().trim();

                                // Chuyển các ô sang input
                                row.find('td:eq(1)').html('<input type="text" class="form-control form-control-sm edit-name" value="' + name + '">');
                                row.find('td:eq(2)').html('<input type="email" class="form-control form-control-sm edit-email" value="' + email + '">');
                                row.find('td:eq(3)').html('<input type="text" class="form-control form-control-sm edit-address" value="' + address + '">');
                                row.find('td:eq(4)').html('<input type="text" class="form-control form-control-sm edit-tel" value="' + tel + '">');

                                // Thay nút "Edit" bằng "Save" và "Cancel"
                                row.find('td:eq(5)').html('<a href="#" class="saveEdit text-success mr-2" data-id="' + id + '"><i class="bi bi-check-lg"></i></a>' +
                                    '<a href="#" class="cancelEdit text-secondary" data-id="' + id + '"><i class="bi bi-x-lg"></i></a>');
                            });

                            // save edit
                            $(document).on('click', '.saveEdit', function (e) {
                                e.preventDefault();

                                const row = $(this).closest('tr');
                                const id = $(this).data('id');
                                console.log(id);


                                const name = row.find('.edit-name').val().trim();
                                const email = row.find('.edit-email').val().trim();
                                const address = row.find('.edit-address').val().trim();
                                const tel = row.find('.edit-tel').val().trim();

                                // Validation
                                if (name === '' || email === '' || tel === '') {
                                    alert('Vui lòng điền đầy đủ tên, email và số điện thoại!');
                                    return;
                                }

                                const phoneRegex = /^0\d{9}$/;
                                if (!phoneRegex.test(tel)) {
                                    alert('Số điện thoại không hợp lệ!');
                                    return;
                                }

                                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                if (!emailRegex.test(email)) {
                                    alert('Email không đúng định dạng!');
                                    return;
                                }

                                // Gửi request cập nhật
                                $.ajax({
                                    url: 'checkCustomerExist',
                                    method: 'POST',
                                    data: {
                                        customer_id: id,
                                        email: email
                                    },
                                    dataType: 'json',
                                    success: function (response) {
                                        if (response.exist) {
                                            alert("email đã tồn tại");
                                        } else {
                                            $.ajax({
                                                url: 'updateCustomer',
                                                type: 'POST',
                                                data: {
                                                    customer_id: id,
                                                    name: name,
                                                    email: email,
                                                    tel_num: tel,
                                                    address: address,

                                                },
                                                success: function (response) {
                                                    if (response.success) {

                                                        row.find('td:eq(1)').text(name);
                                                        row.find('td:eq(2)').text(email);
                                                        row.find('td:eq(3)').text(address);
                                                        row.find('td:eq(4)').text(tel);

                                                        row.find('td:eq(5)').html
                                                            (
                                                                `<a class="editUser text-info mr-2" data-id="${id}">
                                                                <i class="bi bi-pencil-fill" style="color: blue"></i>
                                                                </a>`
                                                            );
                                                    } else {
                                                        alert('Cập nhật thất bại');
                                                    }
                                                },
                                                error: function () {
                                                    alert('Lỗi kết nối server!');
                                                }
                                            });


                                        }
                                    }

                                });


                            });


                            // cancel edit
                            $(document).on('click', '.cancelEdit', function (e) {
                                e.preventDefault();

                                const row = $(this).closest('tr');
                                const id = $(this).data('id');


                                loadCustomer();
                            });

                            $('#importFile').on('change', function () {
                                const file = $('#importFile')[0];
                                if (!file) return;

                                let formData = new FormData();
                                formData.append("file", file.files[0]);

                                $.ajax({
                                    url: 'importCustomer',
                                    type: 'POST',
                                    data: formData,
                                    processData: false,
                                    contentType: false,
                                    success: function (response) {
                                        if (response.success) {
                                            alert('Import thành công!');
                                            loadCustomer();
                                        } else {
                                            alert('Có dòng bị lỗi:\n' + response.errors.join('\n'));
                                            loadCustomer();
                                        }
                                    },
                                    error: function () {
                                        alert('Lỗi khi import dữ liệu!');
                                    }
                                });
                            });

                            // $('#exportBtn').on('click', function () {
                            //     let searchParams = {
                            //         name: $('#searchName').val() ?? '',
                            //         email: $('#searchEmail').val() ?? '',
                            //         status: $('#searchStatus').val() ?? '',
                            //         address: $('#searchAddress').val() ?? ''
                            //     };
                            //     console.log(searchParams);
                            //     let queryString = $.param(searchParams);
                            //     window.location.href = 'exportCustomer.action?' + queryString;
                            // });

                            $('#exportBtn').on('click', function () {
                                let searchParams = {
                                    name: $('#searchName').val().trim() || '',
                                    email: $('#searchEmail').val().trim() || '',
                                    status: $('#searchStatus').val().trim() || '',
                                    address: $('#searchAddress').val().trim() || '',
                                    page: parseInt($('#page').val()) || 1,
                                    pageSize: parseInt($('#pageSize').val()) || 20
                                };
                                console.log("Export parameters:", searchParams);

                                $.ajax({
                                    url: 'exportCustomer.action',
                                    method: 'GET',
                                    data: searchParams,
                                    xhrFields: {
                                        responseType: 'blob' 
                                    },
                                    success: function (data, status, xhr) {
                                        let contentType = xhr.getResponseHeader('Content-Type');
                                        if (contentType.includes('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')) {
                                        
                                            let disposition = xhr.getResponseHeader('Content-Disposition');
                                            let filename = disposition ? disposition.split('filename=')[1].replace(/"/g, '') : 'customers.xlsx';
                                            let blob = new Blob([data], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
                                            let link = document.createElement('a');
                                            link.href = window.URL.createObjectURL(blob);
                                            link.download = filename;
                                            link.click();
                                        } else {
                                            
                                            data.text().then(text => {
                                                alert("Error: " + text);
                                            });
                                        }
                                    },
                                    error: function (xhr, status, error) {
                                        alert("Error exporting data: " + error);
                                    }
                                });
                            });


                        });


                    </script>
            </body>

            </html>